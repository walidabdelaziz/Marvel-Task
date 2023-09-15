//
//  CachingManager.swift
//  Marvel Task
//
//  Created by Walid Ahmed on 14/09/2023.
//

import Foundation
import RealmSwift
import Kingfisher

class CachingManager {
    static func configRealm() {
        let config = Realm.Configuration(
            schemaVersion: UInt64(Consts.REALM_VERSION),
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 1 {
                }
            }
        )
        Realm.Configuration.defaultConfiguration = config
    }
    static func cacheCharactersData(characters: [Character]) {
           for character in characters {
               let cachedItem = CachedItems()
               // Save "info data" to Realm
               saveInfoData(cachedItem: cachedItem, character: character)
               // Save "comics" to Realm
               saveComicsSection(cachedItem: cachedItem, character: character)
//               // Save "series" to Realm
               saveSeriesSection(cachedItem: cachedItem, character: character)
               // Save "thumbnail" to Realm
               saveThumbnail(cachedItem: cachedItem, character: character)
           }
       }

    static func saveInfoData(cachedItem: CachedItems,character: Character){
        cachedItem.id = character.id!
        cachedItem.name = character.name ?? ""
        cachedItem.descriptionField = character.description?.isEmpty == true || character.description == "" ? "N/A" : character.description
    }
    static func saveThumbnail(cachedItem: CachedItems,character: Character){
        if let thumbnailPath = character.thumbnail?.path,
           let thumbnailExtension = character.thumbnail?.thumbnailExtension,
           let imageUrl = URL(string: "\(thumbnailPath).\(thumbnailExtension)") {

            // Use Kingfisher to download and cache the image
            let resource = KF.ImageResource(downloadURL: imageUrl)
            KingfisherManager.shared.retrieveImage(with: resource) { result in
                switch result {
                case .success(let imageResult):
                    // Convert image to data
                    if let data = imageResult.image.pngData() {
                        cachedItem.thumbnailData = data
                        addDataToRealm(cachedItem: cachedItem)
                    }
                case .failure(let error):
                    print("Error downloading image: \(error)")
                }
            }
        }
    }
    static func saveComicsSection(cachedItem: CachedItems, character: Character) {
        if let comics = character.comics {
            if let comicsItems = comics.items {
                for comicsItem in comicsItems {
                    // Check if a CachedSections object with the same resourceURI already exists
                    if let existingComicsItem = cachedItem.comics.first(where: { $0.resourceURI == comicsItem.resourceURI }) {
                        // Update the existing object
                        try! Realm().write {
                            existingComicsItem.name = comicsItem.name ?? ""
                        }
                    } else {
                        // Create a new CachedSections object
                        let comicsItemRealm = CachedSections()
                        comicsItemRealm.resourceURI = comicsItem.resourceURI ?? ""
                        comicsItemRealm.name = comicsItem.name ?? ""
                        cachedItem.comics.append(comicsItemRealm)
                    }
                }
            }
        }
    }

    static func saveSeriesSection(cachedItem: CachedItems, character: Character) {
        if let series = character.series {
            if let seriesItems = series.items {
                for seriesItem in seriesItems {
                    // Check if a CachedSections object with the same resourceURI already exists
                    if let existingSeriesItem = cachedItem.series.first(where: { $0.resourceURI == seriesItem.resourceURI }) {
                        try! Realm().write {
                            existingSeriesItem.name = seriesItem.name ?? ""
                        }
                    } else {
                        let seriesItemRealm = CachedSections()
                        seriesItemRealm.resourceURI = seriesItem.resourceURI ?? ""
                        seriesItemRealm.name = seriesItem.name ?? ""
                        cachedItem.series.append(seriesItemRealm)
                    }
                }
            }
        }
    }

    static func addDataToRealm(cachedItem: CachedItems){
        DispatchQueue.global().async {
            autoreleasepool {
                let realm = try! Realm()
                try! realm.write {
                    realm.add(cachedItem, update: .all)
                }
            }
        }
    }
    static func getCachedCharacters() -> [Character] {
           let realm = try! Realm()
           let cachedCharacters = realm.objects(CachedItems.self)

           var characters: [Character] = []
           for cachedCharacter in cachedCharacters {
               var character = Character()
               character.id = cachedCharacter.id
               character.name = cachedCharacter.name
               character.description = cachedCharacter.descriptionField
               character.cachedThumbnailData = cachedCharacter.thumbnailData

               // Load the cached comics for the character
               let comics = Array(cachedCharacter.comics).map { comicsItem in
                   SectionsItem(resourceURI: comicsItem.resourceURI, name: comicsItem.name)
               }
               character.comics = Sections(available: comics.count, collectionURI: "", items: comics)
               // Load the cached series for the character
               let series = Array(cachedCharacter.series).map { seriesItem in
                   SectionsItem(resourceURI: seriesItem.resourceURI, name: seriesItem.name)
               }
               character.series = Sections(available: series.count, collectionURI: "", items: series)
               characters.append(character)
           }
           return characters
       }
}

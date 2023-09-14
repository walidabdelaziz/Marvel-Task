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

    static func cacheCharactersData(characters: [Character]) {
        for character in characters {
            let cachedItem = CachedItems()
            cachedItem.id = character.id!
            cachedItem.name = character.name ?? ""
            cachedItem.descriptionField = character.description?.isEmpty == true || character.description == "" ? "N/A" : character.description

            // Check if there's a valid image URL
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
                            DispatchQueue.global().async {
                                autoreleasepool {
                                    let realm = try! Realm()
                                    try! realm.write {
                                        cachedItem.thumbnailData = data
                                        // Add the cached item to Realm
                                        realm.add(cachedItem, update: .all)
                                    }
                                }
                            }
                        }
                    case .failure(let error):
                        print("Error downloading image: \(error)")
                    }
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
            // Load the cached image using Kingfisher
            character.cachedThumbnailData = cachedCharacter.thumbnailData
            characters.append(character)
        }
        return characters
    }

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
}

//
//  Characters.swift
//  Marvel Task
//
//  Created by Walid Ahmed on 14/09/2023.
//

import Foundation
import RxDataSources

struct CharactersModel: Codable {
    var code: Int?
    var data: CharactersResults?
}

// MARK: - DataClass
struct CharactersResults: Codable {
    var offset, limit, total, count: Int?
    var results: [Character]?
}

// MARK: - Result
struct Character: Codable {
    var id: Int?
    var name, description: String?
    var modified: String?
    var thumbnail: Thumbnail?
    var resourceURI: String?
    var comics, series, events: Sections?
    var cachedThumbnailData: Data?
}

// MARK: - Comics
struct Sections: Codable {
    var available: Int?
    var collectionURI: String?
    var items: [SectionsItem]?
    var returned: Int?
}

// MARK: - ComicsItem
struct SectionsItem: Codable {
    var resourceURI: String?
    var name: String?
}

// MARK: - Thumbnail
struct Thumbnail: Codable {
    var path,thumbnailExtension: String?

    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
}

struct GenericSectionModel {
    var title: String
    var items: [SectionsItem]
}
extension GenericSectionModel: SectionModelType {
    typealias Item = SectionsItem
    init(original: GenericSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}

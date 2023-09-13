//
//  Characters.swift
//  Marvel Task
//
//  Created by Walid Ahmed on 14/09/2023.
//

import Foundation
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
    var comics, series: Comics?
    var stories: Stories?
    var events: Comics?
}

// MARK: - Comics
struct Comics: Codable {
    var available: Int?
    var collectionURI: String?
    var items: [ComicsItem]?
    var returned: Int?
}

// MARK: - ComicsItem
struct ComicsItem: Codable {
    var resourceURI: String?
    var name: String?
}

// MARK: - Stories
struct Stories: Codable {
    var available: Int?
    var collectionURI: String?
    var items: [StoriesItem]?
    var returned: Int?
}

// MARK: - StoriesItem
struct StoriesItem: Codable {
    var resourceURI: String?
    var name: String?
    var type: String?
}

// MARK: - Thumbnail
struct Thumbnail: Codable {
    var path,thumbnailExtension: String?

    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
}

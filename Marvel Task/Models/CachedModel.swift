//
//  CachedModel.swift
//  Marvel Task
//
//  Created by Walid Ahmed on 14/09/2023.
//

import Foundation
import RealmSwift

class CachedItems: Object, Codable {
    
    override static func primaryKey() -> String? {
        return "id"
    }
    @objc dynamic var id = 0
    @objc dynamic var name: String?
    @objc dynamic var thumbnail: String?
    @objc dynamic var thumbnailData: Data?
    @objc dynamic var descriptionField: String?
}
//
//  CachedModel.swift
//  Marvel Task
//
//  Created by Walid Ahmed on 14/09/2023.
//

import Foundation
import RealmSwift

class CachedItems: Object{
    override static func primaryKey() -> String? {
        return "id"
    }
    @objc dynamic var id = 0
    @objc dynamic var name: String?
    @objc dynamic var thumbnailData: Data?
    @objc dynamic var descriptionField: String?
    var comics = List<CachedSections>()
    var series = List<CachedSections>()
}
class CachedSections: Object {
    @objc dynamic var resourceURI: String = ""
    @objc dynamic var name: String = ""
}

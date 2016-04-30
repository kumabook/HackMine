//
//  Project.swift
//  HackMine
//
//  Created by Hiroki Kumamoto on 5/1/16.
//  Copyright © 2016 kumabook. All rights reserved.
//

import Foundation
import Himotoki


public struct Project: RESTfulItem {
    public static var collectionName: String = "projects"
    public let id:          Int
    public let name:        String
    public let identifier:  String?
    public let description: String?
    public let status:      Int?
    public let isPublic:    Bool?
    public let createdOn:   String?
    public let updatedOn:   String?

    public static func decode(e: Extractor) throws -> Project {
        return try Project(
                     id: e <|  "id",
                   name: e <|  "name",
             identifier: e <|? "identifier",
            description: e <|? "description",
                 status: e <|? "status",
               isPublic: e <|? "is_public",
              createdOn: e <|? "created_on",
              updatedOn: e <|? "updated_on"
        )
    }
    public func show() {
        print("\(id): \(name)")
    }
}

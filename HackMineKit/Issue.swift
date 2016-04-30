//
//  Issue.swift
//  HackMine
//
//  Created by Hiroki Kumamoto on 4/30/16.
//  Copyright © 2016 kumabook. All rights reserved.
//

import Foundation
import Himotoki
import ReactiveCocoa
import APIKit

public struct Issue: RESTfulItem {
    public static var collectionName: String = "issues"
    public let id:          Int
    public let project:     Project
    public let tracker:     Tracker
    public let status:      Status
    public let priority:    Priority
    public let author:      User
    public let assignedTo:  User
    public let subject:     String
    public let description: String
    public let startDate:   String
    public let doneRatio:   Int
    public let createdOn:   String
    public let updatedOn:   String
    public static func decode(e: Extractor) throws -> Issue {
        return try Issue(
              id: e <| "id",
         project: e <| "project",
         tracker: e <| "tracker",
          status: e <| "status",
        priority: e <| "priority",
          author: e <| "author",
      assignedTo: e <| "assigned_to",
         subject: e <| "subject",
     description: e <| "description",
       startDate: e <| "start_date",
       doneRatio: e <| "done_ratio",
       createdOn: e <| "created_on",
       updatedOn: e <| "updated_on"
        )
    }
    public func show() {
        print("\(id): \(subject)")
    }
}

public struct Tracker: Decodable {
    public let id:   Int
    public let name: String

    public static func decode(e: Extractor) throws -> Tracker {
        return try Tracker(
              id: e <| "id",
            name: e <| "name"
        )
    }
}

public struct Status: Decodable {
    public let id:   Int
    public let name: String
    
    public static func decode(e: Extractor) throws -> Status {
        return try Status(
              id: e <| "id",
            name: e <| "name"
        )
    }
}

public struct Priority: Decodable {
    public let id:   Int
    public let name: String
    
    public static func decode(e: Extractor) throws -> Priority {
        return try Priority(
              id: e <| "id",
            name: e <| "name"
        )
    }
}

public struct User: Decodable {
    public let id:   Int
    public let name: String
    
    public static func decode(e: Extractor) throws -> User {
        return try User(
              id: e <| "id",
            name: e <| "name"
        )
    }
}
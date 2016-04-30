//
//  HackMineCommand.swift
//  HackMine
//
//  Created by Hiroki Kumamoto on 4/29/16.
//  Copyright © 2016 kumabook. All rights reserved.
//

import HackMineKit
import Result
import Commandant
import ReactiveCocoa

public struct IndexItemCommand<Item: RESTfulItem>: CommandType {
    public let verb = Item.collectionName
    public let function = "Get \(Item.collectionName)"
    
    public func run(options: NoOptions<NSError>) -> Result<(), NSError> {
        let baseURL = NSURL(string: "http://localhost:3000")!
        let result = Item.index(baseURL).mapError { e in
            NSError(domain: "hack-mine", code: e._code, userInfo: [:])
        }.single()
        if let items = result?.value?.items {
            items.forEach { item in
                item.show()
            }
        }
        return .Success()
    }
}

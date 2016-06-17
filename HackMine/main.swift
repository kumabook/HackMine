//
//  main.swift
//  HackMine
//
//  Created by Hiroki Kumamoto on 4/29/16.
//  Copyright © 2016 kumabook. All rights reserved.
//

import Commandant
import HackMineKit
import ReactiveCocoa


let baseURL = NSURL(string: "")!
var apiKey: String? = ""
var projectId: String = ""
let result = Issue.index(baseURL, apiKey: apiKey, filter: ["project_id":projectId]).mapError { e in HackMineError.Session(e) }.single()
if let items = result?.value?.items {
    items.forEach { item in
        item.show()
    }
} else if let e = result?.error {
    print("Error: \(e)")
}

let registry = CommandRegistry<HackMineError>()
registry.register(IndexItemCommand<Issue>())
registry.register(IndexItemCommand<Project>())

let helpCommand = HelpCommand(registry: registry)
registry.register(helpCommand)

registry.main(defaultVerb: "help") { error in
    fputs("\(error)\n", stderr)
}

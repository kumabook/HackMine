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

let registry = CommandRegistry<HackMineError>()
registry.register(IndexItemCommand<Issue>())
registry.register(IndexItemCommand<Project>())

let helpCommand = HelpCommand(registry: registry)
registry.register(helpCommand)

registry.main(defaultVerb: "help") { error in
    fputs("\(error)\n", stderr)
}

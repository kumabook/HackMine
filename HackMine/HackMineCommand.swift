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

public struct IssuesCommand: CommandType {
    public let verb = "issues"
    public let function = "Get issues"
    
    public func run(options: NoOptions<NSError>) -> Result<(), NSError> {
        let result = RedmineAPI().fetchIssues().mapError { e in
            NSError(domain: "hack-mine", code: e._code, userInfo: [:])
        }.single()
        if let issues = result?.value?.issues {
            issues.forEach { issue in
                print(issue.subject)
            }
        }
        return .Success()
    }
}

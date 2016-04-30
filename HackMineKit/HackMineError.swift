//
//  HackMineError.swift
//  HackMine
//
//  Created by Hiroki Kumamoto on 5/1/16.
//  Copyright © 2016 kumabook. All rights reserved.
//

import Foundation
import APIKit

public enum HackMineError: ErrorType {
    case Session(SessionTaskError)
}
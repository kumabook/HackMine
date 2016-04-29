//
//  RedmineAPI.swift
//  HackMine
//
//  Created by Hiroki Kumamoto on 4/29/16.
//  Copyright © 2016 kumabook. All rights reserved.
//

import Foundation
import APIKit
import Himotoki
import ReactiveCocoa

public class RedmineAPI {
    var baseURL: String = "http://localhost:3000"
    var session: SessionTaskType?
    public init() {
        
    }
    public func fetchIssues() -> SignalProducer<PaginatedIssueResponse, SessionTaskError> {
        return SignalProducer { observer, disposable in
            let request = PaginatedIssueRequest(baseURL: NSURL(string: self.baseURL)!, offset: 0)
            let queue: dispatch_queue_t? = dispatch_get_global_queue(0, 0)
            self.session = Session.sharedSession.sendRequest(request, queue: queue) { result in
                switch result {
                case .Success(let res):
                    observer.sendNext(res)
                    observer.sendCompleted()
                case .Failure(let error):
                    observer.sendFailed(error)
                }
            }
            disposable.addDisposable {
                self.session?.cancel()
            }
        }
    }
}

protocol RedmineRequestType: RequestType {
    
}


extension RedmineRequestType {
}

public struct PaginatedIssueResponse: Decodable {
    public var issues:     [Issue]
    public var totalCount: Int
    public var offset:     Int
    public var limit:      Int
    
    public static func decode(e: Extractor) throws -> PaginatedIssueResponse {
        return try PaginatedIssueResponse(
            issues: e <|| "issues",
        totalCount: e <|  "total_count",
            offset: e <|  "offset",
             limit: e <|  "limit"
        )
    }
}

struct PaginatedIssueRequest: RedmineRequestType {
    typealias Response = PaginatedIssueResponse
    var method: HTTPMethod { return .GET }
    var path: String { return "/issues.json" }
    let baseURL: NSURL
    let offset: Int


    func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) throws -> Response {
        let v: Response = try decodeValue(object)
        return v
    }
}
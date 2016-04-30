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

public protocol RESTfulItem: Decodable {
    static var collectionName: String { get }
    static func index(baseURL: NSURL) -> SignalProducer<PaginatedIndexResponse<Self>, SessionTaskError>
    func show()
}

extension RESTfulItem {
    public static func index(baseURL: NSURL) -> SignalProducer<PaginatedIndexResponse<Self>, SessionTaskError> {
        return SignalProducer { observer, disposable in
            let request: PaginatedIndexRequest<Self> = PaginatedIndexRequest(baseURL: baseURL, offset: 0)
            let queue: dispatch_queue_t? = dispatch_get_global_queue(0, 0)
            let session = Session.sharedSession.sendRequest(request, queue: queue) { result in
                switch result {
                case .Success(let res):
                    observer.sendNext(res)
                    observer.sendCompleted()
                case .Failure(let error):
                    observer.sendFailed(error)
                }
            }
            disposable.addDisposable {
                session?.cancel()
            }
        }
    }

}

public struct PaginatedIndexResponse<T: RESTfulItem>: Decodable {
    public typealias Item = T
    public var items:      [T]
    public var totalCount: Int
    public var offset:     Int
    public var limit:      Int

    public static func decode(e: Extractor) throws -> PaginatedIndexResponse {
        return try PaginatedIndexResponse(
                 items: e <|| KeyPath(T.collectionName),
            totalCount: e <|  "total_count",
                offset: e <|  "offset",
                 limit: e <|  "limit"
        )
    }
}

public struct PaginatedIndexRequest<T: RESTfulItem>: RequestType {
    public typealias Response = PaginatedIndexResponse<T>
    public var method:  HTTPMethod { return .GET }
    public var path:    String { return "/\(T.collectionName).json" }
    public let baseURL: NSURL
    public let offset:  Int

    public func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) throws -> Response {
        return try decodeValue(object)
    }
}
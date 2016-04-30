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

public protocol PaginatedItem: Decodable {
    static var collectionName: String { get }
    static func index(baseURL: NSURL) -> SignalProducer<PaginatedResponse<Self>, SessionTaskError>
    func show()
}
extension PaginatedItem {
    public static func index(baseURL: NSURL) -> SignalProducer<PaginatedResponse<Self>, SessionTaskError> {
        return SignalProducer { observer, disposable in
            let request: PaginatedRequest<Self> = PaginatedRequest(baseURL: baseURL, offset: 0)
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

public struct PaginatedResponse<T: PaginatedItem>: Decodable {
    public typealias Item = T
    public var items:      [T]
    public var totalCount: Int
    public var offset:     Int
    public var limit:      Int

    public static func decode(e: Extractor) throws -> PaginatedResponse {
        return try PaginatedResponse(
                 items: e <|| KeyPath(T.collectionName),
            totalCount: e <|  "total_count",
                offset: e <|  "offset",
                 limit: e <|  "limit"
        )
    }
}

public struct PaginatedRequest<T: PaginatedItem>: RequestType {
    public typealias Response = PaginatedResponse<T>
    public var method:  HTTPMethod { return .GET }
    public var path:    String { return "/\(T.collectionName).json" }
    public let baseURL: NSURL
    public let offset:  Int

    public func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) throws -> Response {
        return try decodeValue(object)
    }
}
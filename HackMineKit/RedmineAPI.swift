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
    static func index(baseURL: NSURL, apiKey: String?, filter: [String:AnyObject]) -> SignalProducer<PaginatedIndexResponse<Self>, SessionTaskError>
    func show()
}

extension RESTfulItem {
    public static func index(baseURL: NSURL, apiKey: String?, filter: [String:AnyObject] = [:]) -> SignalProducer<PaginatedIndexResponse<Self>, SessionTaskError> {
        return SignalProducer { observer, disposable in
            let request: PaginatedIndexRequest<Self> = PaginatedIndexRequest(baseURL: baseURL, apiKey: apiKey, offset: 0, limit: 100, filter: filter)
            let session = Session.sharedSession.sendRequest(request, callbackQueue: CallbackQueue.SessionQueue) { result in
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

public protocol RedmineRequest: RequestType {
    var apiKey: String? { get }
}

extension RedmineRequest {
    public func interceptURLRequest(URLRequest: NSMutableURLRequest) throws -> NSMutableURLRequest {
        if let key = apiKey {
            URLRequest.setValue(key, forHTTPHeaderField: "X-Redmine-API-Key")
        }
        return URLRequest
    }
}

public struct PaginatedIndexRequest<T: RESTfulItem>: RedmineRequest {
    public typealias Response = PaginatedIndexResponse<T>
    public var method:  HTTPMethod { return .GET }
    public var path:    String { return "/\(T.collectionName).json" }
    public var queryParameters: [String: AnyObject]? {
        var dic = filter
        if let v = offset { dic["offset"] = v }
        if let v = limit  { dic["limit"]  = v }
        return dic
    }
    public let baseURL: NSURL
    public let apiKey:  String?
    public let offset:  Int?
    public let limit:   Int?
    public let filter:  [String : AnyObject]

    public func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) throws -> Response {
        return try decodeValue(object)
    }
}
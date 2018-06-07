//
//  Response+Extension.swift
//  github-api
//
//  Created by Maxym Krutykh on 6/6/18.
//  Copyright © 2018 Maxym Krutykh. All rights reserved.
//

import Foundation
import Moya
import ObjectMapper
import RxSwift
import RxCocoa

public extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {
    
    /// Maps data received from the signal into an object
    /// which implements the Mappable protocol and returns the result back
    /// If the conversion fails, the signal errors.
    
    public func mapItems<T: BaseMappable>(_ type: T.Type, context: MapContext? = nil) -> Single<[T]> {
        return flatMap { response -> Single<[T]> in
            return Single.just(try response.mapItems(type, context: context))
        }
    }
}

public extension Response {
    /// Maps data received from the signal into an object which implements the Mappable protocol.
    /// If the conversion fails, the signal errors.
    
    public func mapItems<T: BaseMappable>(_ type: T.Type, context: MapContext? = nil) throws -> [T] {
        guard let json = try mapJSON() as? [String: Any],
            let data = json["items"],
            let object = Mapper<T>(context: context).mapArray(JSONObject: data) else {
                throw MoyaError.jsonMapping(self)
        }
        return object
    }
}


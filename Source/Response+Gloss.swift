//
//  Response+Gloss.swift
//
//  Created by steven rogers on 4/5/16.
//  Copyright (c) 2016 Steven Rogers
//

import Moya
import Gloss

/// Moya-Gloss extension for Moya.Response to allow Gloss bindings.
public extension Response {
  
  /// Maps response data into a model object implementing the Decodable protocol.
  /// Throws a JSONMapping error on failure.
  public func mapObject<T: Decodable>(_ type: T.Type) throws -> T {
    guard
      let json = try mapJSON() as? JSON,
      let result = T(json: json)
    else {
      throw Error.jsonMapping(self)
    }
    return result
  }
  
  /// Maps nested response data into a model object implementing the Decodable protocol.
  /// Throws a JSONMapping error on failure.
  public func mapObject<T: Decodable>(_ type: T.Type, forKeyPath keyPath: String) throws -> T {
    guard
      let json = try mapJSON() as? JSON,
      let nested = json.value(forKeyPath: keyPath) as? JSON,
      let result = T(json: nested)
    else {
      throw Error.jsonMapping(self)
    }
    return result
  }
  
  /// Maps the response data into an array of model objects implementing the Decodable protocol.
  /// Throws a JSONMapping error on failure.
  public func mapArray<T: Decodable>(_ type: T.Type) throws -> [T] {
    guard
      let json = try mapJSON() as? [JSON]
    else {
      throw Error.jsonMapping(self)
    }
    return [T].fromJSONArray(json)!
  }
  
  /// Maps the nested response data into an array of model objects implementing the Decodable protocol.
  /// Throws a JSONMapping error on failure.
  public func mapArray<T: Decodable>(_ type: T.Type, forKeyPath keyPath: String) throws -> [T] {
    guard
      let json = try mapJSON() as? JSON,
      let nested = json.value(forKeyPath: keyPath) as? [JSON]
    else {
      throw Error.jsonMapping(self)
    }
    return [T].fromJSONArray(nested)!
  }
}

//
//  HTTPService.swift
//  RepositoryBrowser
//
//  Created by Anders Lassen on 15/04/2021.
//

import Foundation
import Combine

///
/// High level Interface to a very simpel HTTP request service
///
class HTTPService {
    
    enum Error: Swift.Error {
        
        case HTTPCode(Int)
        case Decoding(String)
        case Encoding(String)
        case ResponseError
        case NoData
    }
    
    ///
    /// Returns JSON object in response to GET request
    ///
    static func getJSON<JSONData:Decodable>(url:URL, accessToken:String? = nil) -> AnyPublisher<JSONData,HTTPService.Error> {
        
        var request = URLRequest(url:url)
        
        request.httpMethod = "GET"

        if let token = accessToken {
            request.addValue("Bearer " + token, forHTTPHeaderField:"authorization")
        }
        
        return urlRequest(request)
    }
    
    ///
    /// Returns JSON object in response to URL request
    ///
    private static func urlRequest<JSONData:Decodable>(_ request: URLRequest) -> AnyPublisher<JSONData,HTTPService.Error> {
        
        return urlRequestData(request)
            .decode(type: JSONData.self, decoder: JSONDecoder())
            .mapError { error -> HTTPService.Error in
                
                if let error = error as? HTTPService.Error {
                    return error
                }
                
                return .Decoding(error.localizedDescription)
        }
        .eraseToAnyPublisher()
    }
    
    ///
    /// Returns Foundation.Data object in response to URL request
    ///
    private static func urlRequestData(_ request: URLRequest) -> AnyPublisher<Data,HTTPService.Error> {

        return Future<Data,Error> { promise in
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                
                if let error = error {
                    
                    promise(.failure(.Decoding(error.localizedDescription)))
                    return
                }
                
                if let resp = response as? HTTPURLResponse {
                    
                    if resp.statusCode != 200 {
                        promise(.failure(.HTTPCode(resp.statusCode)))
                        return
                    }
                    
                } else {
                    
                    promise(.failure(.ResponseError))
                    return
                }
                
                guard data != nil else {
                    
                    promise(.failure(.NoData))
                    return
                }

                // HTTPService.debugPrint(data!)

                promise(.success(data!))
            }
            .resume()
            
        }.eraseToAnyPublisher()
    }
}

///
/// Error messages
///
extension HTTPService.Error {
    
    var localizedDescription: String {
        switch self {
            case let .Decoding(errorDescription): return "Decoding error: " + errorDescription
            case let .Encoding(errorDescription): return "Encoding error: " + errorDescription
            case let .HTTPCode(code): return HTTPCodeMessage(code)
            case .ResponseError: return "Response error"
            case .NoData: return "Data from HTTP request was empty"
        }
    }
    
    func HTTPCodeMessage(_ code: Int) -> String {
        
        var message: String?
        
        switch code {
            case 400: message = "Bad request" // probably because of syntax error in body or something like that
            case 403: message = "Forbidden" // request was understood, but perhaps something is wrong with access rights
        default:
            break
        }
        
        return "HTTP code (\(code)) error" + (message == nil ? "" : " - " + message!)
    }
}

///
/// debug
///
extension HTTPService {
    
    static func debugPrint(_ response: HTTPURLResponse) {
        
        print(response.allHeaderFields)
    }
    
    static func debugPrint(_ data: Data) {

        if let json = String(data: data, encoding: String.Encoding.utf8) {
            print(json)
        }
        
        /// Foundation object, i.e. a NSDictionary
        
        // if let  = try? JSONSerialization.jsonObject(with:data, options:.allowFragments) {
            // print(json)
        // }
    }
}

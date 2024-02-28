//
//  HttpConstants.swift
//  PlantScanner
//
//  Created by FILALI Salah on 27/02/2024.
//

import Foundation

typealias Parameters = [String:Any]

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum ResponseCode {
    
    /**
     * HTTP Status-Code 200: OK.
     */
    static let httpOK = 200
    
    /**
     * HTTP Status-Code 404: Not Found.
     */
    static let httpNotFound = 404
    
    
    
    /**
     * Internet ConnectionError.
     */
    static let internetConnectionError = NSURLErrorNotConnectedToInternet
}

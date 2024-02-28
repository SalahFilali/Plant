//
//  Router.swift
//  PlantScanner
//
//  Created by FILALI Salah on 27/02/2024.
//

import Foundation

protocol Router {
    func requestBuilder() throws -> URLRequest
}

struct RemoteConfiguration {
    static var shared = RemoteConfiguration()
    
    lazy var kDomain = "api.openai.com"
    lazy var kHttpProtocol = "https"
    lazy var kApiUrl = String(format: "%@://%@/v1/chat/completions", kHttpProtocol, kDomain)
    lazy var kAPIQueryComponents: URLComponents = {
        var components = URLComponents()
        components.scheme = kHttpProtocol
        components.host = kDomain
        components.path = "/v1/chat/completions"
        return components
    } ()
    
    
}

// MARK: Needed Constants
enum ContentType: String {
    case json = "application/json"
    case urlEncoded = "application/x-www-form-urlencoded"
    case formData = "multipart/form-data;"
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum FormDataElements {
    static let kBoundary = "----UniqueConsistentStringChronos"
    enum Keys: String {
        case contentDisposition = "Content-Disposition: "
        case contentType = "Content-Type: "
        case fileName = " filename="
        case name = "name="
    }
    enum Values: String {
        case contentDisposition = "form-data; "
        case contentType = "image/jpeg"
        case defaultFileName = "image.jpg"
    }

}

// MARK: Router utilities Functions
extension Router {
    func formDataEncoder(parameters: [String: Any]) -> Data {
        var params = Data()
        for item in parameters {
            params.append(self.encodeParameter(forItem: item))
        }
        return params
    }

    func encodeParameter(forItem item: (key: String, value: Any)) -> Data {
        var data = Data()
        if !(item.value is Data) {
            self.appendParamNameKey(forData: &data)
            data.append("\"\(item.key)\";".data(using: String.Encoding.utf8)!)
            data.append("\r\n\r\n".data(using: String.Encoding.utf8)!)
            data.append("\(item.value)".data(using: String.Encoding.utf8)!)
        } else {
            data.append(self.encodeImageParameter(forItem: item))
        }
        return data
    }

    func encodeImageParameter(forItem item: (key: String, value: Any)) -> Data {
        var data = Data()
        self.appendParamNameKey(forData: &data)
        data.append("\"\(item.key)\";".data(using: String.Encoding.utf8)!)
        data.append(FormDataElements.Keys.fileName.rawValue.data(using: String.Encoding.utf8)!)
        data.append("\"\(FormDataElements.Values.defaultFileName.rawValue)\"".data(using: String.Encoding.utf8)!)
        data.append("\r\n".data(using: String.Encoding.utf8)!)
        data.append(FormDataElements.Keys.contentType.rawValue.data(using: String.Encoding.utf8)!)
        data.append("\(FormDataElements.Values.contentType.rawValue)".data(using: String.Encoding.utf8)!)
        data.append("\r\n\r\n".data(using: String.Encoding.utf8)!)
        data.append(Data(base64Encoded: "\(item.value)")!)

        return data
    }

    func appendBoundary(forData data: inout Data) {
        data.append("\r\n--".data(using: String.Encoding.utf8)!)
        data.append(FormDataElements.kBoundary.data(using: String.Encoding.utf8)!)
        data.append("\r\n".data(using: String.Encoding.utf8)!)
    }

    func appendParamNameKey(forData data: inout Data) {
        self.appendBoundary(forData: &data)
        data.append(FormDataElements.Keys.contentDisposition.rawValue.data(using: String.Encoding.utf8)!)
        data.append(FormDataElements.Values.contentDisposition.rawValue.data(using: String.Encoding.utf8)!)
        data.append(FormDataElements.Keys.name.rawValue.data(using: String.Encoding.utf8)!)
    }
}


//
//  Routerimp.swift
//  PlantScanner
//
//  Created by FILALI Salah on 27/02/2024.
//

import Foundation

enum RouterImp: Router {
    
    case sendImageData(_ data: String, apiKey: String)
    
    private var method: HTTPMethod {
        return .post
    }
    
    private var path: String {
        switch self {
        case .sendImageData:
            return ""
        }
    }
    
    private var parameters: Parameters? {
        switch self {
        case .sendImageData(let data, _):
            return [
                "model": "gpt-4-vision-preview",
                "messages": [
                    [
                    "role": "user",
                    "content": [
                      [
                        "type": "text",
                        "text": "I need assistance with identifying a plant disease from this image"
                      ],
                      [
                        "type": "image_url",
                        "image_url": [
                            "url": "data:image/jpeg;base64,\(data)",
                            "detail": "low"
                        ]
                      ]
                    ]
                  ]
                ]
            ]
            
        }
    }
    
    private var withBody: Bool {
        return true
    }
    
    private var contentType: String {
        return ContentType.json.rawValue
    }
    
    private var authorisation: (String, String)? {
        switch self {
        case .sendImageData(_,let apiKey):
            return ("Authorization", "Bearer \(apiKey)")
        }
    }
    
    private var url: URL? {
        let url = URL(string: RemoteConfiguration.shared.kApiUrl)
        return url?.appendingPathComponent(path)
    }
    
    func requestBuilder() throws -> URLRequest {
        guard let firstUrl = url else { throw NSError(domain: "error", code: -1, userInfo: nil) }
        var urlString = firstUrl.absoluteString
        urlString = String(urlString.dropLast())
        let url = URL(string: urlString)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue(contentType, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        if let (authKey, authValue) = self.authorisation {
            urlRequest.setValue(authValue, forHTTPHeaderField: authKey)
        }
        if let parameters = parameters {
            if self.withBody {
                urlRequest.httpBody = self.formDataEncoder(parameters: parameters)
            } else {
                urlRequest.url = self.queryWith(parameters: parameters, for: url!)
            }
        }
        
        print("url: \(String(describing: urlRequest.url))")
        return urlRequest
    }
    
    private func queryWith(parameters: Parameters, for url: URL) -> URL? {
        var components = RemoteConfiguration.shared.kAPIQueryComponents
        components.path = String(format: "%@%@", components.path, self.path)
        var queryItems: [URLQueryItem] = []
        for param in parameters {
            queryItems.append(URLQueryItem(name: param.key, value: "\(param.value)"))
        }
        components.queryItems = queryItems
        return components.url
    }
    
}

// MARK: Router utilities Functions
extension RouterImp {
    func formDataEncoder(parameters: [String: Any]) -> Data {
        var params = Data()
        do {
            params = try JSONSerialization.data(withJSONObject: parameters)
        } catch _ {
        }
        return params
    }
}



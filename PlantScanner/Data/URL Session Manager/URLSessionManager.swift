//
//  URLSessionManager.swift
//  PlantScanner
//
//  Created by FILALI Salah on 27/02/2024.
//

import Foundation
import Combine


/// This protocol is defined to cancel the latest launched URLSessionDataTask
protocol CancellableTask {
    
    /// Call this method to cancel the latest launched URLSessionDataTask
    func cancelLastTask ()
    
}


final class URLSessionManager: CancellableTask {
    
    // MARK: - Properties
    let session = URLSession.shared
    
    private var latestTask: URLSessionDataTask?
    
    
    // MARK: - Methods
    
    func onSuccess<T: Decodable>(
        _ type: T.Type,
        _ respData: Data?,
        _ httpResponse: HTTPURLResponse
    )  -> Result<T, Error>{
        if respData != nil {
            do {
                let decoder = JSONDecoder()
                let subject = try decoder.decode(T.self, from: respData!)
                return .success(subject)

            } catch {
                print("Error parsing:\(error)")
                return .failure(error)
            }
        } else {
            return .failure(NSError(domain: "", code: 0))
        }
    }
    
    func onFail(
        _ error: Error,
        _ httpResponse: HTTPURLResponse
    ) -> Error {
        return error
    }
    
    
    /// Creates a task that retrieves the contents of the specified URL, then returns an  AnyPublisher with the result.
    /// - Parameter url: The URL to be retrieved.
    /// - Returns: AnyPublisher with Data or Error

    func defaultDataTask<T: Decodable>(
        withRouter router: Router,
        forType type: T.Type
    ) -> AnyPublisher<T, Error> {
        return Future<T, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(NSError(domain: "unknown_repo_error", code: 0)))
                return
            }
            
            let request: URLRequest
            do {
                request = try router.requestBuilder()
            } catch {
                promise(.failure(NSError(domain: "unknown_repo_error", code: 0)))
                return
            }
            
            let task = self.session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
                print("****Response: \(String(data: data!, encoding: .utf8))")
                if let error = error {
                    promise(.failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
                    return
                }
                
                switch httpResponse.statusCode {
                case ResponseCode.httpOK:
                    if let data = data {
                        let result = self.onSuccess(T.self, data, httpResponse)
                        switch result {
                        case .success(let value):
                            promise(.success(value))
                        case .failure(let error):
                            promise(.failure(error))
                        }
                    } else {
                        promise(.failure(NSError(domain: "data_nil_error", code: 0)))
                    }
                default:
                    promise(.failure(self.onFail(NSError(domain: "", code: httpResponse.statusCode), httpResponse)))
                }
            }
            
            self.latestTask = task
            task.resume()
        }
        .eraseToAnyPublisher()
    }
    
    /// Cancels the latest launched URLSessionDataTask
    func cancelLastTask() {
        self.latestTask?.cancel()
    }
}

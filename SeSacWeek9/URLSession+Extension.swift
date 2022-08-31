//
//  URLSession+Extension.swift
//  SeSacWeek9
//
//  Created by 신동희 on 2022/08/30.
//

import Foundation


extension URLSession {
    
    typealias completionHandler = (Data?, URLResponse?, Error?) -> Void
    
    
    @discardableResult
    func customDataTask(_ endPoint: URLRequest, completionHandler: @escaping completionHandler) -> URLSessionDataTask {
    
        let task = self.dataTask(with: endPoint, completionHandler: completionHandler)
        task.resume()
        
        return task
    }
    
    
    static func request<T: Codable>(_ session: URLSession = .shared, endPoint: URLRequest, completion: @escaping (T?, APIError?) -> Void) {
        
        session.customDataTask(endPoint) { data, response, error in
            
            DispatchQueue.main.async {
                guard error == nil else {
                    print("Reailed Request")
                    completion(nil, .failedRequest)
                    return
                }
                
                guard let data = data else {
                    print("No Data Returned")
                    completion(nil, .noData)
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    print("Unable Response")
                    completion(nil, .invalidResponse)
                    return
                }

                guard response.statusCode == 200 else {
                    print("Failed Response")
                    completion(nil, .failedRequest)
                    return
                }
                
                
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    completion(result, nil)
                }
                catch {
                    print(error)
                    completion(nil, .invalidData)
                }
            }
            
        }
        
        
        
        
    }
    
}

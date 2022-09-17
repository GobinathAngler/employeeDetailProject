//
//  NetworkHandler.swift
//  EmployeeDirectory
//
//  Created by Gobinath on 17/09/22.
//

import Foundation

import UIKit

class NetworkHandler {
    static func callWebService(urlString : String, completionHandler:@escaping (Bool, Data?) -> ()) {
        guard let urlLink = URL.init(string: urlString) else { return }
        var request = URLRequest(url: urlLink)
        request.timeoutInterval = 60.0
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let sessionConfiguration = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfiguration)
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if error == nil, let responseData = data {
                    completionHandler(true, responseData)
                }else {
                    completionHandler(false, nil)
                }
            }
        }
        dataTask.resume()
    }
}

//
//  GitHub.swift
//  List Stargazers
//
//  Created by Mattia Cardone on 22/02/2021.
//  Copyright © 2021 Mattia Cardone. All rights reserved.
//

import Foundation

enum Result<Value> {
    case success(Value)
    case failure(Error)
}

class GitHub {

    class func getStargazers(by user: String, repo: String, completion: @escaping ((Result<[Stargazer]>) -> Void)) {
        let url = URL(string: "https://api.github.com/repos")?
            .appendingPathComponent(user)
            .appendingPathComponent(repo)
            .appendingPathComponent("stargazers")

        guard let u = url else {
            return completion(.failure(MyError.wrongUrl))
        }

        var request : URLRequest = URLRequest(url: u)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { (responseData, response, responseError) in
            DispatchQueue.main.async {
                completion(decode(responseData, error: responseError))
            }
        }
     
        task.resume()
    }

    class func decode(_ data: Data?, error: Error?) -> (Result<[Stargazer]>) {
        if error != nil {
            return (.failure(MyError.responseError))
        }

        guard let jsonData = data else {
            return (.failure(MyError.noData))
        }

        do {
            let stargazers = try JSONDecoder().decode([Stargazer].self, from: jsonData)
            return (.success(stargazers))
        } catch {
            return (.failure(error))
        }
    }
}

private enum MyError: Error {
    case responseError
    case noData
    case wrongUrl
}

extension MyError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .responseError:
            return "An error has occurred"
        case .noData:
            return "No data fetched"
        case .wrongUrl:
            return "Unexpected URL creation exception"
        }
    }
}

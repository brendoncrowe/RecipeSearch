//
//  NetworkHelper.swift
//  RecipeSearch
//
//  Created by Brendon Crowe on 1/17/23.
//

import UIKit


enum AppError: Error {
  case badURL(String)
  case noResponse
  case networkClientError(Error)
  case noData
  case decodingError(Error)
  case badStatusCode(Int)
  case badMimeType(String)
}

class NetworkHelper {

  static let shared = NetworkHelper()
  private var session: URLSession

  private init() {
    session = URLSession(configuration: .default)
  }
  
  func performDataTask(with request: URLRequest,
                       completion: @escaping (Result<Data, AppError>) -> ()) {

  
    let dataTask = session.dataTask(with: request) { (data, response, error) in

      if let error = error {
        completion(.failure(.networkClientError(error)))
      }

      guard let urlResponse = response as? HTTPURLResponse else {
        completion(.failure(.noResponse))
        return
      }

      guard let data = data else {
        completion(.failure(.noData))
        return
      }

      switch urlResponse.statusCode {
      case 200...299: break
      default:
        completion(.failure(.badStatusCode(urlResponse.statusCode)))
        return
      }

      completion(.success(data))
    }
    dataTask.resume()
    
  }
  
}

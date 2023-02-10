//
//  UIImage+Extensions.swift
//  RecipeSearch
//
//  Created by Brendon Crowe on 1/17/23.
//


import UIKit

extension UIImageView {
    
    // instance method, works on an instance of UIImageView
    
    func getImage(with urlString: String,
                  completion: @escaping (Result<UIImage, AppError>) ->()) {
        
        // configure UIActivityIndicatorView
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .systemGray2
        activityIndicator.center = center // center implies center of UIImageView
        addSubview(activityIndicator)
        // this line of code adds the UIActivityIndicatorView to the UIImageView
        activityIndicator.startAnimating()
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.badURL(urlString)))
            return
        }
        
        let request = URLRequest(url: url)
        
        NetworkHelper.shared.performDataTask(with: request) { [weak activityIndicator] (result) in
            DispatchQueue.main.async {
                activityIndicator?.stopAnimating()
            }
            switch result {
            case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
            case .success(let data):
                if let image = UIImage(data: data) {
                    completion(.success(image))
                }
            }
        }
    }
}

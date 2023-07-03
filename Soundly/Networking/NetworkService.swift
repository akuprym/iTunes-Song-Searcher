//
//  NetworkService.swift
//  Soundly
//
//  Created by admin on 3.07.23.
//

import Foundation

class NetworkService {
    
    func request(urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                } else {
                    guard let data = data else { return }
                    completion(.success(data))
                }
            }
        }.resume()
    }
}

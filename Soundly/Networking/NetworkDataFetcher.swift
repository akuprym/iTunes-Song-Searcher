//
//  NetworkDataFetcher.swift
//  Soundly
//
//  Created by admin on 4.07.23.
//

import Foundation

class NetworkDataFetcher {
    
    let networkService = NetworkService()
    
    func fetchData(urlString: String, response: @escaping (SearchResponse?) -> Void) {
        networkService.request(urlString: urlString) { result in
            switch result {
                
            case .success(let data):
                do {
                    let tracks = try JSONDecoder().decode(SearchResponse.self, from: data)
                    response(tracks)
                } catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                }
            case .failure(let error):
                print("Error received while requesting data: \(error.localizedDescription)")
                response(nil)
            }
        }

    }
}

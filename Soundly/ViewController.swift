//
//  ViewController.swift
//  Soundly
//
//  Created by admin on 14.06.23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var table: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupSearchBar()
        
        let urlString = "https://itunes.apple.com/search?term=jack+johnson&limit=25"
//        request(urlString: urlString) { searchResponse, error in
//            searchResponse?.results.map({ track in
//                print(track.trackName)
//            })
//        }
        request(urlString: urlString) { result in
            switch result {
                
            case .success(let searchResponse):
                searchResponse.results.map { track in
                    print("Track name:", track.trackName)
                }
            case .failure(let error):
                print("Error:", error)
            }
        }
    }
    
    func request(urlString: String, completion: @escaping (Result<SearchResponse, Error>) -> Void) {
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Some error")
                    completion(.failure(error))
                    return
                } else {
                    guard let data = data else { return }
//                    let someString = String(data: data, encoding: .utf8)
//                    print(someString ?? "no data")
                    do {
                        let tracks = try JSONDecoder().decode(SearchResponse.self, from: data)
                        completion(.success(tracks))
                    } catch let jsonError {
                        print("Failed to decode JSON", jsonError)
                        completion(.failure(jsonError))
                    }
                }
            }
        }.resume()
    }
    
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        navigationController?.navigationBar.prefersLargeTitles = true
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    private func setupTableView() {
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "1"
        return cell
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}

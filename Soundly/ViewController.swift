//
//  ViewController.swift
//  Soundly
//
//  Created by admin on 14.06.23.
//

import UIKit

class ViewController: UIViewController {
    
    let networkDataFetcher = NetworkDataFetcher()
    var searchResponse: SearchResponse? = nil
    var timer: Timer?
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupSearchBar()
     
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
        return searchResponse?.resultCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let track = searchResponse?.results[indexPath.row]
        cell.textLabel?.text = track?.trackName
        return cell
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            let urlString = "https://itunes.apple.com/search?term=\(searchText)&limit=5"

            self.networkDataFetcher.fetchData(urlString: urlString) { searchResponse in
                guard let searchResponse = searchResponse else {return}
                self.searchResponse = searchResponse
                self.table.reloadData()
            }
        })
    }
}

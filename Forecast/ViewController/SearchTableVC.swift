//
//  SearchTableVC.swift
//  Forecast
//
//  Created by Anton Morozov on 18.12.2019.
//  Copyright © 2019 Anton Morozov. All rights reserved.
//

import UIKit
import SwiftLocation

class SearchTableVC: UITableViewController {
    
    var viewModel: SearchViewModalProtocol?
    let tableViewCellId = "tableViewCellId"    
    var searchBar: UISearchBar?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        
        viewModel?.geocodeComplition = { _ in
            self.tableView.reloadData()            
        }
        
        viewModel?.dismissHandler = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar?.resignFirstResponder()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.searchResults?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellId, for: indexPath)
        let place = viewModel?.searchResults?[indexPath.row]
        cell.textLabel?.text = [place?.city, place?.country].compactMap{ $0 }.joined(separator: ", ")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place = viewModel?.searchResults?[indexPath.row]
        viewModel?.selectPlace(place: place)
    }
}

extension SearchTableVC: UISearchBarDelegate {
        
    func setupSearchBar() {
        searchBar?.setupWhite()
        searchBar?.delegate = self
        navigationItem.titleView = searchBar
        searchBar?.becomeFirstResponder()
        let rightNavBarButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = rightNavBarButton
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            viewModel?.finedPlaces(string: searchText)
        }
    }
}

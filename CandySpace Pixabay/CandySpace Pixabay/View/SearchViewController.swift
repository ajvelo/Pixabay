//
//  ViewController.swift
//  CandySpace Pixabay
//
//  Created by Andreas Velounias on 26/03/2020.
//  Copyright © 2020 Andreas Velounias. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    var viewModel: PixabayViewModel!
        
    var activityIndicator: UIActivityIndicatorView? = nil
    var infoLabel: UILabel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup ViewModel
        viewModel = PixabayViewModel(httpClient: HttpClient(with: URLSession.shared))
        
        setupNavigationBarWithSearchController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        displayInformation(with: "Begin your search above", showLoading: false)
    }
    
    // MARK: - View Configurations
    func displayInformation(with text: String, showLoading: Bool) {
        // Show no results label
        if let infoLabel = infoLabel {
            infoLabel.isHidden = false
            infoLabel.text = text
            infoLabel.sizeToFit()
        }
        else {
            let label = UILabel(frame: .zero)
            label.text = text
            label.sizeToFit()
            label.textColor = .gray
            
            label.frame = CGRect(x: view.bounds.width / 2 - label.frame.width / 2, y: Constants.labelTopSpacing, width: label.frame.width, height: label.frame.height)
            
            infoLabel = label
            view.addSubview(infoLabel!)
        }
        
        if let activityIndicator = activityIndicator {
            if showLoading { activityIndicator.startAnimating() }
            else { activityIndicator.stopAnimating() }
        }
            
        else {
            let indicator = UIActivityIndicatorView(style: .medium)
            indicator.hidesWhenStopped = true
            
            if showLoading { indicator.startAnimating() }
            else { indicator.stopAnimating() }
            
            indicator.frame.origin = CGPoint(x: view.bounds.width / 2 - infoLabel!.frame.width / 2 - indicator.frame.width - Constants.spacingOffset, y: Constants.labelTopSpacing)
            
            activityIndicator = indicator
            view.addSubview(activityIndicator!)
        }
    }
    
    func hideInformation() {
        activityIndicator?.stopAnimating()
        infoLabel?.isHidden = true
    }
    
    func setupNavigationBarWithSearchController() {
        title = "Candyspace Pixabay"
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        
        navigationItem.searchController = searchController
    }
    
    func reloadCollection(showInformation: Bool, text: String? = nil, showLoading: Bool = false) {
        DispatchQueue.main.async {
            if showInformation {
                self.displayInformation(with: text!, showLoading: showLoading)
            } else {
                self.hideInformation()
            }
        }
    }
}

// MARK: UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        // clear items here
        viewModel.clearPixabayItems()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        navigationItem.searchController?.isActive = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { print(" No results"); return }
        
        searchBar.resignFirstResponder()
        displayInformation(with: "Searching ...", showLoading: true)
        
        viewModel.searchImages(with: searchText) { result in
            switch result {
            case .success(let response):
                guard let items = response["hits"] as? [[String: Any]] else { return }
                
                if items.count > 0 {
                    for dict in items {
                        guard
                            let user = dict["user"] as? String,
                            let imageURLString = dict["webformatURL"] as? String
                            else { return }
                        self.viewModel.savePixabayItem(item: Pixabay(authorName: user, imageURL: imageURLString))
                    }
                    DispatchQueue.main.async {
                        let storyBoard = UIStoryboard(name: "Main", bundle:nil)
                        let resultsVC = storyBoard.instantiateViewController(withIdentifier: "ResultsCollectionViewController") as! ResultsCollectionViewController
                        resultsVC.viewModel = self.viewModel
                        self.navigationController?.pushViewController(resultsVC, animated: true)
                    }
                }
                else {
                    self.reloadCollection(showInformation: true, text: "No Results")
                }
                
            case .failure(let error):
                print(error)
                self.hideInformation()
            }
        }
    }
}


//
//  ViewController.swift
//  WeatherAppAssignment
//
//  Created by Kevin Varghese on 6/1/23.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {
    
    private var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        return searchBar
    }()
    
    private var displayView: UIHostingController<InformationDisplay>?
    private var viewModel: ViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchBar.delegate = self
        self.VMSetup()
        self.UISetup()
    }

    func VMSetup() {
        let networkManager = NetworkLayer()
        let locationManager = LocationManager()
        viewModel = ViewModel(networkManager: networkManager,
                              locationManager: locationManager)
        if let viewModel = viewModel {
            displayView = UIHostingController(rootView: InformationDisplay(viewModel: viewModel))
        }
    }
    
    func UISetup() {
        let safeArea = view.safeAreaLayoutGuide
        // Adding search bar on top, because adding on bottom will cause the keyboard to hide it
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 40),
            searchBar.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 25),
            searchBar.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -15)
        ])
        
        // Adding the swiftUI view
        guard let displayView = displayView else { return }
        view.addSubview(displayView.view)
        self.addChild(displayView)
        displayView.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            displayView.view.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            displayView.view.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 25),
            displayView.view.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -25),
            displayView.view.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -40)
        ])
    }
}

extension ViewController: UISearchBarDelegate {
    // Used this delegate to make sure updates don't happen after every character entry
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {
            return
        }
        Task {
            await viewModel?.weatherForCity(city: searchText)
        }
        searchBar.resignFirstResponder()
    }
}


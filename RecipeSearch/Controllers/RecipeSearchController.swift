//
//  ViewController.swift
//  RecipeSearch
//
//  Created by Brendon Crowe on 1/16/23.
//

import UIKit

class RecipeSearchController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var recipes = [Recipe]() {
        didSet {
            DispatchQueue.main.async { // remember, if the table view (ui) is being updated, it must be dispatched to the main queue
                self.tableView.reloadData()
            }
        }
    }
    
    var searchQuery = ""
    
    override func viewDidLoad() {
        configVC()
    }
    
    func configVC() {
        super.viewDidLoad()
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.delegate = self
        loadRecipe(searchQuery: "Mac and Cheese")
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Recipe Search"
    }
    
    func loadRecipe(searchQuery: String) {
        RecipeSearchAPI.fetchRecipe(for: searchQuery) { [weak self] (result) in
            switch result {
            case .failure(let appError):
                print("appError: \(appError)")
            case .success(let recipes):
                self?.recipes = recipes
            }
        }
    }
}

extension RecipeSearchController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as? RecipeCell else {
            fatalError("could not dequeue a recipe cell")
        }
        let recipe = self.recipes[indexPath.row]
        cell.configureCell(for: recipe)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
}

extension RecipeSearchController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchText = searchBar.text else {
            print("missing search text")
            return
        }
        loadRecipe(searchQuery: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        recipes.removeAll()
    }
}

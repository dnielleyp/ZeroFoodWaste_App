//
//  SearchRecipesTableViewController.swift
//  ZeroFoodWaste
//
//  Created by Danielle Yap on 5/6/2023.
//

import UIKit

class SearchRecipesTableViewController: UITableViewController, UISearchBarDelegate {

    let CELL_RECIPE = "recipeCell"
    let REQUEST_STRING = "https://www.themealdb.com/api/json/v1/1/search.php?s="

    var newRecipes = [RecipeData]()

    var indicator = UIActivityIndicatorView()
    
    var index: Int?

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for recipes..."
        searchController.searchBar.showsCancelButton = false
        
        navigationItem.searchController = searchController
        
        navigationItem.hidesSearchBarWhenScrolling = false

        indicator.style = UIActivityIndicatorView.Style.large
        indicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(indicator)

        NSLayoutConstraint.activate([indicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor), indicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)])
    }
    

    func requestRecipes(_ recipeName: String) async {

        guard let queryString = recipeName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("Query string can't be encoded.")
            return
        }
        
        guard let requestURL = URL(string: REQUEST_STRING + queryString) else {
            print("Invalid URL")
            return
        }
        
        let urlRequest = URLRequest(url: requestURL)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            self.indicator.stopAnimating()
            
            let decoder = JSONDecoder()
            let foodData = try decoder.decode(FoodData.self, from: data)
            
            
            if let recipes = foodData.recipes {
                newRecipes.append(contentsOf: recipes)
                tableView.reloadData()
            }
        }
        catch let error {
            print("ERROR: ",error)
        }

    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        newRecipes.removeAll()
        tableView.reloadData()


        //guard against the search bar text being nil or empty.
        guard let searchText = searchBar.text else {
            return
        }
        
        navigationItem.searchController?.dismiss(animated: true)
        indicator.startAnimating()
        
        Task {
            URLSession.shared.invalidateAndCancel()
//            currentRequestIndex = 0
            await requestRecipes(searchText)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return newRecipes.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_RECIPE, for: indexPath)

        let recipe = newRecipes[indexPath.row]
        cell.textLabel?.text = recipe.name
              
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.index = indexPath.row
        
        self.performSegue(withIdentifier: "showRecipeSegue", sender: self)
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showRecipeSegue" {
            let destination = segue.destination as! RecipeViewController
            
            destination.recipe = newRecipes[index!]
        }
    }
    

}

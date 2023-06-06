//
//  SearchRecipesTableViewController.swift
//  ZeroFoodWaste
//
//  Created by Danielle Yap on 5/6/2023.
//

import UIKit

class SearchRecipesTableViewController: UITableViewController, UISearchBarDelegate {

    let CELL_RECIPE = "recipeCell"
    let REQUEST_STRING = "https://tasty.p.rapidapi.com/recipes/list?from="

    var newRecipes = [RecipeData]()

    var indicator = UIActivityIndicatorView()

    

    override func viewDidLoad() {
        super.viewDidLoad()

        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for recipes..."
        searchController.searchBar.showsCancelButton = true

        navigationItem.hidesSearchBarWhenScrolling = false

        indicator.style = UIActivityIndicatorView.Style.large
        indicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(indicator)

        NSLayoutConstraint.activate([indicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor), indicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)])


    }

    func requestRecipes(_ recipeName: String) async {

        guard let queryString = recipeName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("Query string cannot be encoded haha sucks to be u")
            return
        }

        guard let requestURL = URL(string: REQUEST_STRING + queryString) else {
            print("invalid url hehe")
            return
        }

        let urlRequest = URLRequest(url: requestURL)

        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            indicator.stopAnimating()

            let decoder = JSONDecoder()
            let recipeData = try decoder.decode(FoodData.self, from: data)

            if let recipe = recipeData.recipeList {
                newRecipes.append(contentsOf: recipe)

                tableView.reloadData()
            }
        }
        catch let error {
            print(error)
        }



    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        newRecipes.removeAll()
        tableView.reloadData()

        navigationItem.searchController?.dismiss(animated: true)
        indicator.startAnimating()

        //guard against the search bar text being nil or empty.
        guard let searchText = searchBar.text else {
            print("here")
            return
        }

        Task {
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
        return 1
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_RECIPE, for: indexPath)
        
        

//        let recipe = newRecipes[indexPath.row]
        cell.textLabel?.text = "RECIPEPPEPEPE"
        
        print("recipename", newRecipes)
        
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

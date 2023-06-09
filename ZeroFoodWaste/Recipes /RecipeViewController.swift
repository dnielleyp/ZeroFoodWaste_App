//
//  RecipeViewController.swift
//  ZeroFoodWaste
//
//  Created by Danielle Yap on 7/6/2023.
//

import UIKit

class RecipeViewController: UIViewController {
    
    var recipe: RecipeData?
    var imageIsDownloading: Bool = false
    var imageShown = true

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cuisineLabel: UILabel!
    @IBOutlet weak var ingredientLabel: UILabel!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationController?.isNavigationBarHidden = true
        
        self.tabBarController?.tabBar.isHidden = true
        
        nameLabel.text = recipe?.name
        
        let cuisine = recipe!.cuisine ?? ""
        cuisineLabel.text = cuisine
        
        let source = recipe!.source ?? "Sorry! Not Available :("
        sourceLabel.text = source
        
        var tempInstructionsList = recipe?.instructions
        var listInstructions: [String] = []
        
        var tempIngredientList = recipe?.ingredientsList
        var listIngredients: [String] = []
        
        //read the ingredients
        for index in 0...(tempIngredientList!.count-1) {
            
            if tempIngredientList![index].count>2 {
                listIngredients.append("\(tempIngredientList![index]) \r\n")
            }
            
        }
        let ingredients = listIngredients.joined()
        setIngredientLabel(ingredients: ingredients)
        
 
        var i = 0
        // append the instruction number to the instructions first
        for index in 0..<tempInstructionsList!.count {
            
            
            if let steps = tempInstructionsList![index]  {
                if steps.count > 51{
                    listInstructions.append("\(i+1). \(steps) \r\n \r\n")
                    i += 1
                    print(steps, "HEREHEREHERHER: \(steps.count)")
                }
            }
        }
        let instructions = listInstructions.joined()
        setInstructionLabel(instructions: instructions)

//        setRecipeImage()
    }
    
    @IBAction func closeButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
//    func setRecipeImage(){
//        if let image = recipe!.image {
//            imageView.image = image
//        }
//        else if recipe?.imageIsDownloading == false, let imageURL = recipe?.imageURL {
//            let requestURL = URL(string: imageURL)
//            if let requestURL = URL(string: imageURL){
//                if let requestURL {
//                    Task {
//                        print("Downloading image: " + imageLink)
//                        recipe?.imageIsDownloading = true
//                        do {
//                            let (data, response) = try await URLSession.shared.data (from: requestURL)
//                            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
//                                recipe?.imageIsDownloading = false
////                                throw
//                            }
//
//                            if let image = UIImage(data: data) {
//                                print("Image Downloaded: " + imageLink)
//                                recipe.image = image
//                            } else {
//                                print("Image invalid: " + imageLink)
//                                recipe?.imageIsDownloading = false
//                            }
//                        }
//                        catch {
//                            print(error.localizedDescription)
//                        }
//                    }
//                }
//                else {
//                    print("Error: URL not valid: " + imageLink)
//                }
//            }
//        }
//    }
    
    
    
    
    func setInstructionLabel(instructions: String){
        
        //join the instructions first but with indexes :D
        instructionLabel.text = instructions
        instructionLabel.numberOfLines = 0
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        instructionLabel.lineBreakMode = .byWordWrapping

    }
    
    func setIngredientLabel(ingredients: String){
        
        //join the instructions first but with indexes :D
        
        ingredientLabel.text = ingredients
        ingredientLabel.numberOfLines = 0
        ingredientLabel.translatesAutoresizingMaskIntoConstraints = false
        ingredientLabel.lineBreakMode = .byWordWrapping

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

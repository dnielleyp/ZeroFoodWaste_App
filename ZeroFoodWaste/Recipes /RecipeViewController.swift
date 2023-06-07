//
//  RecipeViewController.swift
//  ZeroFoodWaste
//
//  Created by Danielle Yap on 7/6/2023.
//

import UIKit

class RecipeViewController: UIViewController {
    
    var recipe: RecipeData?

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var instructionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationController?.isNavigationBarHidden = true
        
        self.tabBarController?.tabBar.isHidden = true
        
        nameLabel.text = recipe?.name
        
        var listInstructions = (recipe?.instructions)!
        
        
        
        // append the instruction number to the instructions first
        for index in 0...(listInstructions.count-1) {
            
            print(listInstructions[index], "LIST INSTRUCTIONS!!!!")
            
            listInstructions[index] = "\(index+1). \(listInstructions[index]) \r\n \r\n"
        }
    
        
        
//        let instructions = listInstructions.joined()
//        print(instructions, "instructionsssnnsns")
//
//        setInstructionLabel(instructions: instructions)
        
    }
    
    @IBAction func closeButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    func setInstructionLabel(instructions: String){
        
        //join the instructions first but with indexes :D
        
        
        instructionLabel.text = instructions
        instructionLabel.numberOfLines = 0
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        instructionLabel.lineBreakMode = .byWordWrapping
        
        NSLayoutConstraint.activate([
//            instructionLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            instructionLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            instructionLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor)])
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

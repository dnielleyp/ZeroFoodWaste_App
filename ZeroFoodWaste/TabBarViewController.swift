//
//  TabBarViewController.swift
//  ZeroFoodWaste
//
//  Created by Danielle Yap on 4/5/2023.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view
        
        self.delegate = self
        
        guard let navigationController = self.navigationController else { return }
        
        //remove the navigation stack when user has logged into the application
        var navigationArray = navigationController.viewControllers
        let temp = navigationArray.last
        navigationArray.removeAll()
        navigationArray.append(temp!)
        self.navigationController?.viewControllers = navigationArray
        
 
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
            if viewController == self.viewControllers?[2] {
                // Call your method here
                createListingButtonAction()
            }
        }
    
    func createListingButtonAction() {
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "CreateListingVC") as? CreateListingViewController {
            vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            self.present(vc, animated: true, completion: nil)
        }
        
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

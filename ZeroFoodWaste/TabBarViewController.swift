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
        
        setupCreateListingButton()
        
        guard let navigationController = self.navigationController else { return }
        
        //remove the navigation stack when user has logged into the application
        var navigationArray = navigationController.viewControllers
        let temp = navigationArray.last
        navigationArray.removeAll()
        navigationArray.append(temp!)
        self.navigationController?.viewControllers = navigationArray
        
    }
    
    func setupCreateListingButton(){
        
        let createListingButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 150))
        var CLButtonFrame = createListingButton.frame
        CLButtonFrame.origin.y = self.view.bounds.height - CLButtonFrame.height
        CLButtonFrame.origin.x = self.view.bounds.width/2 - CLButtonFrame.size.width/2

        createListingButton.frame = CLButtonFrame

        createListingButton.backgroundColor = UIColor(red: 255/255, green: 247/255, blue: 235/255, alpha:1)
        
        createListingButton.layer.cornerRadius = CLButtonFrame.height/2

        let buttonConfig = UIImage.SymbolConfiguration(pointSize: 40)
        
        createListingButton.setImage(UIImage(systemName: "plus.app.fill", withConfiguration: buttonConfig), for: UIControl.State.normal) // 450 x 450px
        
        createListingButton.contentMode = .scaleAspectFit

        createListingButton.addTarget(self, action: #selector(createListingButtonAction), for: UIControl.Event.touchUpInside)


        self.view.addSubview(createListingButton)
    }
    
    
    
    
//    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//
//            if viewController == self.viewControllers?[2] {
//                // Call your method here
//                createListingButtonAction()
//            }
//        }

    @objc func createListingButtonAction() {
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

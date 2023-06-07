//
//  TabBarViewController.swift
//  ZeroFoodWaste
//
//  Created by Danielle Yap on 4/5/2023.
//

//https://www.youtube.com/watch?v=oobm2y-d17E&ab_channel=iOSAcademy for create listing button
import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    let createListingButton: UIButton = {
        let tempButton = UIButton(frame: CGRect(x: 0, y: 0, width:60, height: 60))
        tempButton.layer.masksToBounds = true
        tempButton.layer.cornerRadius = 30
        tempButton.backgroundColor = UIColor(red: 8/255, green: 105/255, blue: 82/255, alpha: 1.0)
        return tempButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view
        
        
        guard let navigationController = self.navigationController else { return }
        
        //remove the navigation stack when user has logged into the application
        var navigationArray = navigationController.viewControllers
        let temp = navigationArray.last
        navigationArray.removeAll()
        navigationArray.append(temp!)
        self.navigationController?.viewControllers = navigationArray
        
        view.addSubview(createListingButton)
        createListingButton.addTarget(self, action: #selector(createListingButtonAction), for: .touchUpInside)
        

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var heightDiff = view.frame.size.height/8.5
        createListingButton.frame = CGRect(x: view.frame.size.width*0.425,
                                           y: view.frame.size.height-heightDiff,
                                           width: 60, height: 60)
        
        let buttonConfig = UIImage.SymbolConfiguration(pointSize: 30)
//        let buttonImage = UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate)
        
        createListingButton.setImage(UIImage(systemName:"plus", withConfiguration: buttonConfig), for: .normal)
        
        createListingButton.tintColor = UIColor(red: 255/255, green: 247/255, blue: 235/255, alpha: 1.0)
        
    }

    

    @objc func createListingButtonAction() {        
        let vc = storyboard?.instantiateViewController(withIdentifier: "CreateListingVC") as? CreateListingViewController

        navigationController?.pushViewController(vc!, animated: true)
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

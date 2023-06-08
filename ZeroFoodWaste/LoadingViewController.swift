//
//  LoadingViewController.swift
//  ZeroFoodWaste
//
//  Created by Danielle Yap on 8/6/2023.
//

import UIKit

//https://www.advancedswift.com/loading-overlay-view-fade-in-swift/
class LoadingViewController: UIViewController {
    
    var loadingActivityIndicator: UIActivityIndicatorView = {
        
        let indicator = UIActivityIndicatorView()
                
        indicator.style = .large
        indicator.color = .white
        
        indicator.startAnimating()
        
        
        indicator.autoresizingMask = [
            .flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
    
        return indicator
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        loadingActivityIndicator.center = CGPoint( x: view.bounds.midX, y: view.bounds.midY )
        view.addSubview(loadingActivityIndicator)
        
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

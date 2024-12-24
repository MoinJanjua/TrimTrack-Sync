//
//  WelcomeViewController.swift
//  TrimTrack Sync
//
//  Created by Unique Consulting Firm on 20/12/2024.
//

import UIKit

class WelcomeViewController: UIViewController {
   
    @IBOutlet weak var StartBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
       // applyGradientToButtonThree(view: VurveView)
        //applyGradientToButtonThree(view: StartBtn)


    }
    
    @IBAction func startButton(_ sender: Any) {
        
               let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
               let newViewController = storyBoard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
               newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
               newViewController.modalTransitionStyle = .crossDissolve
               self.present(newViewController, animated: true, completion: nil)
    }
    
    func applyGradientToButtonThree(view: UIView) {
            let gradientLayer = CAGradientLayer()
            
            // Define your gradient colors
            gradientLayer.colors = [
                                   
                UIColor(hex: "#007AFF").cgColor,
                UIColor(hex: "#5856D6").cgColor,
                UIColor(hex: "#AF52DE").cgColor, UIColor(hex: "#FEF3E2").cgColor
            ]
            
            // Set the gradient direction
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)   // Top-left
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)     // Bottom-right
            
            // Set the gradient's frame to match the button's bounds
            gradientLayer.frame = view.bounds
            
            // Apply rounded corners to the gradient
            gradientLayer.cornerRadius = view.layer.cornerRadius
            
            // Add the gradient to the button
        view.layer.insertSublayer(gradientLayer, at: 0)
        }

    
}

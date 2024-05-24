//
//  ViewController.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 29.04.2024.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func StudentButtonClicked(_ sender: Any) {
        guard let storyboard = self.storyboard else {
            fatalError("Storyboard bulunamadı.")
        }
        
        
        var myRefresh:Any?
        
        myRefresh = UserDefaults.standard.string(forKey: "refreshToken")
        
        if myRefresh != nil{
            
            guard let studentProfileVC = storyboard.instantiateViewController(withIdentifier: "StudentProfileVC") as? StudentProfileViewController else {
                fatalError("StudentProfileViewController bulunamadı veya uygun tipte değil.")
            }
            
            studentProfileVC.modalPresentationStyle = .fullScreen
            self.present(studentProfileVC, animated: true, completion: nil)
            
        }
        else
        {
            guard let studentLoginVC = storyboard.instantiateViewController(withIdentifier: "StudentLoginVC") as? StudentLoginViewController else {
                fatalError("StudentLoginViewController bulunamadı veya uygun tipte değil.")
            }
            
            studentLoginVC.modalPresentationStyle = .fullScreen
            self.present(studentLoginVC, animated: true, completion: nil)
            
        }
    }

    
}


//
//  StudentProfileViewController.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 30.04.2024.
//

import UIKit

class StudentProfileViewController: UIViewController {
    
    // MARK: -VARIABLES
    
    
    // MARK: -FUNCTIONS

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func exitButtonClicked(_ sender: UIButton) {
        
        let exitAlert = UIAlertController(title: "Çıkış Yap", message: "Çıkış yapmak istediğinizden emin misiniz?", preferredStyle: .alert)
        
        //evet
        exitAlert.addAction(UIAlertAction(title: "Evet", style: .default , handler: {(_) in
                                          // Giriş sayfasına geri dön
            self.performSegue(withIdentifier: "backToLogin", sender: self)
                                      }))
        //iptal
        exitAlert.addAction(UIAlertAction(title: "İptal", style: .cancel , handler: nil))
        
        self.present(exitAlert, animated: true, completion: nil)
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

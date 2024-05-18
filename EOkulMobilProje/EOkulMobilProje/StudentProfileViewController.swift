//
//  StudentProfileViewController.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 30.04.2024.
//

import UIKit

class StudentProfileViewController: UIViewController {
    
    // MARK: -VARIABLES
    
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    // MARK: -FUNCTIONS

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateStudentInfo()
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
    
    @IBAction func mainButtonClicked(_ sender: UIButton) {
        
        let exitAlert = UIAlertController(title: "Ana Sayfaya Dön", message: "Ana sayfaya dönmek istediğinizden emin misiniz?", preferredStyle: .alert)
        
        //evet
        exitAlert.addAction(UIAlertAction(title: "Evet", style: .default , handler: {(_) in
                                          // Giriş sayfasına geri dön
            self.performSegue(withIdentifier: "backToMain", sender: self)
                                      }))
        //iptal
        exitAlert.addAction(UIAlertAction(title: "İptal", style: .cancel , handler: nil))
        
        self.present(exitAlert, animated: true, completion: nil)
    }
    
    // Öğrenci bilgilerini güncelleme fonksiyonu
    func updateStudentInfo() {
        if let currentUser = NetworkService.shared.currentUser {
            switch currentUser.userType {
                case .Student(let classId):
                    // Eğer kullanıcı öğrenci ise, classId bilgisine eriş
                    classLabel.text = "Sınıf: \(classId)"
                case .Teacher, .Director:
                    // Öğrenci değilse, öğretmen veya müdür olabilir, uygun bir işlem yap
                    print("Öğrenci değil")
                }
            nameLabel.text = "Ad Soyad: \(currentUser.firstName) \(currentUser.lastName)"
        }
    }

}

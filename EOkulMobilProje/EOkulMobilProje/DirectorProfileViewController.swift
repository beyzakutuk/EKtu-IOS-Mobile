//
//  DirectorProfileViewController.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 30.04.2024.
//

import UIKit

class DirectorProfileViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    var director : DirectorModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupProfile()
    }
    
    @IBAction func exitButtonClicked(_ sender: UIButton) {
        
        let exitAlert = UIAlertController(title: "Çıkış Yap", message: "Çıkış yapmak istediğinizden emin misiniz?", preferredStyle: .alert)
        
        //evet
        exitAlert.addAction(UIAlertAction(title: "Evet", style: .default , handler: {(_) in
                                          // Giriş sayfasına geri dön
            self.performSegue(withIdentifier: "backToLogin", sender: self)
            UserDefaults.standard.removeObject(forKey: "refreshTokenPrincipal")
                                      }))
        //iptal
        exitAlert.addAction(UIAlertAction(title: "İptal", style: .cancel , handler: nil))
        self.present(exitAlert, animated: true, completion: nil)
    }
    
    private func setupProfile() {
            guard let director = director else { return }
            nameLabel.text = "\(director.isim) \(director.soyisim)"
    }

}

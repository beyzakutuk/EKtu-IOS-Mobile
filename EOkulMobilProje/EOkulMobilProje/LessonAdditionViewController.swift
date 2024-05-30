//
//  LessonAdditionViewController.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 22.05.2024.
//

import UIKit

class LessonAdditionViewController: UIViewController {
    
    //MARK: -VARIABLES
    
    @IBOutlet weak var isimField: UITextField!
    @IBOutlet weak var HasOptionalButton: UIButton!
    @IBOutlet weak var yilButton: UIButton!
    @IBOutlet weak var donemButton: UIButton!
    
    @IBOutlet weak var kaydetButton: UIButton!
    @IBOutlet weak var onayLabel: UILabel!
    
    var isTipSelected = false
    var isYilSelected = false
    var isDonemSelected = false
    
    var DonemID : Int?
    var hasOptional = false
    var selectedSecmeliId: Int?
    var selectedDonem: Bool?
    
    let secmeliOptions: [Secmeli] = [
        Secmeli(secmeliId: 1, secmeliName: "Seçmeli 1"),
        Secmeli(secmeliId: 2, secmeliName: "Seçmeli 2"),
        Secmeli(secmeliId: 1002, secmeliName: "Seçmeli 3")
    ]

    let donemler: [Donem] = [
        Donem(donemName: "Güz", isBahar: false),
        Donem(donemName: "Bahar", isBahar: true)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)  // ekranda herhangi bir yere dokunduğunda klavyeyi kapat
    }
    
    private func setupViews() {
        // Text fieldlar için editingChanged eventini dinleyerek validateFields fonksiyonunu çağır
        [isimField].forEach { textField in
            textField?.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        }
        
        validateFields() // Başlangıçta butonu pasif hale getirmek için
    }

    @objc private func validateFields()
    {
        // Bütün text fieldların dolu olup olmadığını kontrol et
        let isFormValid = !(isimField.text?.isEmpty ?? true) &&
                      isTipSelected && isYilSelected && isDonemSelected
            
       kaydetButton.isEnabled = isFormValid
    }
    
    @IBAction func TipButtonClicked(_ sender: UIButton) {

            let alertController = UIAlertController(title: "Ders Tipi", message: "Bir ders tipi seçiniz", preferredStyle: .actionSheet)
            
            let secmeliAction = UIAlertAction(title: "Seçmeli", style: .default) { _ in
                    
                self.HasOptionalButton.setTitle("Seçmeli", for: UIControl.State.normal)
                self.HasOptionalButton.titleLabel?.textColor = .black
                self.isTipSelected = true
                self.validateFields()

                print("Seçilen Tip: Seçmeli")
                self.showSecmeliOptions()
                    
            }
            
            let anaDersAction = UIAlertAction(title: "Ana Ders", style: .default) { _ in
                    
                self.HasOptionalButton.setTitle("Ana Ders", for: UIControl.State.normal)
                self.HasOptionalButton.titleLabel?.textColor = .black
                self.isTipSelected = true
                self.selectedSecmeliId = nil
                self.validateFields()

                print("Seçilen Tip: Ana Ders")
                    
            }
            
            alertController.addAction(secmeliAction)
            alertController.addAction(anaDersAction)
            
            self.present(alertController, animated: true, completion: nil)
        
    }
    
    func showSecmeliOptions() {

        let secmeliAlertController = UIAlertController(title: "Seçmeli Seçenekler", message: "Lütfen bir seçenek seçin", preferredStyle: .actionSheet)

        for option in secmeliOptions {
            let action = UIAlertAction(title: option.secmeliName, style: .default) { _ in
                print("Seçilen Seçmeli: \(option.secmeliName)")
                
                self.selectedSecmeliId = option.secmeliId
            }
            secmeliAlertController.addAction(action)
        }

        self.present(secmeliAlertController, animated: true, completion: nil)
    }
    
    @IBAction func YilButtonClicked(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Ders Yılı", message: "Bir ders yılı seçiniz", preferredStyle: .actionSheet)
        
        let birAction = UIAlertAction(title: "1", style: .default) { _ in
                
            self.yilButton.setTitle("1", for: UIControl.State.normal)
            self.yilButton.titleLabel?.textColor = .black
            self.isYilSelected = true
            self.DonemID = 1
            self.validateFields()

            print("Seçilen Yil: 1")
        }
        
        let ikiAction = UIAlertAction(title: "2", style: .default) { _ in
                
            self.yilButton.setTitle("2", for: UIControl.State.normal)
            self.yilButton.titleLabel?.textColor = .black
            self.isYilSelected = true
            self.DonemID = 2
            self.validateFields()

            print("Seçilen Tip: 2")
        }
        
        let ucAction = UIAlertAction(title: "3", style: .default) { _ in
                
            self.yilButton.setTitle("3", for: UIControl.State.normal)
            self.yilButton.titleLabel?.textColor = .black
            self.isYilSelected = true
            self.DonemID = 3
            self.validateFields()

            print("Seçilen Yil: 3")
        }
        
        let dortAction = UIAlertAction(title: "4", style: .default) { _ in
                
            self.yilButton.setTitle("4", for: UIControl.State.normal)
            self.yilButton.titleLabel?.textColor = .black
            self.isYilSelected = true
            self.DonemID = 4
            self.validateFields()

            print("Seçilen Tip: 4")
        }
        
        alertController.addAction(birAction)
        alertController.addAction(ikiAction)
        alertController.addAction(ucAction)
        alertController.addAction(dortAction)
        
        self.present(alertController, animated: true, completion: nil)
    
    }
    
    @IBAction func DonemButtonClicked(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Ders Dönemi", message: "Bir ders dönemi seçiniz", preferredStyle: .actionSheet)
            
            for donem in donemler {
                let action = UIAlertAction(title: donem.donemName, style: .default) { _ in
                    self.donemButton.setTitle(donem.donemName, for: UIControl.State.normal)
                    self.donemButton.titleLabel?.textColor = .black
                    self.isDonemSelected = true
                    self.validateFields()
                    self.selectedDonem = donem.isBahar

                    print("Seçilen Dönem: \(donem.donemName), Bahar mı: \(donem.isBahar)")
                }
                alertController.addAction(action)
            }
            self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func submitButtonClicked(_ sender: Any) {
        
        guard let isim = isimField.text,
              let tip = HasOptionalButton.title(for: .normal), tip != "Tip Seçiniz",
              let yil = yilButton.title(for: .normal), yil != "Yıl Seçiniz",
              let donem = donemButton.title(for: .normal) , donem != "Dönem Seçiniz"
        else {
            return
        }
        



        // Onay mesajını güncelle
        onayLabel.text = "Kaydedildi"
        onayLabel.textColor = UIColor(red: 0, green: 128/255, blue: 0, alpha: 1)
                
        // TextField'lerin içeriğini temizle
        isimField.text = ""
        HasOptionalButton.setTitle("Tip Seçiniz", for: .normal)
        isTipSelected = false
        
        yilButton.setTitle("Yıl Seçiniz", for: .normal)
        isYilSelected = false
        
        donemButton.setTitle("Dönem Seçiniz", for: .normal)
        isDonemSelected = false
        
        
        showAlert()

    }
    
    private func showAlert() {
        let alertController = UIAlertController(title: "Başarılı", message: "Öğretmen sisteme başarıyla kaydedildi.", preferredStyle: .alert)
            
        let anaSayfayaDonAction = UIAlertAction(title: "Ana Sayfaya Dön", style: .default) { _ in
            self.performSegue(withIdentifier: "toDirectorProfilePage", sender: self)
        }
            
        alertController.addAction(anaSayfayaDonAction)
            
        present(alertController, animated: true, completion: nil)
    }

}

struct Secmeli {
    let secmeliId: Int
    let secmeliName: String
}

struct Donem {
    let donemName: String
    let isBahar: Bool
}

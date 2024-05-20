//
//  StudentAdditionViewController.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 19.05.2024.
//

import UIKit

class StudentAdditionViewController: UIViewController {
    
    @IBOutlet weak var tcKimlikField: UITextField!
    @IBOutlet weak var isimField: UITextField!
    @IBOutlet weak var soyisimField: UITextField!
    @IBOutlet weak var sinifField: UITextField!
    @IBOutlet weak var sifreField: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var onayLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)  // ekranda herhangi bir yere dokunduğunda klavyeyi kapat
    }
    
    private func setupViews() {
        // Text fieldlar için editingChanged eventini dinleyerek validateFields fonksiyonunu çağır
        [isimField, soyisimField, tcKimlikField, sifreField, sinifField].forEach { textField in
            textField?.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        }
        
        validateFields() // Başlangıçta butonu pasif hale getirmek için
    }
    
    @objc private func validateFields()
    {
        // Bütün text fieldların dolu olup olmadığını kontrol et
        let isFormValid = !(isimField.text?.isEmpty ?? true) &&
                          !(soyisimField.text?.isEmpty ?? true) &&
                          !(tcKimlikField.text?.isEmpty ?? true) &&
                          !(sifreField.text?.isEmpty ?? true) &&
                          !(sinifField.text?.isEmpty ?? true)
                
        submitButton.isEnabled = isFormValid
    }
    
    
    @IBAction func submitButtonClicked(_ sender: UIButton) {
        
        guard let isim = isimField.text,
                let soyisim = soyisimField.text,
                let tcKimlikNo = tcKimlikField.text,
                let sifre = sifreField.text,
                let sinifNumarasi = sinifField.text else {
            return
        }
        
        StudentDatabase.yeniOgrenciEkle(isim: isim, soyisim: soyisim, tcKimlikNo: tcKimlikNo, sifre: sifre, sinifNumarasi: sinifNumarasi)
        

        // Onay mesajını güncelle
        onayLabel.text = "Kaydedildi"
        onayLabel.textColor = UIColor(red: 0, green: 128/255, blue: 0, alpha: 1)
                
        // TextField'lerin içeriğini temizle
        isimField.text = ""
        soyisimField.text = ""
        tcKimlikField.text = ""
        sifreField.text = ""
        sinifField.text = ""
        
        showAlert()
        
    }
    
    private func showAlert() {
        let alertController = UIAlertController(title: "Başarılı", message: "Öğrenci sisteme başarıyla kaydedildi.", preferredStyle: .alert)
            
        let anaSayfayaDonAction = UIAlertAction(title: "Ana Sayfaya Dön", style: .default) { _ in
            self.performSegue(withIdentifier: "toDirectorProfilePage", sender: self)
        }
            
        let yeniOgrenciEkleAction = UIAlertAction(title: "Yeni Öğrenci Ekle", style: .default) { _ in
            // ViewController'ı yeniden yükleme
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "StudentAdditionViewController") as? StudentAdditionViewController {
                    self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
            
        alertController.addAction(anaSayfayaDonAction)
        alertController.addAction(yeniOgrenciEkleAction)
            
        present(alertController, animated: true, completion: nil)
    }
    
}

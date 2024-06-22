//
//  UpdateGradesViewController.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 22.06.2024.
//

import UIKit

class UpdateGradesViewController: UIViewController {

    @IBOutlet weak var midtermGradesTextField: UITextField!
    @IBOutlet weak var finalGradesTextField: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)  // ekranda herhangi bir yere dokunduğunda klavyeyi kapat
    }
    
    private func setupViews() {
        // Text fieldlar için editingChanged eventini dinleyerek validateFields fonksiyonunu çağır
        [midtermGradesTextField, finalGradesTextField].forEach { textField in
            textField?.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        }
        
        validateFields() // Başlangıçta butonu pasif hale getirmek için
    }
    
    @objc private func validateFields()
    {
        // Bütün text fieldların dolu olup olmadığını kontrol et
        let isFormValid = !(midtermGradesTextField.text?.isEmpty ?? true) &&
                          !(finalGradesTextField.text?.isEmpty ?? true)
                
        submitButton.isEnabled = isFormValid
    }
    

    
    @IBAction func submitButtonClicked(_ sender: Any) {
        
        guard let midtermGrade = midtermGradesTextField.text,
                let finalGrade = finalGradesTextField.text
                else {
            return
        }
    
        
        
        
        
        //burada veritabanı işlemleri yapılacak notların girilmesi ve aktarılması
        
        
        
        
        
        
        
        
        // TextField'lerin içeriğini temizle
        midtermGradesTextField.text = ""
        finalGradesTextField.text = ""
            
        validateFields() // Alanları temizledikten sonra tekrar doğrula
        
        showAlert()
        
    }
    
    private func showAlert() {
        let alertController = UIAlertController(title: "Başarılı", message: "Not sisteme başarıyla kaydedildi.", preferredStyle: .alert)
        /*
        let anaSayfayaDonAction = UIAlertAction(title: "Ana Sayfaya Dön", style: .default) { _ in
            self.performSegue(withIdentifier: "toTeacherProfilePage", sender: self)
        }

        alertController.addAction(anaSayfayaDonAction)
          */
        present(alertController, animated: true, completion: nil)
    }
    
}

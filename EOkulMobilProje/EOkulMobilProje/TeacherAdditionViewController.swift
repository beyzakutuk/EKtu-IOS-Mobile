//
//  TeacherAdditionViewController.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 20.05.2024.
//

import UIKit

class TeacherAdditionViewController: UIViewController {
    
    // MARK: -VARIABLES
    
    @IBOutlet weak var tcKimlikField: UITextField!
    @IBOutlet weak var isimField: UITextField!
    @IBOutlet weak var soyisimField: UITextField!
    @IBOutlet weak var dersField: UITextField!
    @IBOutlet weak var sifreField: UITextField!
    
    @IBOutlet weak var kaydetButton: UIButton!
    
    @IBOutlet weak var onayLabel: UILabel!
    
    
    // MARK: -FUNCTIONS
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        
    }
    
    
    private func setupViews() {
        // Text fieldlar için editingChanged eventini dinleyerek validateFields fonksiyonunu çağır
        [isimField, soyisimField, tcKimlikField, sifreField, dersField].forEach { textField in
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
                      !(dersField.text?.isEmpty ?? true)
            
       kaydetButton.isEnabled = isFormValid
    }

    
    @IBAction func submitButtonClicked(_ sender: UIButton) {
    }
    


}

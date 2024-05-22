//
//  LessonAdditionViewController.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 22.05.2024.
//

import UIKit

class LessonAdditionViewController: UIViewController {
    
    //MARK: -VARIABLES
    
    @IBOutlet weak var idField: UITextField!
    @IBOutlet weak var isimField: UITextField!
    @IBOutlet weak var yilField: UITextField!
    @IBOutlet weak var donemField: UITextField!
    
    @IBOutlet weak var kaydetButton: UIButton!
    
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
        [idField, isimField, yilField, donemField].forEach { textField in
            textField?.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        }
        
        validateFields() // Başlangıçta butonu pasif hale getirmek için
    }

    @objc private func validateFields()
    {
        // Bütün text fieldların dolu olup olmadığını kontrol et
        let isFormValid = !(idField.text?.isEmpty ?? true) &&
                      !(isimField.text?.isEmpty ?? true) &&
                      !(yilField.text?.isEmpty ?? true) &&
                      !(donemField.text?.isEmpty ?? true)
            
       kaydetButton.isEnabled = isFormValid
    }

}

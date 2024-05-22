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
    
    @IBAction func submitButtonClicked(_ sender: Any) {
        
        guard let id = idField.text,
                let isim = isimField.text,
                let yil = yilField.text,
                let donem = donemField.text

        else {
            return
        }
        
        CourseDatabase.yeniDersEkle(courseId: id, courseName: isim, isMainCourse: true, year: yil, type: donem)


        // Onay mesajını güncelle
        onayLabel.text = "Kaydedildi"
        onayLabel.textColor = UIColor(red: 0, green: 128/255, blue: 0, alpha: 1)
                
        // TextField'lerin içeriğini temizle
        idField.text = ""
        isimField.text = ""
        yilField.text = ""
        donemField.text = ""
        
        showAlert()

    }
    
    private func showAlert() {
        let alertController = UIAlertController(title: "Başarılı", message: "Öğretmen sisteme başarıyla kaydedildi.", preferredStyle: .alert)
            
        let anaSayfayaDonAction = UIAlertAction(title: "Ana Sayfaya Dön", style: .default) { _ in
            self.performSegue(withIdentifier: "toDirectorProfilePage", sender: self)
        }
            
        let yeniOgretmenEkleAction = UIAlertAction(title: "Yeni Öğretmen Ekle", style: .default) { _ in
            // ViewController'ı yeniden yükleme
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "TeacherAdditionViewController") as? TeacherAdditionViewController {
                    self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
            
        alertController.addAction(anaSayfayaDonAction)
        alertController.addAction(yeniOgretmenEkleAction)
            
        present(alertController, animated: true, completion: nil)
    }



}

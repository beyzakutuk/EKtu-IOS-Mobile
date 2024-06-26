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
        
        //validateFields() // Başlangıçta butonu pasif hale getirmek için
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
    
        ExamNoteStudentList.setIsUpdate(newValue: true)
        
        if let student = ExamNoteStudentList.findStudentById(studentId: 1) {
            student.setMidterm(midtermNote: Int(midtermGrade) ?? 0)
            student.setFinal(final: Int(finalGrade) ?? 0)
            
        }
        
        StudentUpdateExamNoteModel.updateNote(studentId: ExamNoteStudentList.getId(), lessonId: StudentFilterModel.getLessonId(), midtermNote: Int(midtermGrade) ?? 0, finalNote: Int(finalGrade) ?? 0)
        
        
        // TextField'lerin içeriğini temizle
        midtermGradesTextField.text = ""
        finalGradesTextField.text = ""
            
        //validateFields() // Alanları temizledikten sonra tekrar doğrula
        
        
        // Öğrencinin notlarının güncelleneceği sayfaya yönlendir
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let examUpdateViewController = storyboard.instantiateViewController(withIdentifier: "StudentExamList") as? StudentExamListViewController {

            
            // Present modally olarak göster
            examUpdateViewController.modalPresentationStyle = .fullScreen
            self.present(examUpdateViewController, animated: true, completion: nil)
        }
        
    }
    

    
}

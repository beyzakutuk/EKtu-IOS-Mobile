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
        self.view.endEditing(true)  
    }
    
    private func setupViews() {
        [midtermGradesTextField, finalGradesTextField].forEach { textField in
            textField?.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        }
        
        validateFields()
    }
    
    @objc private func validateFields()
    {
        let isMidtermValid = !(midtermGradesTextField.text?.isEmpty ?? true)
        let isFinalValid = !(finalGradesTextField.text?.isEmpty ?? true)
        
        let isFormValid = isMidtermValid || isFinalValid
        
        submitButton.isEnabled = isFormValid
    }
    

    
    @IBAction func submitButtonClicked(_ sender: Any) {
        
        guard let midtermGrade = midtermGradesTextField.text,
                let finalGrade = finalGradesTextField.text
                else {
            return
        }
    
        ExamNoteStudentList.setIsUpdate(newValue: true)
        

        if !midtermGrade.isEmpty && !finalGrade.isEmpty {
            if let student = ExamNoteStudentList.findStudentById(studentId: ExamNoteStudentList.getId()) {
                student.setMidterm(midtermNote: Int(midtermGrade) ?? 0)
                student.setFinal(final: Int(finalGrade) ?? 0)
            }
        } else if !midtermGrade.isEmpty {
            if let student = ExamNoteStudentList.findStudentById(studentId: ExamNoteStudentList.getId()) {
                student.setMidterm(midtermNote: Int(midtermGrade) ?? 0)
            }
        } else if !finalGrade.isEmpty {
            if let student = ExamNoteStudentList.findStudentById(studentId: ExamNoteStudentList.getId()) {
                student.setFinal(final: Int(finalGrade) ?? 0)
            }
        }

        StudentUpdateExamNoteModel.updateNote(studentId: ExamNoteStudentList.getId(),
                                              lessonId: StudentFilterModel.getLessonId(),
                                              midtermNote: Int(midtermGrade) ?? 0,
                                              finalNote: Int(finalGrade) ?? 0)

        midtermGradesTextField.text = ""
        finalGradesTextField.text = ""

        validateFields()
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let examUpdateViewController = storyboard.instantiateViewController(withIdentifier: "StudentExamList") as? StudentExamListViewController {
                examUpdateViewController.modalPresentationStyle = .fullScreen
                self.present(examUpdateViewController, animated: true, completion: nil)
            }
        
    }
    

    
}

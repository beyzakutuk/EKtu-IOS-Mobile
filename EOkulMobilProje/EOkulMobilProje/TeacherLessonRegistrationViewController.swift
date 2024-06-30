//
//  TeacherLessonRegistrationViewController.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 29.06.2024.
//

import UIKit

class TeacherLessonRegistrationViewController: UIViewController , SelectionDelegate , TeacherSelectionDelegate , LessonSelectionDelegate{


    
    @IBOutlet weak var teacherSelectionButton: UIButton!
    @IBOutlet weak var classSelectionButton: UIButton!
    @IBOutlet weak var lessonSelectionButton: UIButton!
    
    var teacherId : Int?
    var lessonId : Int?
    var classId : Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func submitButtonClicked(_ sender: Any) {
        
        self.teacherId = TeacherModel.id
        self.lessonId = LessonModel.id
        self.classId = Class.id
        
        
        guard let teacherId = teacherId, let classId = classId, let lessonId = lessonId else {
                   print("teacherId, classId veya lessonId nil")
                   return
               }
        
        guard let token = UserDefaults.standard.string(forKey: "refreshTokenPrincipal") else {
                   print("Token yok veya geçersiz")
                   return
               }
        guard let url = URL(string: "https://localhost:7253/api/principal/teacherclasslesson") else {
                print("Geçersiz URL")
                return
            }
        var request = URLRequest(url: url)
            request.httpMethod = "POST"
        
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
        
            "teacherId" : teacherId,
            "classId" : classId ,
            "lessonId" :lessonId
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters) else {
            print("Error encoding student data")
            return
        }
        
        request.httpBody = jsonData
        
        let session = URLSession(configuration: .default, delegate: MySessionDelegate(), delegateQueue: nil)
        let task = session.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print("Error: \(error)")
                return
            }
                    
            guard let data = data else {
                print("No data received")
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("Response status code: \(httpResponse.statusCode)")
            }
     
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Response JSON: \(json)")
                }
            } catch {
                print("Error parsing response: \(error)")
            }
        }

        task.resume()
      
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showClassList", let classListVC = segue.destination as? ClassListViewController {
            classListVC.delegate = self
        }
        if segue.identifier == "showTeacherList", let teacherListVC = segue.destination as? ClassListViewController {
            teacherListVC.delegate = self
        }
        if segue.identifier == "showLessonList", let LessonListVC = segue.destination as? ClassListViewController {
            LessonListVC.delegate = self
        }
    }
    
    func didSelectItem(_ item: Class) {
        classSelectionButton.setTitle(item.className, for: .normal)
    }

    func didSelectTeacher(_ teacher: TeacherModel) {
        teacherSelectionButton.setTitle(teacher.teacherName, for: .normal)
    }
    
    func didSelectLesson(_ lesson: LessonModel) {
        lessonSelectionButton.setTitle(lesson.lessonName, for: .normal)
    }
    

}

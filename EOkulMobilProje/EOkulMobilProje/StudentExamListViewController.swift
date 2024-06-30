//
//  StudentExamListViewController.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 22.06.2024.
//

import UIKit

class StudentExamListViewController: UIViewController , UITableViewDelegate, UITableViewDataSource , StudentExamListnDelegate{
   
    
    @IBOutlet weak var StudentListTableView: UITableView!
    
    var students : [ExamNoteStudentList] = []
    static var updateExam : [ExamNoteStudentList] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setInitViews()
        
        if !ExamNoteStudentList.getIsUpdated()
        {
            geturl()
        }
        else
        {
            students = ExamNoteStudentList.getAllStudents()
        }
        
    }
    
    func setInitViews() {
        StudentListTableView.delegate = self
        StudentListTableView.dataSource = self
    }
    
    
    func geturl()
    {
            guard let url = URL(string: "https://localhost:7253/api/teacher/GetAllStudentByClassIdAndLessonId") else {
                fatalError("Geçersiz URL")
            }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
            let parameters: [String: Any] = [ "classId": StudentFilterModel.getClassId(), "lessonId": StudentFilterModel.getLessonId()]
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch let error {
                print("JSON Serialization error: \(error.localizedDescription)")
            }

            let session = URLSession(configuration: .default, delegate: MySessionDelegate(), delegateQueue: nil)
            let task = session.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("İstek hatası: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    print("Veri yok")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Geçersiz yanıt")
                    return
                }
                print("HTTP Durum Kodu: \(httpResponse.statusCode)")
                
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        print("Yanıt: \(jsonResponse)")
                        
                        if let jsonData = jsonResponse["data"] as? [[String: Any]] {
                            for studentData in jsonData {
                                if let studentName = studentData["studentName"] as? String,
                                   let studentId = studentData["studentId"] as? Int,
                                   let midterm = studentData["exam_1"] as? Int,
                                   let final = studentData["exam_2"] as? Int
                                {
                                    if let decodedName = studentName.applyingTransform(StringTransform(rawValue: "Any-Name"), reverse: true) {
                                        let student = ExamNoteStudentList(studentId: studentId, studentName: decodedName, midtermNote: midterm, finalNote: final)
                                        ExamNoteStudentList.addStudent(studentId: studentId, studentName: decodedName, midtermNote: midterm, finalNote: final)
                                    }
                                    else
                                    {
                                        let student = ExamNoteStudentList(studentId: studentId, studentName: studentName, midtermNote: midterm, finalNote: final)
                                        ExamNoteStudentList.addStudent(studentId: studentId, studentName: studentName, midtermNote: midterm, finalNote: final)
                                    }
                                    
                                    self.students = ExamNoteStudentList.getAllStudents()
                                    
                                    DispatchQueue.main.async {
                                        self.StudentListTableView.reloadData()
                                    }}} }}}
                
                        catch let error {
                    print("JSON Parsing error: \(error.localizedDescription)")
                }}
            task.resume()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.students.isEmpty {
            let emptyCell = tableView.dequeueReusableCell(withIdentifier: "emptyCell", for: indexPath)
            emptyCell.textLabel?.text = "Öğrenci bulunmuyor"
            return emptyCell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath) as! StudentExamListTableViewCell
            let student = self.students[indexPath.row]
            

            cell.studentNameLabel.text = student.studentName
            
            if student.midtermNote == 0
            {
                cell.midtermGrades.text = "Arasınav Notu: G"
            }
            else
            {
                cell.midtermGrades.text = "Arasınav Notu: \(student.midtermNote)"
            }
            
            if student.finalNote == 0
            {
                cell.finalGrades.text = "Final Notu: G"
            }
            else
            {
                cell.finalGrades.text = "Final Notu: \(student.finalNote)"
            }

            
            cell.delegate = self
            cell.configureCell()
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func didTapUpdateButton(cell: StudentExamListTableViewCell) {
        if let indexPath = StudentListTableView.indexPath(for: cell) {
                let student = self.students[indexPath.row]
                
                ExamNoteStudentList.updateId(newValue: student.studentId)
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let examUpdateViewController = storyboard.instantiateViewController(withIdentifier: "UpdateGradesViewController") as? UpdateGradesViewController {

                    
                    examUpdateViewController.modalPresentationStyle = .fullScreen
                    self.present(examUpdateViewController, animated: true, completion: nil)
                }
            }
    }
    
    
    @IBAction func submitButtonClicked(_ sender: Any) {
        
        guard let url = URL(string: "https://localhost:7253/api/teacher/EnteringStudentGrades") else {
                fatalError("Geçersiz URL")
            }
        guard let token = UserDefaults.standard.string(forKey: "refreshTokenTeacher") else {
                   print("Token yok veya geçersiz")
                   return
               }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let classIdQueryItem = URLQueryItem(name: "classId", value: "\(StudentFilterModel.getClassId())")
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        urlComponents.queryItems = [classIdQueryItem]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: StudentUpdateExamNoteModel.getAllStudents().map { person in
                return [
                    "studentId": person.studentId,
                    "lessonId": person.lessonId,
                    "exam_1": person.midterm,
                    "exam_2": person.final
                ]
            }, options: .prettyPrinted)
            
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("Serialized JSON:")
                print(jsonString)
                if let jsonDataFromString = jsonString.data(using: .utf8) {
                    request.httpBody = jsonDataFromString
                } else {
                    print("Cannot convert String to Data.")
                }
    }
        } catch {
            print("JSON Serialization Error: \(error.localizedDescription)")
        }
        let session = URLSession(configuration: .default, delegate: MySessionDelegate(), delegateQueue: nil)
        let task = session.dataTask(with: request) { data, response, error in
               if let error = error {
                   print("İstek hatası: \(error.localizedDescription)")
                   return
               }
               guard let httpResponse = response as? HTTPURLResponse else {
                   print("Geçersiz yanıt")
                   return
               }
               print("HTTP Durum Kodu: \(httpResponse.statusCode)")
               
               guard let data = data else {
                   print("Veri yok")
                   return
               }
               do {
                   if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                       print("Yanıt: \(jsonResponse)")
                   } else {
                       print("JSON formatı beklenmiyor")
                   }
               } catch let error {
                   print("JSON Parsing error: \(error.localizedDescription)")
               }
           }

           task.resume()

        
        showAlert()
       
    }
    
    private func showAlert() {
        let alertController = UIAlertController(title: "Başarılı", message: "Öğrenci notları sisteme başarıyla kaydedildi.", preferredStyle: .alert)
            
        let anaSayfayaDonAction = UIAlertAction(title: "Ana Sayfaya Dön", style: .default) { _ in
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let examUpdateViewController = storyboard.instantiateViewController(withIdentifier: "TeacherProfileVC") as? TeacherProfileViewController {
                    examUpdateViewController.modalPresentationStyle = .fullScreen
                    self.present(examUpdateViewController, animated: true, completion: nil)
                }
        }

        alertController.addAction(anaSayfayaDonAction)
        present(alertController, animated: true, completion: nil)
    }
}

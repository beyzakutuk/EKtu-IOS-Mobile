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

           
            let parameters: [String: Any] = [
                "classId": StudentFilterModel.getClassId(),
                "lessonId": StudentFilterModel.getLessonId()
            ]

            do {
                // Verileri JSON formatına dönüştürün
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
                
                do {
                    // Yanıtı işleyin
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
                                        print("Öğrenci Adı: \(decodedName)")
                                        let student = ExamNoteStudentList(studentId: studentId, studentName: decodedName, midtermNote: midterm, finalNote: final)
                                        
                                        ExamNoteStudentList.ogrenci(studentId: studentId, studentName: decodedName, midtermNote: midterm, finalNote: final)
                                        
                                    }
                                    else
                                    {
                                        let student = ExamNoteStudentList(studentId: studentId, studentName: studentName, midtermNote: midterm, finalNote: final)
                                        
                                        ExamNoteStudentList.ogrenci(studentId: studentId, studentName: studentName, midtermNote: midterm, finalNote: final)
                                    }
                                    
                                    self.students = ExamNoteStudentList.getAllStudents()
                                    
                                    DispatchQueue.main.async {
                                        self.StudentListTableView.reloadData()
                                    }

                                        
                                }
                                
                                
                            } }}}
                
                        catch let error {
                    print("JSON Parsing error: \(error.localizedDescription)")
                }
            }

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
            cell.midtermGrades.text = "\(student.midtermNote)"
            cell.finalGrades.text = "\(student.finalNote)"
            
            cell.delegate = self
            cell.configureCell()
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Örnek olarak 150 piksel sabit bir yükseklik veriyoruz
        return 120
    }
    
    func didTapUpdateButton(cell: StudentExamListTableViewCell) {
        if let indexPath = StudentListTableView.indexPath(for: cell) {
                let student = self.students[indexPath.row]
                
                // Seçilen öğrencinin studentId'sini static değişkenimize ata
                ExamNoteStudentList.updateId(newValue: student.studentId)
                
                // Öğrencinin notlarının güncelleneceği sayfaya yönlendir
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let examUpdateViewController = storyboard.instantiateViewController(withIdentifier: "UpdateGradesViewController") as? UpdateGradesViewController {

                    
                    // Present modally olarak göster
                    examUpdateViewController.modalPresentationStyle = .fullScreen
                    self.present(examUpdateViewController, animated: true, completion: nil)
                }
            }
    }
    
    @IBAction func submitButtonClicked(_ sender: Any) {
        

        
    }
}

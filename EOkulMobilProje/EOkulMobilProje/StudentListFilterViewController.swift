//
//  StudentListFilterViewController.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 25.06.2024.
//

import UIKit

class StudentListFilterViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, StudentListFilterDelegate{
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var students : [FilteredStudentListModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setInitViews()

        geturl()
    }
    
    func setInitViews() {
        tableView.delegate = self
        tableView.dataSource = self
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
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Geçersiz yanıt")
                    return
                }
                
                print("HTTP Durum Kodu: \(httpResponse.statusCode)")
                
                do {
                    // Yanıtı işleyin
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        print("Yanıt: \(jsonResponse)")
                        
                        if let jsonData = jsonResponse["data"] as? [[String: Any]] {
                            for studentData in jsonData {
                                if let studentName = studentData["studentName"] as? String,
                                   let studentId = studentData["studentId"] as? Int
                                {
                                    if let decodedName = studentName.applyingTransform(StringTransform(rawValue: "Any-Name"), reverse: true) {
                                        print("Öğrenci Adı: \(decodedName)")
                                        let student = FilteredStudentListModel(studentId: studentId, studentName: decodedName)
                                        
                                        FilteredStudentListModel.addStudent(studentId: studentId, studentName: decodedName)
                                        
                                    }
                                    else
                                    {
                                        let student = FilteredStudentListModel(studentId: studentId, studentName: studentName)
                                        
                                        FilteredStudentListModel.addStudent(studentId: studentId, studentName: studentName)
                                    }
                                    
                                    self.students = FilteredStudentListModel.getAllStudents()
                                    
                                    DispatchQueue.main.async {
                                        self.tableView.reloadData()
                                    }

                                        
                                }
                                
                                
                            } }}}
                
                        catch let error {
                    print("JSON Parsing error: \(error.localizedDescription)")
                }
            }

            task.resume()
    }
    
    
    @IBAction func submitButtonClicked(_ sender: Any) {
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StudentListFilterTableViewCell
            let student = self.students[indexPath.row]

            cell.nameLabel.text = student.studentName
            
            cell.delegate = self
            cell.configureCell()
            
            return cell
        }
    }
    
    func didTapAddButton(cell: StudentListFilterTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
                let student = self.students[indexPath.row]
                
                // Seçilen öğrencinin studentId'sini static değişkenimize ata
            FilteredStudentListModel.updateId(newValue: student.studentId)
                
                // Öğrencinin notlarının güncelleneceği sayfaya yönlendir
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let addAbsenceViewController = storyboard.instantiateViewController(withIdentifier: "AddAbsenceViewController") as? AddAbsenceViewController {

                    
                    // Present modally olarak göster
                    addAbsenceViewController.modalPresentationStyle = .fullScreen
                    self.present(addAbsenceViewController, animated: true, completion: nil)
                }
            }
    }

    

}

//
//  TeacherListViewController.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 29.06.2024.
//

import UIKit

class TeacherListViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    var teachers : [TeacherModel] = []
    
    @IBOutlet weak var tableView: UITableView!
    weak var delegate: TeacherSelectionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        getTeachers()
        
    }
    
    func getTeachers()
    {
        let urlStringGet = "https://localhost:7253/api/teacher/getAllTeeacher"
               
        var request = URLRequest(url: URL(string: urlStringGet)!)
        request.httpMethod = "GET"
        
        let session = URLSession(configuration: .default, delegate: MySessionDelegate(), delegateQueue: nil)
        let task = session.dataTask(with: request) { data, response, error in
            print("request başarılı")
            if let error = error {
                print("Hata: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("Boş yanıt")
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                print(httpResponse.statusCode)
                if httpResponse.statusCode == 200 {
             
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            print("Alınan veri: \(json)")
                            
                            TeacherModel.removeAllTeachers()
                            
                            if let jsonData = json["data"] as? [[String: Any]] {
                                for studentData in jsonData {
                                    if let teacherName = studentData["name"] as? String,
                                       let teacherId = studentData["id"] as? Int
                                    {
                                        TeacherModel.id = teacherId
                                        if let decodedName = teacherName.applyingTransform(StringTransform(rawValue: "Any-Name"), reverse: true) {
                                            let teacher = TeacherModel(teacherId: teacherId, teacherName: teacherName)
                                            TeacherModel.addTeacher(teacher)
                                        }
                                        else
                                        {
                                            let teacher = TeacherModel(teacherId: teacherId, teacherName: teacherName)
                                            TeacherModel.addTeacher(teacher)
                                        }
                                        
                                    }
                                }
                            }
                            
                            self.teachers = TeacherModel.getAllTeachers()
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                            
                            
                        }
                            else {
                                print("Geçersiz JSON formatı.")
                            }
                        } catch {
                            print("JSON çözümleme hatası: \(error)")
                        }
                    } else {
                        print("Sunucudan hata kodu alındı: \(httpResponse.statusCode)")
                        }
                    }
                }
        
            // İsteği başlatma
            task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teachers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TeacherListTableViewCell
        let teacher = self.teachers[indexPath.row]
        cell.teacherName.text = teacher.teacherName


        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedTeacher = teachers[indexPath.row]
            TeacherModel.id = selectedTeacher.teacherId
            
            print("Selected Teacher ID: \(TeacherModel.id)")
            
            delegate?.didSelectTeacher(selectedTeacher)
            self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

protocol TeacherSelectionDelegate: AnyObject {
    func didSelectTeacher(_ teacher: TeacherModel)
}

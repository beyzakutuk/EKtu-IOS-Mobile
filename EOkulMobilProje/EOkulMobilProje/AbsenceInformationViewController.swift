//
//  AbsenceInformationViewController.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 27.06.2024.
//

import UIKit

class AbsenceInformationViewController: UIViewController {
    

    @IBOutlet weak var className: UIButton!
    @IBOutlet weak var lessonName: UIButton!
    
    var isClassSelected: Bool = false
    var classID: Int = 0
    
    var lessonId: Int?
    
    var teacherLessons: [TeacherClassLessonListModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func classSelectionButton(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Sınıf", message: "Bir sınıf seçiniz", preferredStyle: .actionSheet)
        
        let birAction = UIAlertAction(title: "1", style: .default) { _ in
                
            self.className.setTitle("1", for: UIControl.State.normal)
            self.className.titleLabel?.textColor = .black
            self.isClassSelected = true
            self.classID = 1
            StudentFilterModel.updateClassId(newValue: 1)

            print("Seçilen Yil: 1")
        }
        
        let ikiAction = UIAlertAction(title: "2", style: .default) { _ in
                
            self.className.setTitle("2", for: UIControl.State.normal)
            self.className.titleLabel?.textColor = .black
            self.isClassSelected = true
            self.classID = 2
            StudentFilterModel.updateClassId(newValue: 2)

            print("Seçilen Tip: 2")
        }
        
        let ucAction = UIAlertAction(title: "3", style: .default) { _ in
                
            self.className.setTitle("3", for: UIControl.State.normal)
            self.className.titleLabel?.textColor = .black
            self.isClassSelected = true
            self.classID = 3
            StudentFilterModel.updateClassId(newValue: 3)

            print("Seçilen Yil: 3")
        }
        
        let dortAction = UIAlertAction(title: "4", style: .default) { _ in
                
            self.className.setTitle("4", for: UIControl.State.normal)
            self.className.titleLabel?.textColor = .black
            self.isClassSelected = true
            self.classID = 4
            StudentFilterModel.updateClassId(newValue: 4)
            
            print("Seçilen Tip: 4")
        }
        
        alertController.addAction(birAction)
        alertController.addAction(ikiAction)
        alertController.addAction(ucAction)
        alertController.addAction(dortAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func lessonSelectionButton(_ sender: Any) {
        guard let token = UserDefaults.standard.string(forKey: "refreshTokenTeacher") else {
                   print("Token yok veya geçersiz")
                   return
               }
        guard let url = URL(string: "https://localhost:7253/api/teacher/teacherclasslessonlist") else {
                print("Geçersiz URL")
                return
            }
        var request = URLRequest(url: url)
            request.httpMethod = "GET"
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue( "\(self.classID)", forHTTPHeaderField:"classId")
        
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
            
            // Gelen veriyi yazdırın
            if let responseString = String(data: data, encoding: .utf8) {
                print("Yanıt Verisi: \(responseString)")
            }
            
            do {
                // Yanıtı işleyin
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Yanıt: \(jsonResponse)")
                    
                    // `data` alanındaki diziyi al
                    if let dataArray = jsonResponse["data"] as? [[String: Any]] {
                        // Her bir öğeyi işleyin
                        
                        TeacherClassLessonListModel.tumDersleriSil()
                        
                        if TeacherClassLessonListModel.teacherslesson.isEmpty
                        {
                            for lesson in dataArray {
                                if let lessonId = lesson["lessonId"] as? Int,
                                   let lessonName = lesson["lessonName"] as? String {
                                    print("Ders ID: \(lessonId), Ders Adı: \(lessonName)")
                                    
                                    let lesson = TeacherClassLessonListModel(lessonId: lessonId, lessonName: lessonName)
                                    TeacherClassLessonListModel.dersEkle(lessonId: lesson.lessonId, lessonName: lesson.lessonName)
                                    
                                }
                            }
                        }
                        
                        self.teacherLessons = TeacherClassLessonListModel.getAllTeachersLessons()
                        
                        print(self.teacherLessons)
                        
                        DispatchQueue.main.async {
                            
                            let alertController = UIAlertController(title: "Ders Seç", message: "Bir ders seçiniz", preferredStyle: .actionSheet)
                            for lessonItem in self.teacherLessons {
                                let action = UIAlertAction(title: lessonItem.lessonName, style: .default) { _ in
                                    print("Seçilen Ders: \(lessonItem.lessonName)")
                                    self.lessonId = lessonItem.lessonId
                                    self.lessonName.setTitle(lessonItem.lessonName, for: UIControl.State.normal)
                                    StudentFilterModel.updateLessonId(newValue: lessonItem.lessonId)
                                }
                                alertController.addAction(action)
                            }
                            self.present(alertController, animated: true, completion: nil)
                        }
                        
                    }
                }
                    else {
                    print("JSON formatı beklenmiyor")
                }
            } catch let error {
                print("JSON Parsing error: \(error.localizedDescription)")
            }
        }

        task.resume()
    }
    
    @IBAction func getListButton(_ sender: Any) {
    }
    
}

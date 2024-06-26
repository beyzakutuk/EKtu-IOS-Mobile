//
//  ExamFinalizationViewController.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 18.06.2024.
//

import UIKit

class ExamFinalizationViewController: UIViewController , URLSessionDelegate {
    
    @IBOutlet weak var className: UIButton!
    
    var isYilSelected : Bool = false
    var DonemID : Int = 0
    
    var secilenDersId: Int?
    
    @IBOutlet weak var lessonName: UIButton! // seçilen dersin ismi
    
    var teacherLessons: [TeacherClassLessonListModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if let serverTrust = challenge.protectionSpace.serverTrust {
            completionHandler(.useCredential, URLCredential(trust: serverTrust))
        } else {
            completionHandler(.performDefaultHandling, nil)
        }
    }
    
    
    
    
    @IBAction func ClassSelectionButton(_ sender: Any) {//burada öğretmenin seçtiği sınıfa göre filtreleme yapılacak
        
        let alertController = UIAlertController(title: "Sınıf", message: "Bir sınıf seçiniz", preferredStyle: .actionSheet)
        
        let birAction = UIAlertAction(title: "1", style: .default) { _ in
                
            self.className.setTitle("1", for: UIControl.State.normal)
            self.className.titleLabel?.textColor = .black
            self.isYilSelected = true
            self.DonemID = 1
            StudentFilterModel.updateClassId(newValue: 1)

            print("Seçilen Yil: 1")
        }
        
        let ikiAction = UIAlertAction(title: "2", style: .default) { _ in
                
            self.className.setTitle("2", for: UIControl.State.normal)
            self.className.titleLabel?.textColor = .black
            self.isYilSelected = true
            self.DonemID = 2
            StudentFilterModel.updateClassId(newValue: 2)

            print("Seçilen Tip: 2")
        }
        
        let ucAction = UIAlertAction(title: "3", style: .default) { _ in
                
            self.className.setTitle("3", for: UIControl.State.normal)
            self.className.titleLabel?.textColor = .black
            self.isYilSelected = true
            self.DonemID = 3
            StudentFilterModel.updateClassId(newValue: 3)

            print("Seçilen Yil: 3")
        }
        
        let dortAction = UIAlertAction(title: "4", style: .default) { _ in
                
            self.className.setTitle("4", for: UIControl.State.normal)
            self.className.titleLabel?.textColor = .black
            self.isYilSelected = true
            self.DonemID = 4
            StudentFilterModel.updateClassId(newValue: 4)
            
            print("Seçilen Tip: 4")
        }
        
        alertController.addAction(birAction)
        alertController.addAction(ikiAction)
        alertController.addAction(ucAction)
        alertController.addAction(dortAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func LessonSelectionButton(_ sender: Any) {
        
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
        request.setValue( "\(self.DonemID)", forHTTPHeaderField:"classId")
        
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
                                    self.secilenDersId = lessonItem.lessonId
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

    
    @IBAction func GetStudentListButton(_ sender: Any) {
        
        // Sınıf seçilmemişse uyarı ver
        guard isYilSelected else {
            showAlert(title: "Uyarı", message: "Lütfen önce bir sınıf seçiniz.")
            return
        }
           
        // Ders seçilmemişse uyarı ver
        guard secilenDersId != nil else {
            showAlert(title: "Uyarı", message: "Lütfen önce bir ders seçiniz.")
            return
        }
           
  
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let studentExamList = storyboard.instantiateViewController(withIdentifier: "StudentExamList") as? StudentExamListViewController {
            studentExamList.modalPresentationStyle = .fullScreen
            self.present(studentExamList, animated: true, completion: nil)
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Tamam", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    
}





//
//  StudentTranscriptViewController.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 7.05.2024.
//

import UIKit

class StudentTranscriptViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {

    let Donemler = ["Güz Dönemi", "Bahar Dönemi"]
    var seciliDonemIndisi: Int = 0
    
    @IBOutlet weak var DonemSecimButton: UIButton!
    @IBOutlet weak var Donem: UILabel!
    
    var lessons: [TranscriptModel] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        DonemSecimButton.addTarget(self, action: #selector(showDropdownMenu), for: .touchUpInside)
        
    }
    
    func getUrl()
    {
        guard let token = UserDefaults.standard.string(forKey: "refreshToken") else {
                   print("Token yok veya geçersiz")
                   return
               }
        guard let url = URL(string: "https://localhost:7253/api/student/StudentListExamGrande") else {
                print("Geçersiz URL")
                return
            }
        var request = URLRequest(url: url)
            request.httpMethod = "GET"
        
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        if seciliDonemIndisi == 0
        {
            request.setValue("false", forHTTPHeaderField: "term")
        }
        
        else
        {
            request.setValue("true", forHTTPHeaderField: "term")
        }
        
        TranscriptModel.removeAllLessons()
        
        let session = URLSession(configuration: .default, delegate: MySessionDelegate(), delegateQueue: nil)
        let task = session.dataTask(with: request) { data, response, error in
            print("Request tamamlandı")
            
                if let error = error {
                    print("Hata: \(error.localizedDescription)")
                    return
                }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Geçersiz yanıt")
                return
            }
            
            print("HTTP Durum Kodu: \(httpResponse.statusCode)")
                
                guard let data = data else {
                    print("Boş veri")
                    return
                }
            

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print(json)
                    
                    if let dataArray = json["data"] as? [[String: Any]] {
                                       for item in dataArray {
                                           if let studentChooseExamGrande = item["studentChooseExamGrande"] as? [[String: Any]] {
                                               for exam in studentChooseExamGrande {
                                                   if let lessonName = exam["lessonName"] as? String,
                                                      let exam1 = exam["exam1"] as? Int,
                                                      let exam2 = exam["exam2"] as? Int,
                                                      let letterGrade = exam["letterGrade"] as? String{
                                                       
                                                       print("Lesson Name: \(lessonName)")
                                                       print("Exam 1: \(exam1)")
                                                       print("Exam 2: \(exam2)")
                                                       print("LetterGrade: \(letterGrade)")
                                                       
                                                       TranscriptModel.addLessons(lessonName: lessonName ,letterGrade: letterGrade)
                                                   }
                                               }
                                           }
                                       }
                                       self.lessons = TranscriptModel.getAllLessons()
                                       
                                       DispatchQueue.main.async {
                                           self.tableView.reloadData()
                                       }
                                   }
                    
                }
            }catch {
                print("JSON parse hatası: \(error.localizedDescription)")
            }
        }
        
    task.resume()
    }
    
    @objc func showDropdownMenu() {
        let alertController = UIAlertController(title: "Dönem Seçiniz", message: nil, preferredStyle: .actionSheet)
        
        let fallAction = UIAlertAction(title: "Güz Dönemi", style: .default) { _ in

            print("Güz Dönemi Seçildi")
            self.Donem.text = "Güz"
            self.seciliDonemIndisi = 0
            self.getUrl()
            self.tableView.reloadData()
        }
        
        alertController.addAction(fallAction)
        
        let springAction = UIAlertAction(title: "Bahar Dönemi", style: .default) { _ in

            print("Bahar Dönemi Seçildi")
            self.Donem.text = "Bahar"
            self.seciliDonemIndisi = 1
            self.getUrl()
            self.tableView.reloadData()
            
        }
        
        alertController.addAction(springAction)

        let cancelAction = UIAlertAction(title: "İptal", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        alertController.view.tintColor = UIColor.blue
        present(alertController, animated: true, completion: nil)
    }
    
    
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return lessons.count
       }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }

       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           if lessons.isEmpty {
                let emptyCell = tableView.dequeueReusableCell(withIdentifier: "emptyCell", for: indexPath)
                emptyCell.textLabel?.text = "Ders bulunmuyor"
                return emptyCell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TranscriptTableViewCell
                let entry = lessons[indexPath.row]
                cell.lessonName.text = entry.lessonName
                
                if entry.letterGrade == nil {
                    cell.grade.text = "G"
                } else {
                    cell.grade.text = entry.letterGrade
                }
                
                return cell
            }
       }


}


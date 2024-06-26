//
//  StudentExamResultsViewController.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 4.05.2024.
//

import UIKit

class StudentExamResultsViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, URLSessionDelegate {
    
    // MARK: -VARIABLES
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var DonemSecimButton: UIButton!
    @IBOutlet weak var Donem: UILabel!
    
    let Donemler = ["Güz Dönemi", "Bahar Dönemi"]
    var seciliDonemIndisi: Int?

    var term = 0
    
    var lessons: [StudentExamsModel] = []
    
    // MARK: -FUNCTIONS

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUrl()
        
        // Butona bir dokunma olayı ekleyin
        DonemSecimButton.addTarget(self, action: #selector(showDropdownMenu), for: .touchUpInside)

        setInitViews()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CourseCell")
        tableView.reloadData()
    }
    
    func setInitViews()
    {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func getUrl()
    {
        
        guard let token = UserDefaults.standard.string(forKey: "refreshToken") else {
                   print("Token yok veya geçersiz")
                   return
               }
        guard let url = URL(string: "https://localhost:7253/api/student/studentlistexamgrande") else {
                print("Geçersiz URL")
                return
            }
        var request = URLRequest(url: url)
            request.httpMethod = "GET"
        
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
    
        
        
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
                    
                    if let firstName = json["firstName"] as? String,
                       let lastName = json["lastName"] as? String,
                       let studentChooseExamGrande = json["studentChooseExamGrande"] as? [[String: Any]] {
                        
                        print("First Name: \(firstName)")
                        print("Last Name: \(lastName)")
                        
                        for examData in studentChooseExamGrande {
                            if let lessonName = examData["lessonName"] as? String,
                               let exam1 = examData["exam1"] as? Int,
                               let exam2 = examData["exam2"] as? Int {
                                
                                print("Lesson Name: \(lessonName)")
                                print("Exam 1: \(exam1)")
                                print("Exam 2: \(exam2)")
                                
                                // Örnek olarak StudentExamsModel'e ekleme yapabiliriz
                                StudentExamsModel.addLessons(lessonName: lessonName, midterm: exam1, final: exam2, term: self.term)
                            }
                        }
                        
                        // Tüm dersleri yeniden yükle ve tabloyu güncelle
                        self.lessons = StudentExamsModel.getAllLessons()
                        
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
        
        // Güz dönemi seçeneği
        let fallAction = UIAlertAction(title: "Güz Dönemi", style: .default) { _ in

            print("Güz Dönemi Seçildi")
            self.Donem.text = "Güz"
            self.seciliDonemIndisi = 0
            self.tableView.reloadData()
        }
        
        alertController.addAction(fallAction)
        
        // Bahar dönemi seçeneği
        let springAction = UIAlertAction(title: "Bahar Dönemi", style: .default) { _ in

            print("Bahar Dönemi Seçildi")
            self.Donem.text = "Bahar"
            self.seciliDonemIndisi = 1
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StudentsCoursesTableViewCell
        let allLessons = StudentExamsModel.getAllLessons()
            
        // İstenen döneme göre dersleri filtreleyin
        var filteredLessons: [StudentExamsModel] = []
        if let selectedTermIndex = seciliDonemIndisi {
            filteredLessons = allLessons.filter { $0.term == selectedTermIndex }
        } else {
            // Eğer herhangi bir dönem seçilmediyse tüm dersleri gösterin
            filteredLessons = allLessons
        }

        
        let lesson = filteredLessons[indexPath.row]
        
        cell.titleLabel.text = lesson.lessonName
        cell.midtermResult.text = "Ara Sınav: \(lesson.midterm)"
        cell.finalResult.text = "Final: \(lesson.final)"
            
        return cell
    }
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }


}
  

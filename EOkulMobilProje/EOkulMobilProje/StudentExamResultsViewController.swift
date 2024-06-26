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
    var seciliDonemIndisi: Int = 0
    
    var lessons: [StudentExamsModel] = []
    
    // MARK: -FUNCTIONS

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUrl()
        
        // Butona bir dokunma olayı ekleyin
        DonemSecimButton.addTarget(self, action: #selector(showDropdownMenu), for: .touchUpInside)

        setInitViews()

         
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
        
        StudentExamsModel.removeAllLessons()
        
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
                            if let lessonName = item["lessonName"] as? String,
                               let exam1 = item["exam1"] as? Int,
                               let exam2 = item["exam2"] as? Int {
                                
                                print("Lesson Name: \(lessonName)")
                                print("Exam 1: \(exam1)")
                                print("Exam 2: \(exam2)")
                                
                                // Örnek olarak StudentExamsModel'e ekleme yapabiliriz
                                StudentExamsModel.addLessons(lessonName: lessonName, midterm: exam1, final: exam2)
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
            self.getUrl()
            self.tableView.reloadData()
        }
        
        alertController.addAction(fallAction)
        
        // Bahar dönemi seçeneği
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let allLessons = StudentExamsModel.getAllLessons()
        
        if allLessons.isEmpty
        {
            let emptyCell = tableView.dequeueReusableCell(withIdentifier: "emptyCell", for: indexPath)
            return emptyCell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StudentsCoursesTableViewCell
            
            let lesson = allLessons[indexPath.row]
            
            cell.titleLabel.text = lesson.lessonName
            
            if lesson.midterm == 0
            {
                cell.midtermResult.text = "Ara Sınav: G"
            }
            else
            {
                cell.midtermResult.text = "Ara Sınav: \(lesson.midterm)"
            }
            
            if lesson.final == 0
            {
                cell.finalResult.text = "Final: G"
            }
            else
            {
                cell.finalResult.text = "Final: \(lesson.final)"
            }
                
            return cell
            
        }
        
        
       
    }
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }


}
  

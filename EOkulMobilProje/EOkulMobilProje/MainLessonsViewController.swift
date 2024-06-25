//
//  MainLessonsViewController.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 31.05.2024.
//
import UIKit

class MainLessonsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, URLSessionDelegate, StudentCourseSelectionDelegate {


    @IBOutlet weak var lessonsTableView: UITableView!
    
    var lessons: [MainLessonModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setInitViews()
        getUrl()
        
        lessons = MainLessonModel.getAllMainLessons()
    }

    func setInitViews() {
        lessonsTableView.delegate = self
        lessonsTableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lessons.isEmpty ? 1 : lessons.count
    }
    
    func getUrl()
    {
        
        // Kullanıcı bilgilerini almak için kullanılacak token
        guard let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") else {
            print("Refresh token alınamadı.")
            return
        }

        guard let urls = URL(string: "https://localhost:7253/api/student/termlessonlist") else {
            print("Geçersiz URL")
            return
            }
        
        var termlessonrequest = URLRequest(url: urls)
        termlessonrequest.httpMethod = "GET"
        
        
        termlessonrequest.setValue("false", forHTTPHeaderField: "term")
        termlessonrequest.setValue("Bearer \(refreshToken)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession(configuration: .default, delegate: MySessionDelegate(), delegateQueue: nil)
                                
        let termlesssontask=session.dataTask(with: termlessonrequest){ data,response,error in
            print("request tamamlandi")
            
            if let error = error {
                       print("Hata: \(error.localizedDescription)")
                       return
                   }

                   guard let data = data else {
                       print("Boş veri")
                       return
                   }

                   // Response'u parse edin ve kullanın
                   if let httpResponse = response as? HTTPURLResponse {
                       print("Response status code: \(httpResponse.statusCode)")

                       do {
                           // JSON verisini işleyin
                           if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                               print("JSON: \(json)")
                               
                               
                               
                               if let jsonData = json["data"] as? [String: Any],
                                  let anaDersData = jsonData["anaDers"] as? [[String: Any]] {
                                   
                                   if MainLessonModel.mainLessons.isEmpty
                                   {
                                       if SelectedLessonModel.selectedCourse.isEmpty
                                       {
                                           for lessonData in anaDersData {
                                               if let lessonId = lessonData["lessonId"] as? Int,
                                                  let lessonName = lessonData["lessonName"] as? String {
                                                   let lesson = MainLessonModel(lessonId: lessonId, lessonName: lessonName)
                                                   self.lessons.append(lesson)
                                                   MainLessonModel.dersEkle(lessonId: lesson.lessonId, lessonName: lesson.lessonName)
                                               }
                                           }
                                       }
                                   }
                                   
                                   if let jsonData = json["data"] as? [String: Any],
                                      let secmeliDersData = jsonData["secmeliDers"] as? [[String: Any]] {
                                       if secmeliDersData != nil
                                       {
                                           if OptionalModel.optional1.isEmpty
                                           {
                                               for lessonData in secmeliDersData {
                                                   if let lessonId = lessonData["lessonId"] as? Int,
                                                      let optionalLessonId = lessonData["optionalLessonId"] as? Int,
                                                      let lessonName = lessonData["lessonName"] as? String{
                                                       
                                                       if optionalLessonId == 1
                                                       {
                                                            OptionalModel.Secmeli1Ekle(lessonId: lessonId, lessonName: lessonName , optionalNumber: 1)
                                                           
                                                       }
                                                       if optionalLessonId == 2
                                                       {
                                                            OptionalModel.Secmeli2Ekle(lessonId: lessonId, lessonName: lessonName , optionalNumber: 2)
                                                       }
                                                       if optionalLessonId == 3
                                                       {
                                                            OptionalModel.Secmeli3Ekle(lessonId: lessonId, lessonName: lessonName, optionalNumber: 3)

                                                       }
                                                            
                                                       
                                                   }
                                                   }
                                               
                                           }
                                           
                                           
                                           }
                                           
                                       }
                                       
                                       DispatchQueue.main.async {
                                           self.lessonsTableView.reloadData() // TableView'i yeniden yükle
                                       }
                                   }
                               }
                           }
                       catch {
                           print("JSON parse hatası: \(error.localizedDescription)")
                       }
                   }
        }
        termlesssontask.resume()

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        
        if self.lessons.isEmpty {
            let emptyCell = tableView.dequeueReusableCell(withIdentifier: "emptyCell", for: indexPath)
            emptyCell.textLabel?.text = "Ders bulunmuyor"
            return emptyCell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "selectionCell", for: indexPath) as! StudentCourseSelectionTableViewCell
            let course = self.lessons[indexPath.row]
            cell.lessonNameLabel.text = course.lessonName

            cell.delegate = self
            cell.configureCell()
            return cell
        }
    }
    
    func didTapAddButton(cell: StudentCourseSelectionTableViewCell) {
        if let indexPath = lessonsTableView.indexPath(for: cell) {
            let selectedCourse = self.lessons.remove(at: indexPath.row) // Dersi genel listeden kaldır
            SelectedLessonModel.SecilenlereEkle(lessonId: selectedCourse.lessonId, lessonName: selectedCourse.lessonName, isOptional: false , optionalNumber: 0)
            
            MainLessonModel.anaderslerdenKaldır(lessonId: selectedCourse.lessonId)
            
         
            lessonsTableView.reloadData() // TableView'i yeniden yükle
        }
    }

}

struct CourseModels {
    let lessonId : Int
    let lessonName : String
}

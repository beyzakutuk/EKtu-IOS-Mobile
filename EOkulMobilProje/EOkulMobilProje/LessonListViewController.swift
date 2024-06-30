//
//  LessonListViewController.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 29.06.2024.
//

import UIKit

class LessonListViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: LessonSelectionDelegate?
    
    var lessons : [LessonModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getLessons()
        
    }
    
    func getLessons()
    {
        let urlStringGet = "https://localhost:7253/api/principal/getAllLesson"
        
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
                            
                            LessonModel.removeAllLesson()
                            
                            if let jsonData = json["data"] as? [[String: Any]] {
                                for lessonData in jsonData {
                                    if let lessonName = lessonData["lessonName"] as? String,
                                       let lessonId = lessonData["lessonId"] as? Int
                                    {
                                        LessonModel.id = lessonId
                                        
                                        if let decodedName = lessonName.applyingTransform(StringTransform(rawValue: "Any-Name"), reverse: true) {
                                            let lesson = LessonModel(lessonId: lessonId, lessonName: lessonName)
                                            LessonModel.addLesson(lesson)
                                        }
                                        else
                                        {
                                            let lesson = LessonModel(lessonId: lessonId, lessonName: lessonName)
                                            LessonModel.addLesson(lesson)
                                        }
                                        
                                    }
                                }
                            }
                            
                            self.lessons = LessonModel.getAllLesson()
                            
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
    
    task.resume()
   
}

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lessons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LessonListTableViewCell
        let lesson = self.lessons[indexPath.row]
        cell.lessonName.text = lesson.lessonName


        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           let selectedLesson = lessons[indexPath.row]
           LessonModel.id = selectedLesson.lessonId
           
           print("Selected Lesson ID: \(LessonModel.id)")
           
           delegate?.didSelectLesson(selectedLesson)
           self.dismiss(animated: true, completion: nil)
       }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60 
    }


}

protocol LessonSelectionDelegate: AnyObject {
    func didSelectLesson(_ lesson: LessonModel)
}

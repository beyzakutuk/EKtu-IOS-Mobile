//
//  StudentCourseSelectionViewController.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 6.05.2024.
//

import UIKit

class StudentCourseSelectionViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource , StudentSelectedCourseDelegate , URLSessionDelegate {
    
    // MARK: -VARIABLES
    
    @IBOutlet weak var selectedLessonsTableView: UITableView!
    
    var selectedCourses: [SelectedLessonModel] = []
    
    
    // MARK: -FUNCTIONS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitViews()
        
        selectedCourses = SelectedLessonModel.getAllSelected()
    }
    
    func setInitViews()
    {
        selectedLessonsTableView.delegate = self
        selectedLessonsTableView.dataSource = self
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedCourses.isEmpty ? 1 : selectedCourses.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if selectedCourses.isEmpty {
            let emptyCell = tableView.dequeueReusableCell(withIdentifier: "emptyCell", for: indexPath)
            emptyCell.textLabel?.text = "Seçili ders bulunmuyor."
            return emptyCell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "selectedCell", for: indexPath) as! StudentSelectedCourseTableViewCell
            let selectedCourse = selectedCourses[indexPath.row]
            cell.selectedLessonName.text = selectedCourse.lessonName
            
            cell.delegate = self
            cell.configureCell()
            
            return cell
        }
    }
    
    
    func didTapRemoveButton(cell: StudentSelectedCourseTableViewCell) {
        
        if let indexPath = selectedLessonsTableView.indexPath(for: cell) {
            let selectedCourse = self.selectedCourses.remove(at: indexPath.row) // Dersi genel listeden kaldır
            SelectedLessonModel.SecilenlerdenKaldır(lessonId: selectedCourse.lessonId)
            
            if(selectedCourse.isOptional)
            {
                if(selectedCourse.optionalNumber == 1)
                {
                    OptionalModel.Secmeli1Ekle(lessonId: selectedCourse.lessonId, lessonName: selectedCourse.lessonName, optionalNumber: selectedCourse.optionalNumber)
                }
                
                else if(selectedCourse.optionalNumber == 2)
                {
                    OptionalModel.Secmeli2Ekle(lessonId: selectedCourse.lessonId, lessonName: selectedCourse.lessonName, optionalNumber: selectedCourse.optionalNumber)
                }
                
                else
                {
                    OptionalModel.Secmeli3Ekle(lessonId: selectedCourse.lessonId, lessonName: selectedCourse.lessonName, optionalNumber: selectedCourse.optionalNumber)
                }
            }
            else
            {
                MainLessonModel.dersEkle(lessonId: selectedCourse.lessonId, lessonName: selectedCourse.lessonName)
            }
            
            
            selectedLessonsTableView.reloadData() // TableView'i yeniden yükle
        }
    }
    
    @IBAction func submitButton(_ sender: Any) {
        
        guard let token = UserDefaults.standard.string(forKey: "refreshToken") else {
                   print("Token yok veya geçersiz")
                   return
               }
        
        guard let url = URL(string: "https:localhost:7253/api/student/studentchooselesson") else {
                fatalError("Geçersiz URL")
            }
        var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        
        let selectedIds = SelectedLessonModel.getAllSelectedIds()
        
        let requestBody = StudentChooseLessonRequestDto(lessonId: selectedIds)

            do {
                let jsonData = try JSONEncoder().encode(requestBody)
                request.httpBody = jsonData
            } catch {
                print("JSON verisi oluşturulamadı: (error.localizedDescription)")
                return
            }
        
        let session = URLSession(configuration: .default, delegate: MySessionDelegate(), delegateQueue: nil)
        let task = session.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("İstek hatası: (error.localizedDescription)")
                    return
                }

                if let httpResponse = response as? HTTPURLResponse {
                    print("HTTP Durum Kodu: \(httpResponse.statusCode)")
                }

                if let data = data {
                    do {
                        // Yanıt verisini JSON olarak işleme
                        if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            print("JSON Yanıtı: (jsonResponse)")
                        }
                    } catch {
                        print("Yanıt verisi işlenemedi: (error.localizedDescription)")
                    }
                }
            }

            task.resume()
        
        Validate.lessonRegisterHasChanged = true
        Validate.lessonRegisterPermission = false
       
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let examUpdateViewController = storyboard.instantiateViewController(withIdentifier: "StudentProfileVC") as? StudentProfileViewController {
                examUpdateViewController.modalPresentationStyle = .fullScreen
                self.present(examUpdateViewController, animated: true, completion: nil)
            }
        
        
        
    }
    
    
}

struct StudentChooseLessonRequestDto: Codable {
    let lessonId: [Int]
}


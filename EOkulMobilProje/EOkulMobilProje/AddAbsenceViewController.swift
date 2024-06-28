//
//  AddAbsenceViewController.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 28.06.2024.
//

import UIKit

class AddAbsenceViewController: UIViewController {
    
    
    @IBOutlet weak var AbsenceTypeButton: UIButton!
    
    @IBOutlet weak var AbsenceReasonTextField: UITextField!
    
    var hasExcused: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func AbsenceTypeButtonClicked(_ sender: Any) {
        
        let alert = UIAlertController(title: "İzin Tipi Seç", message: nil, preferredStyle: .actionSheet)

        let izinliAction = UIAlertAction(title: "İzinli", style: .default) { (action) in
            print("Öğrenci izinli olarak seçildi.")
            self.AbsenceTypeButton.setTitle("İzinli", for: .normal)
            self.hasExcused = true
        }

        let izinsizAction = UIAlertAction(title: "İzinli Değil", style: .default) { (action) in
            print("Öğrenci izinli değil olarak seçildi.")
            self.AbsenceTypeButton.setTitle("İzinli Değil", for: .normal)
            self.hasExcused = false

        }

        alert.addAction(izinliAction)
        alert.addAction(izinsizAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func submitButton(_ sender: Any) {
        
        guard let url = URL(string: "https://localhost:7253/api/principal/studentattendanceadd") else {
                fatalError("Geçersiz URL")
            }
        
        guard let token = UserDefaults.standard.string(forKey: "refreshTokenPrincipal") else {
                   print("Token yok veya geçersiz")
                   return
               }

        // URLRequest oluşturma
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        // Örnek Date nesnesi
        let date = Date()

        // DateFormatter kullanarak Date nesnesini String formatına dönüştürme
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" // ISO 8601 formatı
        let dateString = dateFormatter.string(from: date)
        
        
         let parameters: [String: Any] = [
            "studentId": FilteredStudentListModel.getId(),
            "lessonId": StudentFilterModel.getLessonId(),
            "permissionCheck": hasExcused,
            "reasonForAbsence": AbsenceReasonTextField.text!,
            "attendanceDate": date
         ]
        
        do {
                // JSON verisini oluşturma
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch let error {
                print("JSON Serialization error: \(error.localizedDescription)")
                return
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
                        // Gelen veriyi JSON formatına dönüştürme
                        let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                        print("JSON Yanıt: \(jsonResponse)")
                    } catch let error {
                        print("JSON Parsing error: \(error.localizedDescription)")
                    }
            
        }
        
        task.resume()
        
        
        
    }
    
}

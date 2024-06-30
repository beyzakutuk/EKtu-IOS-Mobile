//
//  ApproveLessonsViewController.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 27.06.2024.
//

import UIKit

class ApproveLessonsViewController: UIViewController , URLSessionDelegate{

    @IBOutlet weak var Approve: UIButton!
    @IBOutlet weak var Calculate: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Validate.lessonRegisterHasChanged == false
        {
            Approve.isEnabled = false
        }
        else
        {
            Approve.isEnabled = true
        }
        
       
    }
    
    @IBAction func ApproveButton(_ sender: Any) {
        
        guard let token = UserDefaults.standard.string(forKey: "refreshTokenPrincipal") else {
                   print("Token yok veya geçersiz")
                   return
               }
        guard let url = URL(string: "https://localhost:7253/api/principal/StudentChooseLessonApprove") else {
                print("Geçersiz URL")
                return
            }
        var request = URLRequest(url: url)
            request.httpMethod = "GET"
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
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
            
            if let responseString = String(data: data, encoding: .utf8) {
                print("Yanıt Verisi: \(responseString)")
            }
            
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Yanıt: \(jsonResponse)")
                    
                }
                    else {
                    print("JSON formatı beklenmiyor")
                }
            } catch let error {
                print("JSON Parsing error: \(error.localizedDescription)")
            }
            
        }
        
        task.resume()
        
        Approve.isEnabled = false
        
    }
    
    @IBAction func letterGradeCalculate(_ sender: Any) {
        
        guard let token = UserDefaults.standard.string(forKey: "refreshTokenPrincipal") else {
                   print("Token yok veya geçersiz")
                   return
               }
        guard let url = URL(string: "https://localhost:7253/api/principal/AllStudentCalculateLetterGrade") else {
                print("Geçersiz URL")
                return
            }
        var request = URLRequest(url: url)
            request.httpMethod = "GET"
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
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
            
            if let responseString = String(data: data, encoding: .utf8) {
                print("Yanıt Verisi: \(responseString)")
            }
            
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Yanıt: \(jsonResponse)")
                    
                }
                    else {
                    print("JSON formatı beklenmiyor")
                }
            } catch let error {
                print("JSON Parsing error: \(error.localizedDescription)")
            }
            
        }
        
        task.resume()
        
        Calculate.isEnabled = false
        
    }
    
    
}


class Validate
{
    static var lessonRegisterHasChanged: Bool = false
    static var lessonRegisterPermission: Bool = true
    
}

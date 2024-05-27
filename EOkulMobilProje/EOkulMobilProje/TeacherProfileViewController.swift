//
//  TeacherProfileViewController.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 30.04.2024.
//

import UIKit

class TeacherProfileViewController: UIViewController , URLSessionDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    
    var teacher : TeacherModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

       setupProfile()
       GetInformation()
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
            completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
        }
    
    func GetInformation(){
        
        
        guard let token = UserDefaults.standard.string(forKey: "refreshTokenTeacher") else {
                   print("Token yok veya geçersiz")
                   return
               }
        guard let url = URL(string: "https://localhost:7134/connect/userinfo") else {
                print("Geçersiz URL")
                return
            }
        var request = URLRequest(url: url)
            request.httpMethod = "GET"
        
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        let task = session.dataTask(with: request) { data, response, error in
            print("Request tamamlandı")
                
            if let error = error {
                print("Hata: \(error.localizedDescription)")
                return
            }
                    
            guard let data = data else {
                print("Boş veri")
                return
            }
                    
            // Response'u parse edin ve kullanın
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Kullanıcı Bilgisi: \(json["name"]!)")
                    print("Kullanıcı id: \(json["sub"]!)")
                            
                } else {
                            
                        }
                
            } catch {
                        print("JSON parse hatası: \(error.localizedDescription)")
                }
        }
                
        task.resume()

    }
    

    @IBAction func exitButtonClicked(_ sender: UIButton) {
        
        let exitAlert = UIAlertController(title: "Çıkış Yap", message: "Çıkış yapmak istediğinizden emin misiniz?", preferredStyle: .alert)
        
        //evet
        exitAlert.addAction(UIAlertAction(title: "Evet", style: .default , handler: {(_) in
                                          // Giriş sayfasına geri dön
            self.performSegue(withIdentifier: "backToLogin", sender: self)
            UserDefaults.standard.removeObject(forKey: "refreshTokenTeacher")
                                      }))
        //iptal
        exitAlert.addAction(UIAlertAction(title: "İptal", style: .cancel , handler: nil))
        
        self.present(exitAlert, animated: true, completion: nil)
    }

    private func setupProfile() {
            guard let Teacher = teacher else { return }
            nameLabel.text = "\(Teacher.isim) \(Teacher.soyisim)"
    }
}

//
//  StudentProfileViewController.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 30.04.2024.
//

import UIKit

class StudentProfileViewController: UIViewController , URLSessionDelegate {
    
    // MARK: -VARIABLES
    
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var student : StudentModel?
    
    // MARK: -FUNCTIONS

    override func viewDidLoad() {
        super.viewDidLoad()
         
        GetInformation()

    }
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
            completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
        }
    
    func GetInformation(){
        
        
        guard let token = UserDefaults.standard.string(forKey: "refreshToken") else {
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
                            print("Kullanıcı className: \(json["classname"]!)")
                            
                            // Kullanıcı bilgilerini güncelle
                            DispatchQueue.main.async {
                                self.nameLabel.text = json["name"] as? String
                                self.classLabel.text = json["classname"] as? String
                            }
                            
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
            UserDefaults.standard.removeObject(forKey: "refreshToken")
                                      }))
        //iptal
        exitAlert.addAction(UIAlertAction(title: "İptal", style: .cancel , handler: nil))
        
        self.present(exitAlert, animated: true, completion: nil)
    }
    
    @IBAction func mainButtonClicked(_ sender: UIButton) {
        
        let exitAlert = UIAlertController(title: "Ana Sayfaya Dön", message: "Ana sayfaya dönmek istediğinizden emin misiniz?", preferredStyle: .alert)
        
        //evet
        exitAlert.addAction(UIAlertAction(title: "Evet", style: .default , handler: {(_) in
                                          // Giriş sayfasına geri dön
            self.performSegue(withIdentifier: "backToMain", sender: self)
                                      }))
        //iptal
        exitAlert.addAction(UIAlertAction(title: "İptal", style: .cancel , handler: nil))
        
        self.present(exitAlert, animated: true, completion: nil)
    }
    
}




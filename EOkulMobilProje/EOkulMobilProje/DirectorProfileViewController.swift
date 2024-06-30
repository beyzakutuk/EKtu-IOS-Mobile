//
//  DirectorProfileViewController.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 30.04.2024.
//

import UIKit

class DirectorProfileViewController: UIViewController , URLSessionDelegate{

    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
           GetInformation()
       }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if let serverTrust = challenge.protectionSpace.serverTrust {
            completionHandler(.useCredential, URLCredential(trust: serverTrust))
        } else {
            completionHandler(.performDefaultHandling, nil)
        }
    }
    
    func GetInformation(){
        
        guard let token = UserDefaults.standard.string(forKey: "refreshTokenPrincipal") else {
                   print("Token yok veya geçersiz")
                   return
               }
        
        print(token)
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
                    
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            print("Kullanıcı Bilgisi: \(json["name"]!)")

                            DispatchQueue.main.async {
                                self.nameLabel.text = json["name"] as? String
                            }
                        }
                    } catch {
                        print("JSON parse hatası: \(error.localizedDescription)")
                    }
                }
                
            task.resume()

    }
    
    @IBAction func exitButtonClicked(_ sender: UIButton) {
        
        let exitAlert = UIAlertController(title: "Çıkış Yap", message: "Çıkış yapmak istediğinizden emin misiniz?", preferredStyle: .alert)
        
  
        exitAlert.addAction(UIAlertAction(title: "Evet", style: .default , handler: {(_) in
                        
            self.performSegue(withIdentifier: "backToLogin", sender: self)
            UserDefaults.standard.removeObject(forKey: "refreshTokenPrincipal")
                                      }))

        exitAlert.addAction(UIAlertAction(title: "İptal", style: .cancel , handler: nil))
        self.present(exitAlert, animated: true, completion: nil)
    }
    
    @IBAction func mainButtonClicked(_ sender: UIButton) {
        
        let exitAlert = UIAlertController(title: "Ana Sayfaya Dön", message: "Ana sayfaya dönmek istediğinizden emin misiniz?", preferredStyle: .alert)
        
        exitAlert.addAction(UIAlertAction(title: "Evet", style: .default , handler: {(_) in
                                        
            self.performSegue(withIdentifier: "backToMain", sender: self)
                                      }))
   
        exitAlert.addAction(UIAlertAction(title: "İptal", style: .cancel , handler: nil))
        
        self.present(exitAlert, animated: true, completion: nil)
        
    }
}

//
//  TeacherAdditionViewController.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 20.05.2024.
//

import UIKit

class TeacherAdditionViewController: UIViewController , URLSessionDelegate {
    
    // MARK: -VARIABLES
    
    @IBOutlet weak var tcKimlikField: UITextField!
    @IBOutlet weak var isimField: UITextField!
    @IBOutlet weak var soyisimField: UITextField!
    @IBOutlet weak var dersField: UITextField!
    @IBOutlet weak var sifreField: UITextField!
    
    @IBOutlet weak var kaydetButton: UIButton!
    
    @IBOutlet weak var onayLabel: UILabel!
    
    
    // MARK: -FUNCTIONS
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if let serverTrust = challenge.protectionSpace.serverTrust {
            completionHandler(.useCredential, URLCredential(trust: serverTrust))
        } else {
            completionHandler(.performDefaultHandling, nil)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)  // ekranda herhangi bir yere dokunduğunda klavyeyi kapat
    }
    
    private func setupViews() {
        // Text fieldlar için editingChanged eventini dinleyerek validateFields fonksiyonunu çağır
        [isimField, soyisimField, tcKimlikField, sifreField, dersField].forEach { textField in
            textField?.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        }
        
        validateFields() // Başlangıçta butonu pasif hale getirmek için
    }

    @objc private func validateFields()
    {
        // Bütün text fieldların dolu olup olmadığını kontrol et
        let isFormValid = !(isimField.text?.isEmpty ?? true) &&
                      !(soyisimField.text?.isEmpty ?? true) &&
                      !(tcKimlikField.text?.isEmpty ?? true) &&
                      !(sifreField.text?.isEmpty ?? true) &&
                      !(dersField.text?.isEmpty ?? true)
            
       kaydetButton.isEnabled = isFormValid
    }

    
    @IBAction func submitButtonClicked(_ sender: UIButton) {
        
        guard let isim = isimField.text,
                let soyisim = soyisimField.text,
                let tcKimlikNo = tcKimlikField.text,
                let sifre = sifreField.text,
                let dersAdi = dersField.text
        else {
            return
        }
        
        let urlString = "https://localhost:7134/connect/token"

        let client_id = "ClientCredentials"
        let client_secret = "secret"
        let grant_type = "client_credentials"
            

        let parameters = "client_id=\(client_id)&client_secret=\(client_secret)&grant_type=\(grant_type)"
        let postData = parameters.data(using: .utf8)
        
        var request = URLRequest(url: URL(string: urlString)!)
            request.httpMethod = "POST"
            request.httpBody = postData
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession(configuration: .default, delegate: MySessionDelegate(), delegateQueue: nil)
        let task = session.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print("Hata: \(error)")
                return
            }
                
            guard let data = data else {
                print("Boş yanıt")
                return
            }
                
            // JSON verilerini çözme
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    // Access token alınması
                    if let accessToken = json["access_token"] as? String {
                        print("Access Token: \(accessToken)")
                            
                        guard let url = URL(string: "https://localhost:7253/api/teacher/addteacher") else {    print("Invalid URL")
                            return
                        }
                            
                        let studentData: [String: Any] = [
                              "FirstName": isim,
                              "LastName": soyisim,
                              "TckNo": tcKimlikNo,
                              "Password": sifre
                            ]
                            
                        guard let jsonData = try? JSONSerialization.data(withJSONObject: studentData) else {
                            print("Error encoding teacher data")
                            return
                        }
                            
                            
                        var request = URLRequest(url: url)
                            request.httpMethod = "POST"
                            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
                            request.httpBody = jsonData
                                
                        let task = session.dataTask(with: request) { data, response, error in
                            
                            if let error = error {
                                print("Error: \(error)")
                                return
                            }
                                    
                            guard let data = data else {
                                print("No data received")
                                return
                            }
                                    
                        }

                        task.resume()
   
                    } else {
                        print("Access Token alınamadı.")
                    }
                } else {
                    print("Geçersiz JSON formatı.")
                }
            } catch {
                print("JSON çözümleme hatası: \(error)")
            }
        }

        task.resume()
        

        // Onay mesajını güncelle
        onayLabel.text = "Kaydedildi"
        onayLabel.textColor = UIColor(red: 0, green: 128/255, blue: 0, alpha: 1)
                
        // TextField'lerin içeriğini temizle
        isimField.text = ""
        soyisimField.text = ""
        tcKimlikField.text = ""
        sifreField.text = ""
        dersField.text = ""
        
        showAlert()
        
    }
    
    
    private func showAlert() {
        let alertController = UIAlertController(title: "Başarılı", message: "Öğretmen sisteme başarıyla kaydedildi.", preferredStyle: .alert)
            
        let anaSayfayaDonAction = UIAlertAction(title: "Ana Sayfaya Dön", style: .default) { _ in
            self.performSegue(withIdentifier: "toDirectorProfilePage", sender: self)
        }
            
        alertController.addAction(anaSayfayaDonAction)
            
        present(alertController, animated: true, completion: nil)
    }


}

//
//  StudentLoginViewController.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 30.04.2024.
//

import UIKit
import Alamofire

class StudentLoginViewController: UIViewController {
    
    // MARK: -VARIABLES
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: -FUNCTIONS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitViews()

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)  // ekranda herhangi bir yere dokunduğunda klavyeyi kapat
    }
    
    private func setInitViews() // her bir içerik değiştiğinde kontrol edecek.
    {
        usernameField.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(validateFields), for: .editingChanged)
    }
    
    @objc private func validateFields()
    {
        loginButton.isEnabled = usernameField.text != "" && passwordField.text != ""
    }
    
    
    @IBAction func loginButtonClk(_ sender: Any) {
        
        guard let username = usernameField.text,
              let password = passwordField.text else {
            
            return
        }
        
        guard let storyboard = self.storyboard else {
            fatalError("Storyboard bulunamadı.")
        }
        
        
        let apiUrl = URL(string: "https://localhost:7134/connect/token")!
        
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let authString = "\("ResourceOwnerStudent"):\("secret")"
        let authData = authString.data(using: .utf8)!
        let authHeader = "Basic \(authData.base64EncodedString())"
        request.setValue(authHeader, forHTTPHeaderField: "Authorization")
        
        let bodyParameters = [
            "grant_type": "password",
            "username": username,
            "password": password
        ]
        
        request.httpBody = bodyParameters
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
            .data(using: .utf8)
        
        let session = URLSession(configuration: .default, delegate: MySessionDelegate(), delegateQueue: nil)
        let task = session.dataTask(with: request) { data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Geçersiz HTTP yanıtı")
                return
            }
            
            print("Status code: \(httpResponse.statusCode)")
            
            if httpResponse.statusCode == 200
            {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                        print("Cevap JSON: \(json)")
                        if let refreshToken = json["access_token"] as? String {
                            self.saveTokens(refreshToken: refreshToken)
                        }
                    }
                }
                catch
                {
                    print("JSON dönüşüm hatası: \(error.localizedDescription)")
                }
                DispatchQueue.main.async {
                    
                    
                    guard let studentProfileVC = storyboard.instantiateViewController(withIdentifier: "StudentProfileVC") as? StudentProfileViewController else {
                        fatalError("StudentProfileViewController bulunamadı veya uygun tipte değil.")
                    }
                    
                    
                    studentProfileVC.modalPresentationStyle = .fullScreen
                    self.present(studentProfileVC, animated: true, completion: nil)
                 }
            }
            else
            {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Hata", message: "Kullanıcı adı veya şifre hatalı", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }

        }
        task.resume()
    }
    
    func saveTokens(refreshToken:String){
        UserDefaults.standard.set(refreshToken , forKey: "refreshToken")
    }
   
    @IBAction func forgotPasswordButton(_ sender: UIButton) {
        
        // "Şifreni mi unuttun?" butonuna tıklandığında eylem
        let alertController = UIAlertController(title: "Şifreni mi unuttun?", message: "E-posta adresinizi girin", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "E-posta adresi"
        }
        
        let cancelAction = UIAlertAction(title: "İptal", style: .cancel, handler: nil)
        let submitAction = UIAlertAction(title: "Gönder", style: .default) { (_) in
            if let email = alertController.textFields?.first?.text {
                // Burada e-posta adresiyle yapılacak işlemleri gerçekleştireceğiz
                print("Girilen e-posta: \(email)")
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(submitAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
}


class MySessionDelegate: NSObject, URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(.useCredential, credential)
        } else {
            completionHandler(.performDefaultHandling, nil)
        }
    }
}


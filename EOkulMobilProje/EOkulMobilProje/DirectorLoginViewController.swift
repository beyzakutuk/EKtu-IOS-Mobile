//
//  DirectorLoginViewController.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 30.04.2024.
//

import UIKit

class DirectorLoginViewController: UIViewController {
    
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setInitViews()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func setInitViews()
    {
        usernameField.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(validateFields), for: .editingChanged)
    }
    
    @objc private func validateFields()
    {
        loginButton.isEnabled = usernameField.text != "" && passwordField.text != ""
    }
    
    @IBAction func loginButtonClick(_ sender: UIButton) {
        
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
        
        let authString = "\("ResourceOwnerPrincipal"):\("secret")"
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
                    
                    
                    guard let DirectorProfileVC = storyboard.instantiateViewController(withIdentifier: "DirectorProfileVC") as? DirectorProfileViewController else {
                        fatalError("DirectorProfileViewController bulunamadı veya uygun tipte değil.")
                    }
                    
                    
                    DirectorProfileVC.modalPresentationStyle = .fullScreen
                    self.present(DirectorProfileVC, animated: true, completion: nil)
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
        UserDefaults.standard.set(refreshToken , forKey: "refreshTokenPrincipal")
    }
    
}

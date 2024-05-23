//
//  StudentLoginViewController.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 30.04.2024.
//

import UIKit


class StudentLoginViewController: UIViewController {
    
    // MARK: -VARIABLES
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var loggedInStudent: StudentModel?
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
        
        var myValue:String?
        myValue = UserDefaults.standard.string(forKey: "refreshToken")
        
        if  myValue == nil
        {
            getToken()
        }
        

        /*
        let tckn = usernameField.text ?? ""
        let sifre = passwordField.text ?? ""

        if let student = StudentDatabase.studentDatabase[tckn], student.sifre == sifre
        {
            loggedInStudent = student

            performSegue(withIdentifier: "toStudentProfilePage", sender: nil)
            print("Giriş başarılı, profil sayfasına yönlendiriliyor...")
        }
        else
        {
            // Giriş başarısız, hata mesajı göster
            let alert = UIAlertController(title: "Hata", message: "Hatalı TC kimlik numarası veya şifre!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            print("Hatalı TC kimlik numarası veya şifre!")
        }*/
    }
    
    func saveTokens(refreshToken:String){
        UserDefaults.standard.set(refreshToken , forKey: "refreshToken")
    }
    
    func getToken() {
        let apiUrl = URL(string: "https://localhost:7134/connect/token")!

        // İstek parametreleri
        guard let username = usernameField.text, let password = passwordField.text else {
            print("Kullanıcı adı veya şifre eksik")
            return
        }

    

        // İstek oluşturma
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
            if let error = error?.localizedDescription {
                print("Hata: \(error)")
                return
            }

            // Cevap alındığında
            if let httpResponse = response as? HTTPURLResponse {
                print("Status code: \(httpResponse.statusCode)")
            }

            // Cevap verisi kontrolü
            if let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Cevap JSON: \(json)")
                    if let refreshToken = json["refresh_token"] as? String {
                           print(refreshToken)
                        self.saveTokens(refreshToken: refreshToken)
                       }
                       
                } else {
                    print("Geçersiz cevap")
                }
            }
        }
        task.resume()
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
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toStudentProfilePage" {
            if let destinationVC = segue.destination as? StudentProfileViewController {
                destinationVC.student = loggedInStudent
            }
        }
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


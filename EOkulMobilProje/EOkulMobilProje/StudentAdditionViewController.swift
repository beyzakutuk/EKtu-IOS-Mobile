//
//  StudentAdditionViewController.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 19.05.2024.
//

import UIKit

class StudentAdditionViewController: UIViewController , URLSessionDelegate  {
    
    @IBOutlet weak var tcKimlikField: UITextField!
    @IBOutlet weak var isimField: UITextField!
    @IBOutlet weak var soyisimField: UITextField!
    @IBOutlet weak var sinifButton: UIButton!
    @IBOutlet weak var sifreField: UITextField!

    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var onayLabel: UILabel!
    
    var isClassSelected = false
    var selectedClassId : Int?
    
    var Classes : [Class] = []
    
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
        [isimField, soyisimField, tcKimlikField, sifreField].forEach { textField in
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
                          isClassSelected
                
        submitButton.isEnabled = isFormValid
    }
    

    @IBAction func showClassID(_ sender: UIButton) {

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
            print("request başarılı")
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

                        let urlStringGet = "https://localhost:7253/api/student/getclasslist"
                               
                        var request = URLRequest(url: URL(string: urlStringGet)!)
                        request.httpMethod = "GET"
                        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
                            
                           
                        let task = session.dataTask(with: request) { data, response, error in
                            print("request başarılı")
                            if let error = error {
                                print("Hata: \(error.localizedDescription)")
                                return
                            }

                            guard let data = data else {
                                print("Boş yanıt")
                                return
                            }
                                   
                            if let httpResponse = response as? HTTPURLResponse {
                                print(httpResponse.statusCode)
                                if httpResponse.statusCode == 200 {
                                    
                                    do {
                                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                            print("Alınan veri: \(json)")
                                            
                                                
                                            if let classDatas = json["data"] as? [[String: Any]] {
                                                for classData in classDatas {
                                                
                                                    if let classId = classData["classId"] as? Int,
                                                       let className = classData["className"] as? String {
                                                        let classs = Class(classId: classId, className: className)

                                                        Class.addClass(classs)
                                                    }
                                                    }
                                                }
                                            
                                            self.Classes = Class.getAllClasses()
                                            
                                                DispatchQueue.main.async {
                                                    let alertController = UIAlertController(title: "Sınıf Seç", message: "Bir sınıf seçiniz", preferredStyle: .actionSheet)
                                                    for classItem in self.Classes {
                                                        let action = UIAlertAction(title: classItem.className, style: .default) { _ in
                                                            
                                                            self.sinifButton.setTitle(classItem.className, for: UIControl.State.normal)
                                                            self.sinifButton.titleLabel?.textColor = .black
                                                            self.isClassSelected = true
                                                            self.validateFields()
             
                                                            self.selectedClassId = classItem.classId
                                                            print("Seçilen Sınıf: \(self.selectedClassId!)")
                                                            
                                                        }
                                                        alertController.addAction(action)
                                                    }
                                                    self.present(alertController, animated: true, completion: nil)
                                                }
                                            } else {
                                                   print("Geçersiz JSON formatı.")
                                               }
                                    } catch {
                                            print("JSON çözümleme hatası: \(error)")
                                        }
                                } else {
                                    print("Sunucudan hata kodu alındı: \(httpResponse.statusCode)")
                                    }
                            }
                        }
                               
                    // İsteği başlatma
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
        
        /*

                // UIAlertController'i göster
                if let popoverController = alertController.popoverPresentationController {
                    popoverController.sourceView = sender as? UIView
                    popoverController.sourceRect = (sender as AnyObject).bounds
                }
                
                present(alertController, animated: true, completion: nil)*/
    }
    
    @IBAction func submitButtonClicked(_ sender: UIButton) {
        
        guard let isim = isimField.text,
                let soyisim = soyisimField.text,
                let tcKimlikNo = tcKimlikField.text,
                let sifre = sifreField.text,
                let sinifNumarasi = sinifButton.title(for: .normal), sinifNumarasi != "Sınıf Seçiniz"  else {
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
                            
                        guard let url = URL(string: "https://localhost:7253/api/student/addstudent") else {    print("Invalid URL")
                            return
                        }
                            
                        let studentData: [String: Any] = [
                                "StudentName": isim,
                                "StudentLastName": soyisim,
                                "Email": "--",
                                "StudentPassword": sifre,
                                "StudentTckNo": tcKimlikNo,
                                "ClassId": self.selectedClassId!
                            ]
                            
                        guard let jsonData = try? JSONSerialization.data(withJSONObject: studentData) else {
                            print("Error encoding student data")
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
                                    
                            do {
                                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                    print("Response: \(json)")
                                }
                            } catch {
                                print("Error parsing response: \(error)")
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
        sinifButton.setTitle("Sınıf Seçiniz", for: .normal)
        isClassSelected = false
            
        validateFields() // Alanları temizledikten sonra tekrar doğrula
        
        showAlert()
        
    }
    
    private func showAlert() {
        let alertController = UIAlertController(title: "Başarılı", message: "Öğrenci sisteme başarıyla kaydedildi.", preferredStyle: .alert)
            
        let anaSayfayaDonAction = UIAlertAction(title: "Ana Sayfaya Dön", style: .default) { _ in
            self.performSegue(withIdentifier: "toDirectorProfilePage", sender: self)
        }

        alertController.addAction(anaSayfayaDonAction)
            
        present(alertController, animated: true, completion: nil)
    }
    
}


class Class: Equatable {
    let classId: Int
    let className: String
    
    init(classId: Int, className: String) {
        self.classId = classId
        self.className = className
    }
    
    // Equatable protokolü için == operatörünü implement et
    static func == (lhs: Class, rhs: Class) -> Bool {
        return lhs.classId == rhs.classId && lhs.className == rhs.className
    }
    
    // Sınıf dizisi
    static var classes: [Class] = []
    
    // Class nesnesini ekleyen, aynı olanları eklemeyen fonksiyon
    static func addClass(_ newClass: Class) {
        if !classes.contains(where: { $0 == newClass }) {
            classes.append(newClass)
        }
    }
    
    // Tüm Class nesnelerini döndüren fonksiyon
    static func getAllClasses() -> [Class] {
        return classes
    }
}

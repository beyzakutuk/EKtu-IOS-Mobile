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
        
        let alertController = UIAlertController(title: "Sınıf", message: "Bir sınıf seçiniz", preferredStyle: .actionSheet)
                
                // Açılır menü seçeneklerini oluşturun
                let option1Action = UIAlertAction(title: "1.Sınıf", style: .default) { (action) in
                    self.sinifButton.setTitle("1.Sınıf", for: UIControl.State.normal)
                    self.isClassSelected = true
                    self.validateFields()
                    print("Seçilen Seçenek: Seçenek 1")
                }
                
                let option2Action = UIAlertAction(title: "2.Sınıf", style: .default) { (action) in
                    self.sinifButton.setTitle("2.Sınıf", for: UIControl.State.normal)
                    self.isClassSelected = true
                    self.validateFields()
                    print("Seçilen Seçenek: Seçenek 2")
                }
                
                let option3Action = UIAlertAction(title: "3.Sınıf", style: .default) { (action) in
                    self.sinifButton.setTitle("3.Sınıf", for: UIControl.State.normal)
                    self.isClassSelected = true
                    self.validateFields()
                    print("Seçilen Seçenek: Seçenek 3")
                }
        let option4Action = UIAlertAction(title: "4.Sınıf", style: .default) { (action) in
            self.sinifButton.setTitle("4.Sınıf", for: UIControl.State.normal)
            self.isClassSelected = true
            self.validateFields()
            print("Seçilen Seçenek: Seçenek 4")
        }
                
                // Açılır menüye seçenekleri ekle
                alertController.addAction(option1Action)
                alertController.addAction(option2Action)
                alertController.addAction(option3Action)
        alertController.addAction(option4Action)
                
                // UIAlertController'i göster
                if let popoverController = alertController.popoverPresentationController {
                    popoverController.sourceView = sender as? UIView
                    popoverController.sourceRect = (sender as AnyObject).bounds
                }
                
                present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func submitButtonClicked(_ sender: UIButton) {
        
        guard let isim = isimField.text,
                let soyisim = soyisimField.text,
                let tcKimlikNo = tcKimlikField.text,
                let sifre = sifreField.text,
                let sinifNumarasi = sinifButton.title(for: .normal), sinifNumarasi != "Sınıf Seçiniz"  else {
            return
        }

        guard let url = URL(string: "https://localhost:7134/connect/token") else {
                    print("Geçersiz URL")
                    return
                }

        var request = URLRequest(url: url)
                request.httpMethod = "POST"
                
                // POST parametrelerini oluşturun
                let parameters: [String: String] = [
                    "client_id": "ClientCredentials",
                    "grant_type": "client_credentials",
                    "client_secret": "secret"
                ]
        
        request.httpBody = parameters
                   .map { "\($0.key)=\($0.value)" }
                   .joined(separator: "&")
                   .data(using: .utf8)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Hata: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("Boş veri")
                return
            }
            
            // Yanıtı parse edin ve kullanın
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let accessToken = json["access_token"] as? String {
                    DispatchQueue.main.async {
                        print("Access Token: \(accessToken)")
                        // Token'ı ekrana bastırabilir ya da UI'da gösterebilirsiniz
                    }
                } else {
                    let responseString = String(data: data, encoding: .utf8)
                    print("Response String: \(responseString ?? "")")
                }
            } catch {
                print("JSON parse hatası: \(error.localizedDescription)")
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
            
        let yeniOgrenciEkleAction = UIAlertAction(title: "Yeni Öğrenci Ekle", style: .default) { _ in
            // ViewController'ı yeniden yükleme
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "StudentAdditionViewController") as? StudentAdditionViewController {
                    self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
            
        alertController.addAction(anaSayfayaDonAction)
        alertController.addAction(yeniOgrenciEkleAction)
            
        present(alertController, animated: true, completion: nil)
    }
    
}

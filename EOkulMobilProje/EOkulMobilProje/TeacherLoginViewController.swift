//
//  TeacherLoginViewController.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 30.04.2024.
//

import UIKit

class TeacherLoginViewController: UIViewController {
    
    // MARK: -VARIABLES
    var user: UserModel?
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var loggedInTeacher: TeacherModel?
    
    // MARK: -FUNCTIONS

    override func viewDidLoad() {
        super.viewDidLoad()
        setInitViews()
        
        TeacherDatabase.yeniOgretmenEkle(isim: "Eda Nur", soyisim: "Korkusuz", tcKimlikNo: "23456789012", sifre: "9012")
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
    
    
    @IBAction func loginButtonClick(_ sender: UIButton) {
        let tckn = usernameField.text ?? ""
        let sifre = passwordField.text ?? ""

        if let teacher = TeacherDatabase.teacherDatabase[tckn], teacher.sifre == sifre
        {
            loggedInTeacher = teacher

            performSegue(withIdentifier: "toTeacherProfilePage", sender: nil)
            print("Giriş başarılı, profil sayfasına yönlendiriliyor...")
        }
        else
        {
            // Giriş başarısız, hata mesajı göster
            let alert = UIAlertController(title: "Hata", message: "Hatalı TC kimlik numarası veya şifre!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            print("Hatalı TC kimlik numarası veya şifre!")
        }

           
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
                       // Burada e-posta adresiyle yapılacak işlemleri gerçekleştirebilirsiniz.
                       print("Girilen e-posta: \(email)")
                   }
               }
               
               alertController.addAction(cancelAction)
               alertController.addAction(submitAction)
               
               present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTeacherProfilePage" {
            if let destinationVC = segue.destination as? TeacherProfileViewController {
                destinationVC.teacher = loggedInTeacher
            }
        }
    }
}

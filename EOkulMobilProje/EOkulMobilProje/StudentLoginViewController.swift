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
        NetworkService.shared.loginStudent(tcNo: usernameField.text!, password: passwordField.text!)
        {
            success in
            if success
            {
                self.performSegue(withIdentifier: "toStudentProfilePage", sender: self)
            }
            else
            {
                print("invalid credentials")
            }
        }
    }
    
    private func goToStudentProfilePage() //silinebilir
    {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "StudentProfileVC") as! StudentProfileViewController
        present(viewController, animated: true)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */



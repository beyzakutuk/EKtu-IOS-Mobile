//
//  ViewController.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 29.04.2024.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func StudentButtonClicked(_ sender: Any) {
        guard let storyboard = self.storyboard else {
            fatalError("Storyboard bulunamadı.")
        }
        
        
        var myRefresh:Any?
        
        myRefresh = UserDefaults.standard.string(forKey: "refreshToken")
        
        if myRefresh != nil{
            
            guard let studentProfileVC = storyboard.instantiateViewController(withIdentifier: "StudentProfileVC") as? StudentProfileViewController else {
                fatalError("StudentProfileViewController bulunamadı veya uygun tipte değil.")
            }
            
            studentProfileVC.modalPresentationStyle = .fullScreen
            self.present(studentProfileVC, animated: true, completion: nil)
            
        }
        else
        {
            guard let studentLoginVC = storyboard.instantiateViewController(withIdentifier: "StudentLoginVC") as? StudentLoginViewController else {
                fatalError("StudentLoginViewController bulunamadı veya uygun tipte değil.")
            }
            
            studentLoginVC.modalPresentationStyle = .fullScreen
            self.present(studentLoginVC, animated: true, completion: nil)
            
        }
    }
    
    @IBAction func TeacherButtonClicked(_ sender: Any) {
        
        guard let storyboard = self.storyboard else {
            fatalError("Storyboard bulunamadı.")
        }
        
        
        var myRefresh:Any?
        
        myRefresh = UserDefaults.standard.string(forKey: "refreshTokenTeacher")
        
        if myRefresh != nil{
            
            guard let TeacherProfileVC = storyboard.instantiateViewController(withIdentifier: "TeacherProfileVC") as? TeacherProfileViewController else {
                fatalError("TeacherProfileViewController bulunamadı veya uygun tipte değil.")
            }
            
            TeacherProfileVC.modalPresentationStyle = .fullScreen
            self.present(TeacherProfileVC, animated: true, completion: nil)
            
        }
        else
        {
            guard let teacherLoginVC = storyboard.instantiateViewController(withIdentifier: "TeacherLoginVC") as? TeacherLoginViewController else {
                fatalError("TeacherLoginViewController bulunamadı veya uygun tipte değil.")
            }
            
            teacherLoginVC.modalPresentationStyle = .fullScreen
            self.present(teacherLoginVC, animated: true, completion: nil)
            
        }
    }
    
    @IBAction func DirectorButtonClicked(_ sender: Any) {
        
        guard let storyboard = self.storyboard else {
            fatalError("Storyboard bulunamadı.")
        }
        
        
        var myRefresh:Any?
        
        myRefresh = UserDefaults.standard.string(forKey: "refreshTokenPrincipal")
        
        if myRefresh != nil{
            
            guard let DirectorProfileVC = storyboard.instantiateViewController(withIdentifier: "DirectorProfileVC") as? DirectorProfileViewController else {
                fatalError("DirectorProfileViewController bulunamadı veya uygun tipte değil.")
            }
            
            DirectorProfileVC.modalPresentationStyle = .fullScreen
            self.present(DirectorProfileVC, animated: true, completion: nil)
            
        }
        else
        {
            guard let DirectorLoginVC = storyboard.instantiateViewController(withIdentifier: "DirectorLoginVC") as? DirectorLoginViewController else {
                fatalError("DirectorLoginViewController bulunamadı veya uygun tipte değil.")
            }
            
            DirectorLoginVC.modalPresentationStyle = .fullScreen
            self.present(DirectorLoginVC, animated: true, completion: nil)
            
        }
    }
    
    
}


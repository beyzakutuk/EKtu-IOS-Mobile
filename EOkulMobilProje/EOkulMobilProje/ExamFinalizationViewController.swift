//
//  ExamFinalizationViewController.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 18.06.2024.
//

import UIKit

class ExamFinalizationViewController: UIViewController {
    
    @IBOutlet weak var className: UIButton!
    
    var isYilSelected : Bool = false
    var DonemID : Int = 0
    
    @IBOutlet weak var lessonName: UIButton! // seçilen dersin ismi
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func ClassSelectionButton(_ sender: Any) {//burada öğretmenin seçtiği sınıfa göre filtreleme yapılacak
        
        let alertController = UIAlertController(title: "Sınıf", message: "Bir sınıf seçiniz", preferredStyle: .actionSheet)
        
        let birAction = UIAlertAction(title: "1", style: .default) { _ in
                
            self.className.setTitle("1", for: UIControl.State.normal)
            self.className.titleLabel?.textColor = .black
            self.isYilSelected = true
            self.DonemID = 1

            print("Seçilen Yil: 1")
        }
        
        let ikiAction = UIAlertAction(title: "2", style: .default) { _ in
                
            self.className.setTitle("2", for: UIControl.State.normal)
            self.className.titleLabel?.textColor = .black
            self.isYilSelected = true
            self.DonemID = 2

            print("Seçilen Tip: 2")
        }
        
        let ucAction = UIAlertAction(title: "3", style: .default) { _ in
                
            self.className.setTitle("3", for: UIControl.State.normal)
            self.className.titleLabel?.textColor = .black
            self.isYilSelected = true
            self.DonemID = 3

            print("Seçilen Yil: 3")
        }
        
        let dortAction = UIAlertAction(title: "4", style: .default) { _ in
                
            self.className.setTitle("4", for: UIControl.State.normal)
            self.className.titleLabel?.textColor = .black
            self.isYilSelected = true
            self.DonemID = 4
            
            print("Seçilen Tip: 4")
        }
        
        alertController.addAction(birAction)
        alertController.addAction(ikiAction)
        alertController.addAction(ucAction)
        alertController.addAction(dortAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func LessonSelectionButton(_ sender: Any) {
        
        // burada öğretmenin girdiği dersler görünecek ve öğretmen hangi derse ait notlandırma yapmak istiyorsa o dersi seçecek.
    }
    
    
    @IBAction func GetStudentListButton(_ sender: Any) {
        //burada şu anda eğer sınıf ve ders seçilmişse öğrencilerin listeneceği sayfaya yönlendirilecek
    }
    
}


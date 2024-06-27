//
//  AbsenceInformationViewController.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 27.06.2024.
//

import UIKit

class AbsenceInformationViewController: UIViewController {
    

    @IBOutlet weak var className: UIButton!
    @IBOutlet weak var lessonName: UIButton!
    
    var isClassSelected: Bool = false
    var classID: Int = 0
    
    var lessonId: Int?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func classSelectionButton(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Sınıf", message: "Bir sınıf seçiniz", preferredStyle: .actionSheet)
        
        let birAction = UIAlertAction(title: "1", style: .default) { _ in
                
            self.className.setTitle("1", for: UIControl.State.normal)
            self.className.titleLabel?.textColor = .black
            self.isClassSelected = true
            self.classID = 1
            StudentFilterModel.updateClassId(newValue: 1)

            print("Seçilen Yil: 1")
        }
        
        let ikiAction = UIAlertAction(title: "2", style: .default) { _ in
                
            self.className.setTitle("2", for: UIControl.State.normal)
            self.className.titleLabel?.textColor = .black
            self.isClassSelected = true
            self.classID = 2
            StudentFilterModel.updateClassId(newValue: 2)

            print("Seçilen Tip: 2")
        }
        
        let ucAction = UIAlertAction(title: "3", style: .default) { _ in
                
            self.className.setTitle("3", for: UIControl.State.normal)
            self.className.titleLabel?.textColor = .black
            self.isClassSelected = true
            self.classID = 3
            StudentFilterModel.updateClassId(newValue: 3)

            print("Seçilen Yil: 3")
        }
        
        let dortAction = UIAlertAction(title: "4", style: .default) { _ in
                
            self.className.setTitle("4", for: UIControl.State.normal)
            self.className.titleLabel?.textColor = .black
            self.isClassSelected = true
            self.classID = 4
            StudentFilterModel.updateClassId(newValue: 4)
            
            print("Seçilen Tip: 4")
        }
        
        alertController.addAction(birAction)
        alertController.addAction(ikiAction)
        alertController.addAction(ucAction)
        alertController.addAction(dortAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func lessonSelectionButton(_ sender: Any) {
    }
    
    @IBAction func getListButton(_ sender: Any) {
    }
    
}

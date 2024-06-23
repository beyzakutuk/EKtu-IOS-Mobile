//
//  OptionalLessonsViewController.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 1.06.2024.
//

import UIKit

class OptionalLessonsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource , OptionalCourseSelectionDelegate , OptionalCourse2SelectionDelegate , OptionalCourse3SelectionDelegate{
    
    @IBOutlet weak var optional1TableView: UITableView!
    
    @IBOutlet weak var optional2TableView: UITableView!
    
    @IBOutlet weak var optional3TableView: UITableView!
    
    var optional1: [OptionalModel] = []
    var optional2: [OptionalModel] = []
    var optional3: [OptionalModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitViews()
    }
    
    func setInitViews() {
        optional1TableView.delegate = self
        optional1TableView.dataSource = self
        
        optional2TableView.delegate = self
        optional2TableView.dataSource = self
        
        optional3TableView.delegate = self
        optional3TableView.dataSource = self
        
        optional1 = OptionalModel.getAllOptional1()
        optional2 = OptionalModel.getAllOptional2()
        optional3 = OptionalModel.getAllOptional3()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == optional1TableView {
            return optional1.count
        } else if tableView == optional2TableView {
            return optional2.count
        } else if tableView == optional3TableView {
            return optional3.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == optional1TableView {
            if optional1.isEmpty {
                let emptyCell = tableView.dequeueReusableCell(withIdentifier: "emptyCell", for: indexPath)
                emptyCell.textLabel?.text = "Ders bulunmuyor"
                return emptyCell
            } else {
                // Dersler varsa normal hücreleri oluştur
                let cell = tableView.dequeueReusableCell(withIdentifier: "selectionCell", for: indexPath) as! OptionalCourseSelectionTableViewCell
                let course = optional1[indexPath.row]
                cell.lessonNameLabel.text = course.lessonName
                
                cell.delegate = self
                cell.configureCell()
                
                return cell
            }
        }
        else if tableView == optional2TableView {
            if optional2.isEmpty {
                let emptyCell = tableView.dequeueReusableCell(withIdentifier: "emptyCell", for: indexPath)
                emptyCell.textLabel?.text = "Ders bulunmuyor"
                return emptyCell
            } else {
                // Dersler varsa normal hücreleri oluştur
                let cell = tableView.dequeueReusableCell(withIdentifier: "selectionCell", for: indexPath) as! OptionalCourse2SelectionTableViewCell
                let course = optional2[indexPath.row]
                cell.lessonNameLabel.text = course.lessonName
                
                cell.delegate = self
                cell.configureCell()
                
                return cell
            }
        } else {
            if optional3.isEmpty {
                let emptyCell = tableView.dequeueReusableCell(withIdentifier: "emptyCell", for: indexPath)
                emptyCell.textLabel?.text = "Ders bulunmuyor"
                return emptyCell
            } else {
                // Dersler varsa normal hücreleri oluştur
                let cell = tableView.dequeueReusableCell(withIdentifier: "selectionCell", for: indexPath) as! OptionalCourse3SelectionTableViewCell
                let course = optional3[indexPath.row]
                cell.lessonNameLabel.text = course.lessonName
                
                cell.delegate = self
                cell.configureCell()
                
                return cell
            }
        }
    }
    
    func didTapAddButton(cell: OptionalCourseSelectionTableViewCell) {
        
        if let indexPath = optional1TableView.indexPath(for: cell) {
            let selectedCourse = self.optional1.remove(at: indexPath.row) 
            OptionalModel.Secmeli1Cikar(lessonId: selectedCourse.lessonId)
            
            SelectedLessonModel.SecilenlereEkle(lessonId: selectedCourse.lessonId, lessonName: selectedCourse.lessonName, isOptional: true , optionalNumber: 1)
            
            optional1TableView.reloadData()
        }
    }
    
    func didTapAddButton(cell: OptionalCourse2SelectionTableViewCell) {
        
        if let indexPath = optional2TableView.indexPath(for: cell) {
            let selectedCourse = self.optional2.remove(at: indexPath.row)
            OptionalModel.Secmeli2Cikar(lessonId: selectedCourse.lessonId)

            SelectedLessonModel.SecilenlereEkle(lessonId: selectedCourse.lessonId, lessonName: selectedCourse.lessonName, isOptional: true , optionalNumber: 2)
            
            optional2TableView.reloadData()
        }
    }
        
    func didTapAddButton(cell: OptionalCourse3SelectionTableViewCell) {
            
            if let indexPath = optional3TableView.indexPath(for: cell) {
                let selectedCourse = self.optional3.remove(at: indexPath.row)
                OptionalModel.Secmeli3Cikar(lessonId: selectedCourse.lessonId)
                
                SelectedLessonModel.SecilenlereEkle(lessonId: selectedCourse.lessonId, lessonName: selectedCourse.lessonName, isOptional: true , optionalNumber: 3)
                
                optional3TableView.reloadData()
            }
            
            
    }
    
}

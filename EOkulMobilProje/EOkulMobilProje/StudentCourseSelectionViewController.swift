//
//  StudentCourseSelectionViewController.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 6.05.2024.
//

import UIKit

class StudentCourseSelectionViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource , StudentSelectedCourseDelegate {

    // MARK: -VARIABLES

    @IBOutlet weak var selectedLessonsTableView: UITableView!
    
    var selectedCourses: [SelectedLessonModel] = []
    
    // MARK: -FUNCTIONS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitViews()
        
        selectedCourses = SelectedLessonModel.getAllSelected()
    }
    
    func setInitViews()
    {
        selectedLessonsTableView.delegate = self
        selectedLessonsTableView.dataSource = self
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedCourses.isEmpty ? 1 : selectedCourses.count
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if selectedCourses.isEmpty {
                let emptyCell = tableView.dequeueReusableCell(withIdentifier: "emptyCell", for: indexPath)
                emptyCell.textLabel?.text = "Seçili ders bulunmuyor."
                return emptyCell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "selectedCell", for: indexPath) as! StudentSelectedCourseTableViewCell
                let selectedCourse = selectedCourses[indexPath.row]
                cell.selectedLessonName.text = selectedCourse.lessonName
                
                cell.delegate = self
                cell.configureCell()
                
                return cell
            }
    }
    
    
    func didTapRemoveButton(cell: StudentSelectedCourseTableViewCell) {
        
        if let indexPath = selectedLessonsTableView.indexPath(for: cell) {
            let selectedCourse = self.selectedCourses.remove(at: indexPath.row) // Dersi genel listeden kaldır
            SelectedLessonModel.SecilenlerdenKaldır(lessonId: selectedCourse.lessonId)
            
            if(selectedCourse.isOptional)
            {
                if(selectedCourse.optionalNumber == 1)
                {
                    OptionalModel.Secmeli1Ekle(lessonId: selectedCourse.lessonId, lessonName: selectedCourse.lessonName, optionalNumber: selectedCourse.optionalNumber)
                }
                
                else if(selectedCourse.optionalNumber == 2)
                {
                    OptionalModel.Secmeli2Ekle(lessonId: selectedCourse.lessonId, lessonName: selectedCourse.lessonName, optionalNumber: selectedCourse.optionalNumber)
                }
                
                else
                {
                    OptionalModel.Secmeli3Ekle(lessonId: selectedCourse.lessonId, lessonName: selectedCourse.lessonName, optionalNumber: selectedCourse.optionalNumber)
                }
            }
            else
            {
                MainLessonModel.dersEkle(lessonId: selectedCourse.lessonId, lessonName: selectedCourse.lessonName)
            }

            
            selectedLessonsTableView.reloadData() // TableView'i yeniden yükle
        }
    }
    
    
}


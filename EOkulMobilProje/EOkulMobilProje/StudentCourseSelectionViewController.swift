//
//  StudentCourseSelectionViewController.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 6.05.2024.
//

import UIKit

class StudentCourseSelectionViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource {
    
    
    // MARK: -VARIABLES
    
    @IBOutlet weak var lessonsTableView: UITableView!
    @IBOutlet weak var selectedLessonsTableView: UITableView!
    
    var lessons : [Courses] = []
    var selectedCourses: [Courses] = [] // Seçilen derslerinizi içerecek dizi
    
    // MARK: -FUNCTIONS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitViews()
        
        lessons = CourseManager.fetchLessonsFromAPI()
        lessonsTableView.reloadData()
    }
    
    func setInitViews()
    {
        lessonsTableView.delegate = self
        lessonsTableView.dataSource = self
        
        selectedLessonsTableView.delegate = self
        selectedLessonsTableView.dataSource = self
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == lessonsTableView {
            return lessons.isEmpty ? 1 : lessons.count
        } else {
            return selectedCourses.isEmpty ? 1 : selectedCourses.count
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == lessonsTableView {
            if lessons.isEmpty {
                let emptyCell = tableView.dequeueReusableCell(withIdentifier: "emptyCell", for: indexPath)
                emptyCell.textLabel?.text = "Ders bulunmuyor"
                return emptyCell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "selectionCell", for: indexPath) as! StudentCourseSelectionTableViewCell
                let course = lessons[indexPath.row]
                cell.lessonNameLabel.text = course.courseName
                
                // "selectionCell" hücresinde + butonuna tıklandığında yapılacak işlem
                cell.addCourseAction = { [weak self] in
                    guard let self = self else { return }
                    let selectedCourse = self.lessons.remove(at: indexPath.row) // Dersi seçilenler listesinden kaldır
                    self.selectedCourses.append(selectedCourse) // Dersi seçilenler listesine ekle
                    self.lessonsTableView.reloadData() // İlk tableView'i yeniden yükle
                    self.selectedLessonsTableView.reloadData() // İkinci tableView'i yeniden yükle
                }
                return cell
            }
        } else {
            if selectedCourses.isEmpty {
                let emptyCell = tableView.dequeueReusableCell(withIdentifier: "emptyCell", for: indexPath)
                emptyCell.textLabel?.text = "Seçili ders bulunmuyor."
                return emptyCell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "selectedCell", for: indexPath) as! StudentSelectedCourseTableViewCell
                let selectedCourse = selectedCourses[indexPath.row]
                cell.selectedLessonName.text = selectedCourse.courseName
                
                // "selectedCell" hücresinde - butonuna tıklandığında yapılacak işlem
                cell.removeCourseAction = { [weak self] in
                    guard let self = self else { return }
                    let removedCourse = self.selectedCourses.remove(at: indexPath.row) // Dersi seçilenler listesinden kaldır
                    self.lessons.append(removedCourse) // Dersi genel dersler listesine geri ekle
                    self.lessonsTableView.reloadData() // İlk tableView'i yeniden yükle
                    self.selectedLessonsTableView.reloadData() // İkinci tableView'i yeniden yükle
                }
                return cell
            }
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

}

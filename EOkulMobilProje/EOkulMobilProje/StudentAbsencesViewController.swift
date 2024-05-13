//
//  StudentAbsencesViewController.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 13.05.2024.
//

import UIKit

class StudentAbsencesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var totalAbsencesLabel: UILabel!
    var absencesManager = AbsencesManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Örnek veri eklemek için:
        absencesManager.addAbsence(courseName: "Matematik", absenceDate: "2024-05-10")
        absencesManager.addAbsence(courseName: "Fizik", absenceDate: "2024-05-15")
                
        // TableView'in yeniden yüklenmesi sağlanır
        tableView.reloadData()
        
        // Toplam devamsızlık sayısını güncelle
        updateTotalAbsencesCount()
    }
    
    // TableView'deki satır sayısını belirler
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return absencesManager.getAllAbsences().count
    }
    
    
    // TableView'deki hücreleri oluşturur ve doldurur
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AbsenceCell") as! AbsencesTableViewCell
            
        // AbsencesModel örneği alınır
        let absence = absencesManager.getAllAbsences()[indexPath.row]
            
        // Hücrenin courseName label'ına courseName değeri atanır
        cell.courseName.text = absence.courseName
            
        // Hücrenin date label'ına absenceDate değeri atanır
        cell.date.text = absence.absenceDate
            
        return cell
    }
    
    func updateTotalAbsencesCount() {
        if let totalAbsencesLabel = totalAbsencesLabel {
            let totalAbsencesCount = absencesManager.totalAbsencesCount()
            totalAbsencesLabel.text = " Toplam devamsızlık sayısı: \(totalAbsencesCount)"
        }
     }

    

}

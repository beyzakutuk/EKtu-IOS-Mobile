//
//  StudentTranscriptViewController.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 7.05.2024.
//

import UIKit

class StudentTranscriptViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {


    var groupedData: [(year: Int, entries: [TranscriptEntry])] = []

    
    @IBOutlet weak var tableView: UITableView!
    
    let transcriptData: [TranscriptEntry] = [
        TranscriptEntry(year: 1, courseName: "Mathematics", grade: "A"),
        TranscriptEntry(year: 1, courseName: "Physics", grade: "B+"),
        TranscriptEntry(year: 2, courseName: "Chemistry", grade: "A-"),
        TranscriptEntry(year: 2, courseName: "Biology", grade: "B")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Verileri sınıf yılına göre gruplayın ve sıralayın
               let grouped = Dictionary(grouping: transcriptData, by: { $0.year })
               groupedData = grouped.map { (year: $0.key, entries: $0.value) }
               groupedData.sort { $0.year < $1.year }

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return groupedData.count
       }

       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return groupedData[section].entries.count
       }

       func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
           return "\(groupedData[section].year). Sınıf"
       }
    
    // Özelleştirilmiş başlık görünümü
       func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
           let headerView = UIView()
           headerView.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0) // Daha açık gri renk

           let label = UILabel()
           label.translatesAutoresizingMaskIntoConstraints = false
           label.text = "\(groupedData[section].year). Sınıf"
           label.font = UIFont.boldSystemFont(ofSize: 18) // Başlık yazı tipi boyutu ve stilini ayarlayın
           label.textColor = .white
           label.textAlignment = .center // Metni ortalayın

           headerView.addSubview(label)

           // Auto Layout kullanarak etiketi merkezleyin
           NSLayoutConstraint.activate([
               label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
               label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
               label.topAnchor.constraint(equalTo: headerView.topAnchor),
               label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor)
           ])

           return headerView
       }
    
    
    // Başlık yüksekliğini ayarlayın
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           if groupedData.isEmpty {
                       let emptyCell = tableView.dequeueReusableCell(withIdentifier: "emptyCell", for: indexPath)
                       emptyCell.textLabel?.text = "Ders bulunmuyor"
                       return emptyCell
                   } else {
                       let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TranscriptTableViewCell
                       let entry = groupedData[indexPath.section].entries[indexPath.row]
                       cell.lessonName.text = entry.courseName
                       cell.grade.text = entry.grade
                       return cell
                   }
       }


}


struct TranscriptEntry {
    let year: Int
    let courseName: String
    let grade: String
}



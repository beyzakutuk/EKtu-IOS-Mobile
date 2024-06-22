//
//  StudentExamListViewController.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 22.06.2024.
//

import UIKit

class StudentExamListViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
   
    
    @IBOutlet weak var StudentListTableView: UITableView!
    
    var students : [String] = [] //şimdilik string
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! StudentExamListTableViewCell
        
        let student = students[indexPath.row]
        //burada cell içerisine students dizisinden dönen öğrencilerin adı soyadı arasınav ve final notlarını yazdıracağız
        
        return cell
    }
    
    


}

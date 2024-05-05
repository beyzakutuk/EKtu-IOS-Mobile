//
//  StudentExamResultsViewController.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 4.05.2024.
//

import UIKit

class StudentExamResultsViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    // MARK: -VARIABLES
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var DonemSecimButton: UIButton!
    @IBOutlet weak var Donem: UILabel!
    
    let Donemler = ["Güz Dönemi", "Bahar Dönemi"]
    var seciliDonemIndisi: Int?
    
    var courses: [StudentsCourses] = []
    // Örnek dersler ekleyelim
    
    // MARK: -FUNCTIONS

    override func viewDidLoad() {
        super.viewDidLoad()
        // Butona bir dokunma olayı ekleyin
        DonemSecimButton.addTarget(self, action: #selector(showDropdownMenu), for: .touchUpInside)

        setInitViews()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CourseCell")

        tableView.reloadData()
    }
    
    func setInitViews()
    {
        tableView.dataSource = self
        tableView.delegate = self
        
        courses.append(StudentsCourses(courseName: "Matematik", midtermResult: 85, finalResult: 90))
        courses.append(StudentsCourses(courseName: "Fizik", midtermResult: 90, finalResult: 85))
    }
    
    // Dropdown menüyü gösteren eylem fonksiyonu
    @objc func showDropdownMenu() {
        let alertController = UIAlertController(title: "Dönem Seçiniz", message: nil, preferredStyle: .actionSheet)
        
        // Güz dönemi seçeneği
        let fallAction = UIAlertAction(title: "Güz Dönemi", style: .default) { _ in
            // Güz dönemi seçildiğinde yapılacak işlemler
            print("Güz Dönemi Seçildi")
            self.Donem.text = "Güz"
        }
        alertController.addAction(fallAction)
        
        // Bahar dönemi seçeneği
        let springAction = UIAlertAction(title: "Bahar Dönemi", style: .default) { _ in
            // Bahar dönemi seçildiğinde yapılacak işlemler
            print("Bahar Dönemi Seçildi")
            self.Donem.text = "Bahar"
        }
        alertController.addAction(springAction)
        
        // İptal seçeneği
        let cancelAction = UIAlertAction(title: "İptal", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // Butonların fontunu ve rengini güncelleme
        alertController.view.tintColor = UIColor.blue
        
        // UIAlertController'ı görüntüleme
        present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! StudentsCoursesTableViewCell
        let course = courses[indexPath.row] // Doğru dersi almak için indexPath.row kullanın
            
            cell.titleLabel.text = course.courseName
            cell.midtermResult.text = "Ara Sınav: \(course.midtermResult)" // course değişkenine erişin
            cell.finalResult.text = "Final: \(course.finalResult)" // course değişkenine erişin
            
            return cell
    }
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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



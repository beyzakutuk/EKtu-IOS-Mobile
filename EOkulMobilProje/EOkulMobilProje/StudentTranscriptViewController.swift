//
//  StudentTranscriptViewController.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 7.05.2024.
//

import UIKit

class StudentTranscriptViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource{

    
    
    var dynamicHeight: CGFloat = 100
    let labelBottomPadding: CGFloat = 5
    
    @IBOutlet weak var collectionView: UICollectionView!

    lazy var courses = CourseManager.fetchLessonsFromAPI()
    
    var organizedCourses: [String: [String: [Courses]]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitView()
    
        self.organizedCourses = CourseManager.groupCoursesByYearAndType(courses: courses)
    }
    
    func setInitView()
    {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return organizedCourses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
           let yearCourses = Array(organizedCourses.values)[section]
           return yearCourses.values.reduce(0, { $0 + $1.count })
    }
       

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! TranscriptCollectionViewCell
        
        let sections = Array(organizedCourses.keys)
        let currentSection = sections[indexPath.section]
        let yearCourses = organizedCourses[currentSection]!
        
        var totalIndex = 0
        for (type, courses) in yearCourses {
            let numCoursesInSection = courses.count
            if indexPath.row < totalIndex + numCoursesInSection {
                if indexPath.row == totalIndex {
                    // Eğer hücre, derslerin başlığı ise
                    cell.titleLabel.text = "'\(currentSection)' yılı '\(type)' dönemi Dersleri"
                    // Başlık hücresinin yüksekliğini hesapla
                    let titleHeight = cell.titleLabel.sizeThatFits(CGSize(width: collectionView.frame.width - 40, height: CGFloat.greatestFiniteMagnitude)).height
                    cell.titleLabel.frame.size.height = titleHeight
                    
                    // Fazladan boşluk ekleyerek derslerin başlık label'ının altında daha aşağıda görünmesini sağla
                    // Eğer birden fazla ders varsa her ders için label ekleyerek göster
                    var yOffset = titleHeight + 20 // Başlık ve biraz daha fazla boşluk için
                    for course in courses {
                        let courseLabel = UILabel()
                        courseLabel.text = course.courseName
                        courseLabel.numberOfLines = 0 // Birden fazla satırı destekle
                        courseLabel.frame = CGRect(x: 20, y: yOffset, width: collectionView.frame.width - 40, height: 30)
                        cell.contentView.addSubview(courseLabel)
                        yOffset += 30 + 5 // Dersler arası boşluk, ders label'larının sabit yüksekliği
                    }

                    // Hücrenin boyutunu ayarla
                    cell.frame.size.height = yOffset + 10 // Toplam yükseklik ve aralıklar için boşluk

                } else {
                    // Başlık hücresi değilse, başlık alanını boş bırak
                    cell.titleLabel.text = ""
                    // Eğer birden fazla ders varsa, içerik alanını temizle
                    cell.contentView.subviews.forEach { $0.removeFromSuperview() }
                    
                    // Hücrenin boyutunu sıfırla
                    cell.frame.size.height = 100 // Başlık hücresinin varsayılan yüksekliği
                }


                break
            }
            totalIndex += numCoursesInSection
        }
        
        return cell
    }
}

extension StudentTranscriptViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sections = Array(organizedCourses.keys)
        let currentSection = sections[indexPath.section]
        let yearCourses = organizedCourses[currentSection]!

        // Belirli bir section ve indexPath için hücre yüksekliğini hesapla
        var totalIndex = 0
        for (_, courses) in yearCourses {
            let numCoursesInSection = courses.count
            totalIndex += numCoursesInSection
        }

        // Tek bir ders varsa, hücre yüksekliğini 30 olarak ayarla
        if totalIndex == 1 {
            return CGSize(width: collectionView.frame.width, height: 30)
        } else {
            // Birden fazla ders varsa, hücre yüksekliğini diğer kriterlere göre hesapla
            // Örneğin, başlık ve birden fazla ders olduğunda
            // Hücre yüksekliğini döndür
            let labelBottomPadding: CGFloat = 5 // Her ders label'ının altına eklenecek boşluk miktarı
            return CGSize(width: collectionView.frame.width, height: dynamicHeight + labelBottomPadding)
        }
    }

}

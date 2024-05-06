//
//  Courses.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 6.05.2024.
//

import Foundation

struct Courses
{
    var courseId: String
    var courseName : String
    var isMainCourse: Bool = true // Ana ders mi?
}

class CourseManager
{
    static func fetchLessonsFromAPI() -> [Courses] {
            // API'den derslerin verilerini alın
            // Örneğin, API çağrısını gerçekleştirin ve gelen veriyi işleyin
        
        let apiResponse = [
            ["courseId": "1", "courseName": "Matematik"],
            ["courseId": "2", "courseName": "Fizik"],
            ["courseId": "3", "courseName": "Kimya"]
        ]

        // Verileri Lesson struct'ına dönüştürüp bir diziye ekleyin
        var lessons: [Courses] = []
        for lessonData in apiResponse {
            if let id = lessonData["courseId"], let name = lessonData["courseName"] {
                let lesson = Courses(courseId: id, courseName: name)
                lessons.append(lesson)
            }
        }
        
        lessons.append(Courses(courseId: "4", courseName: "Türk Dili" , isMainCourse: false))
        return lessons
    }
    
}

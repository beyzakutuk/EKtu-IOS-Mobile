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
    var year : String
    var type : String
}

class CourseManager
{
    static func fetchLessonsFromAPI() -> [Courses] {
            // API'den derslerin verilerini alın
            // Örneğin, API çağrısını gerçekleştirin ve gelen veriyi işleyin
        
        let apiResponse = [
            ["courseId": "1", "courseName": "Matematik" ,"year" : "2021-2022" , "type" : "Güz"],
            ["courseId": "2", "courseName": "Fizik" ,"year" : "2021-2022" , "type" : "Bahar"],
            ["courseId": "3", "courseName": "Kimya" ,"year" : "2022-2023" , "type" : "Güz"]
        ]

        // Verileri Lesson struct'ına dönüştürüp bir diziye ekleyin
        var lessons: [Courses] = []
        for lessonData in apiResponse {
            if let id = lessonData["courseId"], let name = lessonData["courseName"] ,let year = lessonData["year"] , let type = lessonData["type"] {
                let lesson = Courses(courseId: id, courseName: name , year: year , type: type )
                lessons.append(lesson)
            }
        }
        
        lessons.append(Courses(courseId: "4", courseName: "Türk Dili" , isMainCourse: false , year: "2022-2023" , type: "Bahar"))
        lessons.append(Courses(courseId: "5", courseName: "İnkılap" , isMainCourse: false , year: "2022-2023" , type: "Bahar"))
        return lessons
    }
    
    
    static func groupCoursesByYearAndType(courses: [Courses]) -> [String: [String: [Courses]]] {
            var organizedCourses: [String: [String: [Courses]]] = [:]

            for course in courses {
                let year = course.year
                let type = course.type
                
                if organizedCourses[year] == nil {
                    organizedCourses[year] = [:]
                }
                if organizedCourses[year]?[type] == nil {
                    organizedCourses[year]?[type] = []
                }
                organizedCourses[year]?[type]?.append(course)
            }

            return organizedCourses
        }
}

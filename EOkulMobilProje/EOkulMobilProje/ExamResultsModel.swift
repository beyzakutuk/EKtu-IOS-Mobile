//
//  ExamResults.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 20.05.2024.
//

import Foundation

class ExamResultsModel
{
    var course : CourseModel
    var courseId: String
    var courseName: String
    var midtermResult: Int
    var finalResult: Int
    var letterGrade: String
    
    init(courseId: String, courseName: String) {
        self.courseId = courseId
        self.courseName = courseName
        self.midtermResult = 0
        self.finalResult = 0
        self.letterGrade = ""
        
        if let foundCourse = CourseDatabase.courseDatabase[courseId] {
                self.course = foundCourse
            }
        else {
                // Eğer courseDatabase'de courseId'ye sahip bir CourseModel bulunamazsa, varsayılan bir CourseModel oluşturun
                self.course = CourseModel(courseId: courseId, courseName: courseName, isMainCourse: true, year: "", type: "")
            }
    }
}

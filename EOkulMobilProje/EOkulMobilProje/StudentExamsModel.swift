//
//  StudentExamsModel.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 26.06.2024.
//

import Foundation

class StudentExamsModel
{
    var lessonName : String
    var midterm :Int
    var final: Int
    
    static var lessons  : [StudentExamsModel] = []
    
    init(lessonName: String, midterm: Int, final: Int) {
        self.lessonName = lessonName
        self.midterm = midterm
        self.final = final
    }
    
    static func addLessons(lessonName: String, midterm: Int, final: Int) {
        if let existingLessonIndex = lessons.firstIndex(where: { $0.lessonName == lessonName }) {
            print("Lesson '\(lessonName)' already exists.")
            return
        }
        
        let lesson = StudentExamsModel(lessonName: lessonName, midterm: midterm, final: final)
        lessons.append(lesson)
    }
    
    static func getAllLessons()->[StudentExamsModel]
    {
        return lessons
    }
    
    static func removeAllLessons() {
            lessons.removeAll()
        }
    
}

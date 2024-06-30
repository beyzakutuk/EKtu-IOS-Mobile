//
//  LessonModel.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 29.06.2024.
//

import Foundation

class LessonModel
{
    static var id : Int = 0
    var lessonId: Int
    var lessonName: String

    init(lessonId: Int, lessonName: String) {
        self.lessonId = lessonId
        self.lessonName = lessonName
    }
     static var allLessons : [LessonModel] = []
         
    static func addLesson(_ lesson: LessonModel) {
        allLessons.append(lesson)
    }
         
    static func removeAllLesson() {
        allLessons.removeAll()
    }
         
    static func getAllLesson() -> [LessonModel] {
        return allLessons
    }
     
}

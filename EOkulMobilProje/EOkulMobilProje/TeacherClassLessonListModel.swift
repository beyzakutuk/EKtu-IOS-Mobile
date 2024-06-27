//
//  TeacherClassLessonListModel.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 25.06.2024.
//

import Foundation

class TeacherClassLessonListModel
{
    var lessonId: Int 
    var lessonName: String
    
    init(lessonId: Int, lessonName: String) {
        self.lessonId = lessonId
        self.lessonName = lessonName
    }
    
    static var teacherslesson : [TeacherClassLessonListModel] = []
    
    static func getAllTeachersLessons() -> [TeacherClassLessonListModel] {
        return teacherslesson
    }

    static func dersEkle(lessonId: Int, lessonName: String) {
        if !teacherslesson.contains(where: { $0.lessonId == lessonId }) {
            let lesson = TeacherClassLessonListModel(lessonId: lessonId, lessonName: lessonName)
            teacherslesson.append(lesson)
        }
    }
    
    static func tumDersleriSil() {
        teacherslesson.removeAll()
    }
    
}

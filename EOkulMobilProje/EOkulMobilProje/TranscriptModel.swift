//
//  TranscriptModel.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 30.06.2024.
//

import Foundation

class TranscriptModel
{
    var lessonName : String
    var letterGrade: String
    
    static var lessons  : [TranscriptModel] = []
    
    init(lessonName: String, letterGrade: String) {
        self.lessonName = lessonName
        self.letterGrade = letterGrade
    }
    
    static func addLessons(lessonName: String,letterGrade: String) {
        if let existingLessonIndex = lessons.firstIndex(where: { $0.lessonName == lessonName }) {
            print("Lesson '\(lessonName)' already exists.")
            return
        }
        
        let lesson = TranscriptModel(lessonName: lessonName, letterGrade: letterGrade)
        lessons.append(lesson)
    }
    
    static func getAllLessons()->[TranscriptModel]
    {
        return lessons
    }
    
    static func removeAllLessons() {
            lessons.removeAll()
        }
    
}

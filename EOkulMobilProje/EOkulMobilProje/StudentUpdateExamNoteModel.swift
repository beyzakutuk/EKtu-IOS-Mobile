//
//  StudentUpdateExamNoteModel.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 26.06.2024.
//

import Foundation

class StudentUpdateExamNoteModel
{
    var studentId : Int
    var lessonId : Int
    var midterm : Int
    var final : Int
    
    init(studentId: Int, lessonId: Int, midterm: Int, final: Int) {
        self.studentId = studentId
        self.lessonId = lessonId
        self.midterm = midterm
        self.final = final
    }
    
    static var updates : [StudentUpdateExamNoteModel] = []
    
    static func updateNote(studentId: Int, lessonId: Int , midtermNote : Int , finalNote : Int) {
        let ogrenci = StudentUpdateExamNoteModel(studentId: studentId, lessonId: lessonId, midterm: midtermNote, final: finalNote)
        updates.append(ogrenci)
    }
    
    static func getAllStudents() -> [StudentUpdateExamNoteModel] {
        return updates
    }
}

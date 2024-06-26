//
//  ExamNoteStudentListModel.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 25.06.2024.
//

import Foundation

class ExamNoteStudentList
{
    static var id : Int?
    var studentId : Int
    var studentName : String
    var midtermNote : Int
    var finalNote : Int
    
    static var isUpdate : Bool = false
    
    static func setIsUpdate(newValue: Bool)
    {
        isUpdate = newValue
    }
    
    static func getIsUpdated()->Bool
    {
        return isUpdate
    }
    
    init(studentId: Int, studentName: String, midtermNote: Int, finalNote: Int) {
        self.studentId = studentId
        self.studentName = studentName
        self.midtermNote = midtermNote
        self.finalNote = finalNote
    }
    
    // Statik değişkeni güncelleyen bir yöntem
    static func updateId(newValue: Int) {
        id = newValue
    }
    
    static func getId()-> Int
    {
        return id!
    }
    
    static var studentList : [ExamNoteStudentList] = []

    static func ogrenci(studentId: Int, studentName: String , midtermNote : Int , finalNote : Int) {
        let ogrenci = ExamNoteStudentList(studentId: studentId, studentName: studentName , midtermNote : midtermNote , finalNote : finalNote)
        studentList.append(ogrenci)
    }
    
    static func getAllStudents() -> [ExamNoteStudentList] {
        return studentList
    }
    
    func setMidterm(midtermNote : Int)
    {
        self.midtermNote = midtermNote
    }
    
    func setFinal(final : Int)
    {
        self.finalNote = final
    }
    
    // Öğrenci bulma metodunu ekleyelim
    static func findStudentById(studentId: Int) -> ExamNoteStudentList? {
        return studentList.first { $0.studentId == studentId }
    }
    
}

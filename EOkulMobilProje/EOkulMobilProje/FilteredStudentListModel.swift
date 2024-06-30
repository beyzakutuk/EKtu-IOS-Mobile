//
//  FilteredStudentListModel.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 27.06.2024.
//

import Foundation

class FilteredStudentListModel
{
    static var id : Int?
    var studentId : Int
    var studentName : String
    
    static var isUpdate : Bool = false
    
    init(studentId: Int, studentName: String) {
        self.studentId = studentId
        self.studentName = studentName
    }
    
    static var studentList : [FilteredStudentListModel] = []
    
    
    static func setIsUpdate(newValue: Bool)
    {
        isUpdate = newValue
    }
    
    static func getIsUpdated()->Bool
    {
        return isUpdate
    }
    
    static func updateId(newValue: Int) {
        id = newValue
    }
    
    static func getId()-> Int
    {
        return id!
    }
    
    static func addStudent(studentId: Int, studentName: String) {
        // Eğer öğrenci zaten listede varsa ekleme yapma
        guard findStudentById(studentId: studentId) == nil else {
            print("Bu öğrenci zaten listede var.")
            return
        }
            
        let newStudent = FilteredStudentListModel(studentId: studentId, studentName: studentName)
        studentList.append(newStudent)
        print("Öğrenci başarıyla eklendi.")
    }
    
    static func getAllStudents() -> [FilteredStudentListModel] {
        return studentList
    }
    
    // Öğrenci bulma metodunu ekleyelim
    static func findStudentById(studentId: Int) -> FilteredStudentListModel? {
        return studentList.first { $0.studentId == studentId }
    }
    
}

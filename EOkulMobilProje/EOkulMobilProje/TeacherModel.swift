//
//  TeacherModel.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 29.06.2024.
//

import Foundation


class TeacherModel
{
    static var id : Int = 0
        var teacherId: Int
        var teacherName: String

        init(teacherId: Int, teacherName: String) {
            self.teacherId = teacherId
            self.teacherName = teacherName
        }
        
    static var allTeachers : [TeacherModel] = []
        
        static func addTeacher(_ teacher: TeacherModel) {
            allTeachers.append(teacher)
        }
        
        static func removeAllTeachers() {
            allTeachers.removeAll()
        }
        
        static func getAllTeachers() -> [TeacherModel] {
            return allTeachers
        }
    
}

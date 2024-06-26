//
//  StudentFilterModel.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 25.06.2024.
//

import Foundation

class StudentFilterModel
{
    static var classId : Int?
    static var lessonId : Int?
    
    // Statik değişkeni güncelleyen bir yöntem
    static func updateClassId(newValue: Int) {
        classId = newValue
    }
    
    static func updateLessonId(newValue: Int) {
        lessonId = newValue
    }

    // Statik değişkeni okuyan bir yöntem
    static func printClassID() {
        print(classId!)
    }
    
    static func printLessonID() {
        print(lessonId!)
    }
    
    static func getClassId()-> Int
    {
        return classId!
    }
    
    static func getLessonId()-> Int
    {
        return lessonId!
    }
}

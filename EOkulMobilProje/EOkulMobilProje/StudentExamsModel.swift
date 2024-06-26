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
    var term : Int
    
    static var lessons  : [StudentExamsModel] = []
    
    init(lessonName: String, midterm: Int, final: Int, term: Int) {
        self.lessonName = lessonName
        self.midterm = midterm
        self.final = final
        self.term = term
    }
    
    static func addLessons(lessonName : String , midterm:Int , final: Int , term : Int)
    {
        let lesson = StudentExamsModel(lessonName: lessonName, midterm: midterm, final: final, term: term)
        lessons.append(lesson)
    }
    
    static func getAllLessons()->[StudentExamsModel]
    {
        return lessons
    }
    
    static func getLessons(forTerm term: Int) -> [StudentExamsModel] {
            return lessons.filter { $0.term == term }
        }
    
}

//
//  SelectedLessonModel.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 23.06.2024.
//

import Foundation

class SelectedLessonModel
{
    var lessonName : String
    var lessonId : Int
    var isOptional : Bool
    
    static var selectedCourse : [SelectedLessonModel] = []
    
    init(lessonId: Int, lessonName: String , isOptional: Bool) {
        self.lessonId = lessonId
        self.lessonName = lessonName
        self.isOptional = isOptional

    }
    
    static func getAllSelected() -> [SelectedLessonModel] {
        return selectedCourse
    }
    
    // Yeni ders ekleme fonksiyonu
    static func SecilenlereEkle(lessonId: Int, lessonName: String , isOptional: Bool) {
        let lesson = SelectedLessonModel(lessonId: lessonId, lessonName: lessonName , isOptional: isOptional)
        selectedCourse.append(lesson)
    }
    
    static func SecilenlerdenKaldır(lessonId: Int){
        if let index = selectedCourse.firstIndex(where: { $0.lessonId == lessonId }) {
            selectedCourse.remove(at: index)
        }
    }
}

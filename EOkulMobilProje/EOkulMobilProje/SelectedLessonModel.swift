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
    var optionalNumber : Int
    
    static var selectedCourse : [SelectedLessonModel] = []
    
    init(lessonId: Int, lessonName: String , isOptional: Bool , optionalNumber: Int) {
        self.lessonId = lessonId
        self.lessonName = lessonName
        self.isOptional = isOptional
        self.optionalNumber = optionalNumber
    }
    
    static func getAllSelected() -> [SelectedLessonModel] {
        return selectedCourse
    }
    
    static func SecilenlereEkle(lessonId: Int, lessonName: String, isOptional: Bool, optionalNumber: Int) {
        // Mevcut seçilen dersleri kontrol et
        if !selectedCourse.contains(where: { $0.lessonId == lessonId }) {
            // Ders listede yoksa ekle
            let lesson = SelectedLessonModel(lessonId: lessonId, lessonName: lessonName, isOptional: isOptional, optionalNumber: optionalNumber)
            selectedCourse.append(lesson)
        } else {
            print("Ders zaten seçili.")
            // İsterseniz burada bir hata işlemesi veya geri bildirim yapabilirsiniz.
        }
    }

    
    static func SecilenlerdenKaldır(lessonId: Int){
        if let index = selectedCourse.firstIndex(where: { $0.lessonId == lessonId }) {
            selectedCourse.remove(at: index)
        }
    }
}

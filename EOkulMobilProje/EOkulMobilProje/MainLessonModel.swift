//
//  MainLessonModel.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 24.06.2024.
//

import Foundation

class MainLessonModel
{
    var lessonId : Int
    var lessonName : String
    
    
    init(lessonId: Int, lessonName: String) {
        self.lessonId = lessonId
        self.lessonName = lessonName
    }
    static var mainLessons : [MainLessonModel] = []
    
    static func getAllMainLessons() -> [MainLessonModel] {
        return mainLessons
    }
    
    static func dersEkle(lessonId: Int, lessonName: String) {
        // Mevcut dersleri kontrol et
        if !mainLessons.contains(where: { $0.lessonId == lessonId }) {
            // Ders listede yoksa ekle
            let lesson = MainLessonModel(lessonId: lessonId, lessonName: lessonName)
            mainLessons.append(lesson)
        } else {
            print("Ders zaten listeye ekli.")
        }
    }
    
    static func anaderslerdenKaldır(lessonId: Int){
        if let index = mainLessons.firstIndex(where: { $0.lessonId == lessonId }) {
            mainLessons.remove(at: index)
        }
    }
}

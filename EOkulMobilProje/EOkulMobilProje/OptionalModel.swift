//
//  OptionalModel.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 1.06.2024.
//

import Foundation

class OptionalModel
{
    var lessonId : Int
    var lessonName : String
    
    static var optional1: [OptionalModel] = []
    static var optional2: [OptionalModel] = []
    static var optional3: [OptionalModel] = []
    
    // Tüm devamsızlıkları almak için
    static func getAllOptional2() -> [OptionalModel] {
        return optional2
    }
    // Tüm devamsızlıkları almak için
    static func getAllOptional1() -> [OptionalModel] {
        return optional1
    }
    // Tüm devamsızlıkları almak için
    static func getAllOptional3() -> [OptionalModel] {
        return optional3
    }
    
    init(lessonId: Int, lessonName: String) {
        self.lessonId = lessonId
        self.lessonName = lessonName

    }
    
    // Yeni ders ekleme fonksiyonu
    static func Secmeli1Ekle(lessonId: Int, lessonName: String) {
        let lesson = OptionalModel(lessonId: lessonId, lessonName: lessonName)
        optional1.append(lesson)
    }
    
    // Yeni ders ekleme fonksiyonu
    static func Secmeli2Ekle(lessonId: Int, lessonName: String) {
        let lesson = OptionalModel(lessonId: lessonId, lessonName: lessonName)
        optional2.append(lesson)
    }
    // Yeni ders ekleme fonksiyonu
    static func Secmeli3Ekle(lessonId: Int, lessonName: String) {
        let lesson = OptionalModel(lessonId: lessonId, lessonName: lessonName)
        optional3.append(lesson)
    }
    
}

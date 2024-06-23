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
    var optionalNumber : Int
    
    static var optional1: [OptionalModel] = []
    static var optional2: [OptionalModel] = []
    static var optional3: [OptionalModel] = []
    
    static func getAllOptional2() -> [OptionalModel] {
        return optional2
    }
    
    static func getAllOptional1() -> [OptionalModel] {
        return optional1
    }

    static func getAllOptional3() -> [OptionalModel] {
        return optional3
    }
    
    init(lessonId: Int, lessonName: String , optionalNumber: Int) {
        self.lessonId = lessonId
        self.lessonName = lessonName
        self.optionalNumber = optionalNumber

    }
    
    // Yeni ders ekleme fonksiyonu
    static func Secmeli1Ekle(lessonId: Int, lessonName: String, optionalNumber: Int) {
        let lesson = OptionalModel(lessonId: lessonId, lessonName: lessonName , optionalNumber: optionalNumber)
        optional1.append(lesson)
    }
    
    // Yeni ders ekleme fonksiyonu
    static func Secmeli2Ekle(lessonId: Int, lessonName: String , optionalNumber: Int) {
        let lesson = OptionalModel(lessonId: lessonId, lessonName: lessonName, optionalNumber: optionalNumber)
        optional2.append(lesson)
    }
    // Yeni ders ekleme fonksiyonu
    static func Secmeli3Ekle(lessonId: Int, lessonName: String, optionalNumber: Int) {
        let lesson = OptionalModel(lessonId: lessonId, lessonName: lessonName, optionalNumber: optionalNumber)
        optional3.append(lesson)
    }
    
    // Bu metot, lessonId'ye göre bir elemanı optional1 dizisinden çıkarır
    static func Secmeli1Cikar(lessonId: Int) {
        if let index = optional1.firstIndex(where: { $0.lessonId == lessonId }) {
            optional1.remove(at: index)
        }
    }
    
    static func Secmeli2Cikar(lessonId: Int) {
        if let index = optional2.firstIndex(where: { $0.lessonId == lessonId }) {
            optional2.remove(at: index)
        }
    }
    
    static func Secmeli3Cikar(lessonId: Int) {
        if let index = optional3.firstIndex(where: { $0.lessonId == lessonId }) {
            optional3.remove(at: index)
        }
    }
    
    
    
}

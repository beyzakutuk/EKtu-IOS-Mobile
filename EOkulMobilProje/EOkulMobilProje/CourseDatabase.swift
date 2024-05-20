//
//  CourseDatabase.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 20.05.2024.
//

import Foundation

class CourseDatabase {
    
    static var courseDatabase: [String: CourseModel] = [:]
    
    // Yeni ders ekleme fonksiyonu
    static func yeniDersEkle(courseId: String, courseName: String, isMainCourse: Bool, year: String, type: String) {
        let yeniDers = CourseModel(courseId: courseId, courseName: courseName, isMainCourse: isMainCourse, year: year, type: type)
        courseDatabase[courseId] = yeniDers
    }
    
    // Ders silme fonksiyonu
    static func dersSil(courseId: String) {
        courseDatabase.removeValue(forKey: courseId)
    }
    
    // Tüm dersleri getirme fonksiyonu
    static func tumDersleriGetir() -> [CourseModel] {
        return Array(courseDatabase.values)
    }
    
    // Belirli bir yılın derslerini getirme fonksiyonu
    static func yilinDersleriniGetir(year: String) -> [CourseModel] {
        let filteredCourses = courseDatabase.values.filter { $0.year == year }
        return Array(filteredCourses)
    }
    
    // Belirli bir türdeki dersleri getirme fonksiyonu
    static func turdekiDersleriGetir(type: String) -> [CourseModel] {
        let filteredCourses = courseDatabase.values.filter { $0.type == type }
        return Array(filteredCourses)
    }
}


//
//  TeacherDatabase.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 19.05.2024.
//

import Foundation

class TeacherDatabase
{
    static var teacherDatabase: [String: TeacherModel] = [:]
    
    static func teacherLogin(tckn: String, password: String) -> Bool {
            if let teacher = teacherDatabase[tckn] {
                if teacher.sifre == password {
                    return true // Giriş başarılı
                }
            }
            return false // Giriş başarısız
        }
    
    // Öğretmen ekleme fonksiyonu
    static func yeniOgretmenEkle(isim: String, soyisim: String, tcKimlikNo: String, sifre: String) {
        let yeniOgretmen = TeacherModel(isim: isim, soyisim: soyisim, tcKimlikNo: tcKimlikNo, sifre: sifre)
        teacherDatabase[tcKimlikNo] = yeniOgretmen
    }
}

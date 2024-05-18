//
//  StudentDatabase.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 18.05.2024.
//


import Foundation

class StudentDatabase {
    static var studentDatabase: [String: StudentModel] = [:]
    
    // Öğrenci ekleme fonksiyonu
    static func yeniOgrenciEkle(isim: String, soyisim: String, tcKimlikNo: String, sifre: String, sinifNumarasi: String) {
        let yeniOgrenci = StudentModel(isim: isim, soyisim: soyisim, tcKimlikNo: tcKimlikNo, sifre: sifre, sinifNumarasi: sinifNumarasi)
        studentDatabase[tcKimlikNo] = yeniOgrenci
    }
    
    static func studentLogin(tckn: String, password: String) -> Bool {
            if let student = studentDatabase[tckn] {
                if student.sifre == password {
                    return true // Giriş başarılı
                }
            }
            return false // Giriş başarısız
        }
}


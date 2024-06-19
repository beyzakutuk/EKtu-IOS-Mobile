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
    
    // Öğrencileri listeleme fonksiyonu
    static func tumOgrencileriGetir() -> [StudentModel] {
        return Array(studentDatabase.values)
    }
    
    // Öğrenci silme fonksiyonu
    static func ogrenciSil(tcKimlikNo: String) {
        studentDatabase.removeValue(forKey: tcKimlikNo)
    }
    
    // Öğrenciye ders ekleme fonksiyonu
    static func dersEkle(tcKimlikNo: String, ders: ExamResultsModel) {
        if var ogrenci = studentDatabase[tcKimlikNo] {
            ogrenci.dersler.append(ders)
            studentDatabase[tcKimlikNo] = ogrenci
        }
    }
        
    // Öğrenciden ders çıkarma fonksiyonu
    static func dersCikar(tcKimlikNo: String, dersId: String) {
        if var ogrenci = studentDatabase[tcKimlikNo] {
            if let index = ogrenci.dersler.firstIndex(where: { $0.courseId == dersId }) {
                ogrenci.dersler.remove(at: index)
                studentDatabase[tcKimlikNo] = ogrenci
            }
        }
    }
        
    // Öğrencinin derslerini getirme fonksiyonu
    static func ogrencininDersleriniGetir(tcKimlikNo: String) -> [ExamResultsModel]? {
        if let ogrenci = studentDatabase[tcKimlikNo] {
            return ogrenci.dersler
        }
        return nil
    }
    
    // Öğrencinin güz dönemi derslerini getirme fonksiyonu
    static func ogrencininGuzDonemiDersleriniGetir(tcKimlikNo: String) -> [ExamResultsModel]? {
        return studentDatabase[tcKimlikNo]?.dersler.filter { $0.course.type == "Güz" }
    }
    
    // Öğrencinin bahar dönemi derslerini getirme fonksiyonu
    static func ogrencininBaharDonemiDersleriniGetir(tcKimlikNo: String) -> [ExamResultsModel]? {
        return studentDatabase[tcKimlikNo]?.dersler.filter { $0.course.type == "Bahar" }
    }
}


//
//  DirectorDatabase.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 19.05.2024.
//

import Foundation

class DirectorDatabase
{
    static var directorDatabase: [String: DirectorModel] = [:]
    
    static func directorLogin(tckn: String, password: String) -> Bool {
            if let director = directorDatabase[tckn] {
                if director.sifre == password {
                    return true // Giriş başarılı
                }
            }
            return false // Giriş başarısız
        }
    
    // Öğretmen ekleme fonksiyonu
    static func yeniMudurEkle(isim: String, soyisim: String, tcKimlikNo: String, sifre: String) {
        let yeniMudur = DirectorModel(isim: isim, soyisim: soyisim, tcKimlikNo: tcKimlikNo, sifre: sifre)
        directorDatabase[tcKimlikNo] = yeniMudur
    }
}

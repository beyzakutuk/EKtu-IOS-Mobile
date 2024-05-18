//
//  StudentModel.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 30.04.2024.
//

import Foundation

class StudentModel: UserModel {
    var sinifNumarasi: String
    
    init(isim: String, soyisim: String, tcKimlikNo: String, sifre: String, sinifNumarasi: String) {
        self.sinifNumarasi = sinifNumarasi
        super.init(isim: isim, soyisim: soyisim, tcKimlikNo: tcKimlikNo, sifre: sifre)
    }
    
    // Öğrenciye özgü davranışlar eklenebilir
}

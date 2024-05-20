//
//  StudentModel.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 30.04.2024.
//

import Foundation

class StudentModel: UserModel {
    var sinifNumarasi: String
    var dersler : [ExamResultsModel]
    
    init(isim: String, soyisim: String, tcKimlikNo: String, sifre: String, sinifNumarasi: String) {
        self.sinifNumarasi = sinifNumarasi
        self.dersler = []
        super.init(isim: isim, soyisim: soyisim, tcKimlikNo: tcKimlikNo, sifre: sifre)
    }
}

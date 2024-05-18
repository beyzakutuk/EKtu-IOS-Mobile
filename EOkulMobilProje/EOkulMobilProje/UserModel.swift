//
//  UserModel.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 30.04.2024.
//

import Foundation

class UserModel {
    var isim: String
    var soyisim: String
    var tcKimlikNo: String
    var sifre: String
    
    init(isim: String, soyisim: String, tcKimlikNo: String, sifre: String) {
        self.isim = isim
        self.soyisim = soyisim
        self.tcKimlikNo = tcKimlikNo
        self.sifre = sifre
    }
}


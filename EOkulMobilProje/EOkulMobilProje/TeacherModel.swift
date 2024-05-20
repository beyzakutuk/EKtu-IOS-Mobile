//
//  TeacherModel.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 19.05.2024.
//

import Foundation

class TeacherModel : UserModel
{
    var dersAdi :String
    init(isim: String, soyisim: String, tcKimlikNo: String, sifre: String , dersAdi:String)
    {
        self.dersAdi = dersAdi
        super.init(isim: isim, soyisim: soyisim, tcKimlikNo: tcKimlikNo, sifre: sifre)
    }
}

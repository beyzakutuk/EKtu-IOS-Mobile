//
//  UserModel.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 30.04.2024.
//

import Foundation

struct UserModel
{
    let firstName : String
    let lastName:String
    let tcNo:String
    let password:String
    let userType: UserType
}

enum UserType {
    case Student(classId: String)
    case Teacher
    case Director
    // Diğer kullanıcı tipleri buraya eklenebilir
}

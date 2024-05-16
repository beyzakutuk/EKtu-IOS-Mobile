//
//  NetworkService.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 30.04.2024.
//

import Foundation

class NetworkService
{
    static let shared = NetworkService()
    
    var user : UserModel?
    
    var currentUser: UserModel? {
            return user
    }
    
    var student: StudentModel?
    
    func loginStudent(tcNo : String , password : String , completion : @escaping(Bool) -> Void)
    {
        DispatchQueue.global().async { // arkaplan işlemleri
            sleep(2)
            DispatchQueue.main.async { // önyüz işlemleri
                if tcNo == "12345678901" && password == "8901"
                {
                    self.user = UserModel(firstName: "Beyza", lastName: "Kütük", tcNo: tcNo, password: password, userType: UserType.Student(classId: "3.Sınıf"))
                    completion(true)
                }
                else
                {
                    self.user=nil
                    completion(false)
                }
            }
        }
    }
    
    func loginTeacher(tcNo : String , password : String , completion : @escaping(Bool) -> Void)
    {
        DispatchQueue.global().async { // arkaplan işlemleri
            sleep(2)
            DispatchQueue.main.async { // önyüz işlemleri
                if tcNo == "23456789012" && password == "9012"
                {
                    self.user = UserModel(firstName: "Eda", lastName: "Korkusuz", tcNo: tcNo, password: password, userType: UserType.Teacher)
                    completion(true)
                }
                else
                {
                    self.user=nil
                    completion(false)
                }
            }
        }
    }
    
    func loginDirector(tcNo : String , password : String , completion : @escaping(Bool) -> Void)
    {
        DispatchQueue.global().async { // arkaplan işlemleri
            sleep(2)
            DispatchQueue.main.async { // önyüz işlemleri
                if tcNo == "34567890123" && password == "0123"
                {
                    self.user = UserModel(firstName: "Olgunbey", lastName: "Şahin", tcNo: tcNo, password: password, userType: UserType.Director)
                    completion(true)
                }
                else
                {
                    self.user=nil
                    completion(false)
                }
            }
        }
    }
}

//
//  AbsencesModel.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 12.05.2024.
//

import Foundation

struct AbsencesModel
{
    var courseName : String
    var absencesDate : String
}

class AbsencesManager {
    
    var absencesList = [AbsencesModel]()
    
    // Yeni bir devamsızlık eklemek için
    func addAbsence(courseName: String, absenceDate: String) {
        let absence = AbsencesModel(courseName: courseName, absenceDate: absenceDate)
        absencesList.append(absence)
        sortAbsencesByDate()
    }
    
    // Devamsızlıkları tarihe göre sıralamak için
    private func sortAbsencesByDate() {
        absencesList.sort { $0.absenceDate < $1.absenceDate }
    }
    
    func getAllAbsences() -> [AbsencesModel] {
            return absencesList
    }
}

/*

func fetchAbsencesFromAPI(completion: @escaping ([AbsencesModel]) -> Void) {
    // Burada API'den devamsızlık verilerini çek
    // ve bu verileri bir dizi şeklinde completion handler ile geri döndür
    // Örneğin:
    let absencesDataFromAPI: [AbsencesModel] = [
        AbsencesModel(courseName: "Matematik", absenceDate: "2024-05-10"),
        AbsencesModel(courseName: "Fizik", absenceDate: "2024-05-08"),
        AbsencesModel(courseName: "Tarih", absenceDate: "2024-05-09")
    ]
    completion(absencesDataFromAPI)
}

// Kullanım örneği
let absencesManager = AbsencesManager()

// API'den devamsızlık verilerini al
fetchAbsencesFromAPI { absencesData in
    // API'den gelen verileri kullanarak devamsızlık ekle
    for absence in absencesData {
        absencesManager.addAbsence(courseName: absence.courseName, absenceDate: absence.absenceDate)
    }
    
    // Devamsızlık dizisini al
    let allAbsences = absencesManager.getAllAbsences()
    print("All Absences:")
    for absence in allAbsences {
        print("Course: \(absence.courseName), Absence Date: \(absence.absenceDate)")
    }
}
*/

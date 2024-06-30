//
//  ClassListViewController.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 29.06.2024.
//

import UIKit

class ClassListViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{

    var Classes : [Class] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: SelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        getClasses()
        
    }
    
    func getClasses()
    {
        let urlString = "https://localhost:7134/connect/token"

        let client_id = "ClientCredentials"
        let client_secret = "secret"
        let grant_type = "client_credentials"
            
        let parameters = "client_id=\(client_id)&client_secret=\(client_secret)&grant_type=\(grant_type)"
        let postData = parameters.data(using: .utf8)
        
        var request = URLRequest(url: URL(string: urlString)!)
            request.httpMethod = "POST"
            request.httpBody = postData
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
        let session = URLSession(configuration: .default, delegate: MySessionDelegate(), delegateQueue: nil)
        let task = session.dataTask(with: request) { data, response, error in
            print("request başarılı")
            if let error = error {
                print("Hata: \(error)")
                return
            }

            guard let data = data else {
                print("Boş yanıt")
                return
            }
            // JSON verilerini çözme
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    // Access token alınması
                    if let accessToken = json["access_token"] as? String {
                        print("Access Token: \(accessToken)")

                        let urlStringGet = "https://localhost:7253/api/student/getclasslist"
                               
                        var request = URLRequest(url: URL(string: urlStringGet)!)
                        request.httpMethod = "GET"
                        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
                            
                           
                        let task = session.dataTask(with: request) { data, response, error in
                            print("request başarılı")
                            if let error = error {
                                print("Hata: \(error.localizedDescription)")
                                return
                            }

                            guard let data = data else {
                                print("Boş yanıt")
                                return
                            }
                            
                            if let httpResponse = response as? HTTPURLResponse {
                                print(httpResponse.statusCode)
                                if httpResponse.statusCode == 200 {
                             
                                    do {
                                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                            print("Alınan veri: \(json)")
                                
                                            Class.removeAllClasses()
                                         
                                            if let classDatas = json["data"] as? [[String: Any]] {
                                                for classData in classDatas {
                                             
                                                    if let classId = classData["classId"] as? Int,
                                                       let className = classData["className"] as? String {
                                                        let classs = Class(classId: classId, className: className)
                                                 
                                                        Class.addClass(classs)
                                                    }
                                                 
                                                }
                                            }
                                            self.Classes = Class.getAllClasses()
                                            
                                            DispatchQueue.main.async {
                                                self.tableView.reloadData() // TableView'i yeniden yükle
                                            }
                                     
                                        } else {
                                            print("Geçersiz JSON formatı.")
                                        }
                                    } catch {
                                        print("JSON çözümleme hatası: \(error)")
                                    }
                                } else {
                                    print("Sunucudan hata kodu alındı: \(httpResponse.statusCode)")
                                    }
                                }
                            }
                    
                        // İsteği başlatma
                        task.resume()
                    
                    } else {
                        print("Access Token alınamadı.")
                    }
                } else {
                    print("Geçersiz JSON formatı.")
                }
            } catch {
                print("JSON çözümleme hatası: \(error)")
            }
        }
 
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Classes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ClassListTableViewCell
        let classs = self.Classes[indexPath.row]
        cell.classNameLabel.text = classs.className


        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedClass = Classes[indexPath.row]
            Class.id = selectedClass.classId
            
            print("Selected Class ID: \(Class.id)")
            
            delegate?.didSelectItem(selectedClass)
            self.dismiss(animated: true, completion: nil)
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60 
    }


}

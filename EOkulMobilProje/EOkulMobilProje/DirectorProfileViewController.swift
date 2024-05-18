//
//  DirectorProfileViewController.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 30.04.2024.
//

import UIKit

class DirectorProfileViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    var director : DirectorModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupProfile()
    }
    

    private func setupProfile() {
            guard let director = director else { return }
            nameLabel.text = "\(director.isim) \(director.soyisim)"
    }

}

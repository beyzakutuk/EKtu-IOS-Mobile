//
//  ClassListTableViewCell.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 29.06.2024.
//

import UIKit

class ClassListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var classNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

protocol SelectionDelegate: AnyObject {
    func didSelectItem(_ item: Class)
}


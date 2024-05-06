//
//  StudentSelectedCourseTableViewCell.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 6.05.2024.
//

import UIKit

class StudentSelectedCourseTableViewCell: UITableViewCell {

    @IBOutlet weak var selectedLessonName: UILabel!
    @IBOutlet weak var removeButton: UIButton!
    
    var removeCourseAction: (() -> Void)?

        override func awakeFromNib() {
            super.awakeFromNib()
            removeButton.addTarget(self, action: #selector(removeButtonTapped(_:)), for: .touchUpInside)
        }

        @objc func removeButtonTapped(_ sender: UIButton) {
            removeCourseAction?()
        }

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
            // Configure the view for the selected state
        }

}

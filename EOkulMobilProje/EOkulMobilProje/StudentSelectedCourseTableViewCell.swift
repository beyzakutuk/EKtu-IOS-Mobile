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
    
    weak var delegate: StudentSelectedCourseDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @objc func removeButtonTapped(_ sender: UIButton) {
        delegate?.didTapRemoveButton(cell: self)
    }
        
    func configureCell() {
            removeButton.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
    }
}

protocol StudentSelectedCourseDelegate: AnyObject {
    func didTapRemoveButton(cell: StudentSelectedCourseTableViewCell)
}

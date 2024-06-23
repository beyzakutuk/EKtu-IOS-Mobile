//
//  OptionalCourse2SelectionTableViewCell.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 5.06.2024.
//

import UIKit

class OptionalCourse2SelectionTableViewCell: UITableViewCell {

    @IBOutlet weak var lessonNameLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    weak var delegate: OptionalCourse2SelectionDelegate?
    
    var addCourseAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configureCell() {
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    @objc func addButtonTapped(_ sender: UIButton) {
        delegate?.didTapAddButton(cell: self)
    }
}


protocol OptionalCourse2SelectionDelegate: AnyObject {
    func didTapAddButton(cell: OptionalCourse2SelectionTableViewCell)
}

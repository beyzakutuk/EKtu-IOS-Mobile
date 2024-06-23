//
//  OptionalCourseSelectionTableViewCell.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 1.06.2024.
//

import UIKit

class OptionalCourseSelectionTableViewCell: UITableViewCell {

    
    @IBOutlet weak var lessonNameLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    weak var delegate: OptionalCourseSelectionDelegate?
    
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

protocol OptionalCourseSelectionDelegate: AnyObject {
    func didTapAddButton(cell: OptionalCourseSelectionTableViewCell)
}

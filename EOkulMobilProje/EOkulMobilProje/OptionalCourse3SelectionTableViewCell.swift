//
//  OptionalCourse3SelectionTableViewCell.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 5.06.2024.
//

import UIKit

class OptionalCourse3SelectionTableViewCell: UITableViewCell {

    @IBOutlet weak var lessonNameLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    weak var delegate: OptionalCourse3SelectionDelegate?
    
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

protocol OptionalCourse3SelectionDelegate: AnyObject {
    func didTapAddButton(cell: OptionalCourse3SelectionTableViewCell)
}

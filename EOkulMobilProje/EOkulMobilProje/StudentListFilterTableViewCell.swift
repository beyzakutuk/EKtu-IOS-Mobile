//
//  StudentListFilterTableViewCell.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 27.06.2024.
//

import UIKit

class StudentListFilterTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    weak var delegate: StudentListFilterDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func addButtonTapped(_ sender: UIButton) {
        delegate?.didTapAddButton(cell: self)
    }
    
    func configureCell() {
            addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }

}


protocol StudentListFilterDelegate: AnyObject {
    func didTapAddButton(cell: StudentListFilterTableViewCell)
}

//
//  StudentExamListTableViewCell.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 22.06.2024.
//

import UIKit

class StudentExamListTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var studentNameLabel: UILabel!
    @IBOutlet weak var midtermGrades: UILabel!
    @IBOutlet weak var finalGrades: UILabel!
    
    @IBOutlet weak var updateButton: UIButton!
    
    weak var delegate: StudentExamListnDelegate?
    
    @IBAction func updateButton(_ sender: Any) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell() {
            updateButton.addTarget(self, action: #selector(updateButtonTapped), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    @objc func updateButtonTapped(_ sender: UIButton) {
        delegate?.didTapUpdateButton(cell: self)
    }

}

protocol StudentExamListnDelegate: AnyObject {
    func didTapUpdateButton(cell: StudentExamListTableViewCell)
}

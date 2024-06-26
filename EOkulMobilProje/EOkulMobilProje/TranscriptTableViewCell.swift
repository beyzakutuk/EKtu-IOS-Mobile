//
//  TranscriptTableViewCell.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 26.06.2024.
//

import UIKit

class TranscriptTableViewCell: UITableViewCell {

    @IBOutlet weak var lessonName: UILabel!
    @IBOutlet weak var grade: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

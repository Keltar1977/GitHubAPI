//
//  SearchTableViewCell.swift
//  github-api
//
//  Created by Maxym Krutykh on 6/6/18.
//  Copyright © 2018 Maxym Krutykh. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    private var limitOffset = 30
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with repository: Repository) {
        let isEmpty = repository.ID == -1
        nameLabel.text = isEmpty ? "No result" : getCutString(repository.fullName)
        descriptionLabel.text = isEmpty ? "" : getCutString(repository.repoDescription)
    }
    
    private func getCutString(_ descriptionString: String) -> String {
        let isShort = descriptionString.count < limitOffset
        let endIndex = isShort ? descriptionString.count : limitOffset
        let postfixString = isShort ? "" : "..."
        let index = descriptionString.index(descriptionString.startIndex, offsetBy: endIndex)
        return String(descriptionString[..<index]) + postfixString
    }
    
}

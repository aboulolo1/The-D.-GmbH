//
//  RepositoryTableViewCell.swift
//  JakeGithubRepositories
//
//  Created by Alaa Taher on 9/2/19.
//  Copyright © 2019 Alaa Taher. All rights reserved.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell {

    @IBOutlet weak var repositoryLanguage: UILabel!
    @IBOutlet weak var repositoryDescription: UILabel!
    @IBOutlet weak var repositoryName: UILabel!
    
    
    @IBOutlet weak var repositoryDateUpdate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  CharactersTVCell.swift
//  Marvel Task
//
//  Created by Walid Ahmed on 14/09/2023.
//

import UIKit

class CharactersTVCell: UITableViewCell {

    @IBOutlet weak var characterImg: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var titlebgV: ParallelogramView!
    
    var character: Character? {
        didSet {
            guard let character = character else { return }
            titleLbl.text = character.name
            characterImg.setImage(with: character.thumbnail ?? Thumbnail())
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titlebgV.dropShadow(radius: 5, opacity: 0.08, offset: CGSize(width: 1, height: 1))
    }

}

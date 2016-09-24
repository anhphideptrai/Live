//
//  CategoryCell.swift
//  Live Wallpapers
//
//  Created by Nguyen Duc Phi on 9/24/16.
//  Copyright © 2016 Nguyen Duc Phi. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {
    static let categoryCellIdentifier = "CategoryCellIdentifier"
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSubTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if highlighted {
            lbTitle.textColor = UIColor.black
            lbSubTitle.textColor = UIColor.black
        } else {
            lbTitle.textColor = UIColor.white
            lbSubTitle.textColor = UIColor.lightGray
        }
    }
    
    func setNormalBackground(isEven: Bool) {
        if isEven {
            self.backgroundColor = UIColor(white: 1, alpha: 0.12)
        } else {
            self.backgroundColor = UIColor.clear
        }
    }
}

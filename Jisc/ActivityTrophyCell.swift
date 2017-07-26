//
//  ActivityTrophyCell.swift
//  Jisc
//
//  Created by Therapy Box on 1/13/16.
//  Copyright © 2016 Therapy Box. All rights reserved.
//

import UIKit

let kActivityTrophyCellIdentifier = "ActivityTrophyCellIdentifier"
let kActivityTrophyCellNibName = "ActivityTrophyCell"

class ActivityTrophyCell: UITableViewCell {
	
	@IBOutlet weak var trophyImage:UIImageView!
	@IBOutlet weak var titleLabel:UILabel!
	@IBOutlet weak var explanationLabel:UILabel!
	var theTrophy:Trophy?
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		if (selected) {
			setSelected(false, animated: animated)
		}
	}
	
	func loadTrophy(_ trophy:Trophy) {
		theTrophy = trophy
		let imageName = OneTrophyView.trophyIconForID(trophy.id)
		if (imageName != nil) {
			trophyImage.image = UIImage(named: imageName!)
		}
		titleLabel.text = trophy.name
		explanationLabel.text = trophy.count
	}
}

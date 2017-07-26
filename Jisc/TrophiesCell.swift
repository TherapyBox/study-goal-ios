//
//  TrophiesCell.swift
//  Jisc
//
//  Created by Therapy Box on 1/6/16.
//  Copyright © 2016 Therapy Box. All rights reserved.
//

import UIKit

let kTrophiesCellIdentifier = "kTrophiesCellIdentifier"
let kTrophiesCellNibName = "TrophiesCell"

class OneTrophyView: UIView {
	
	@IBOutlet weak var trophyImage:UIImageDownload!
	@IBOutlet weak var trophyCountView:UIView!
	@IBOutlet weak var trophyCountImage:UIImageView!
	@IBOutlet weak var trophyCountLabel:UILabel!
	var theTrophy:Trophy?
	var count:Int = 0
	var ownerCell:TrophiesCell?
	var ownerCelliPad:TrophiesCelliPad?
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
	
	func loadTrophy(_ trophy:Trophy?, trophyCount:Int) {
		count = trophyCount
		if (trophy != nil) {
			theTrophy = trophy
			let imageName = OneTrophyView.trophyIconForID(trophy!.id)
			if (imageName != nil) {
				trophyImage.image = UIImage(named: imageName!)
			}
			if (count > 1) {
				trophyCountView.alpha = 1.0
				trophyCountLabel.text = "\(count)"
				if (trophy!.type == "gold") {
					trophyCountImage.image = UIImage(named: "goldTrophyCount")
				} else {
					trophyCountImage.image = UIImage(named: "silverTrophyCount")
				}
			} else {
				trophyCountView.alpha = 0.0
				trophyCountLabel.text = ""
				
			}
			alpha = 1.0
		} else {
			trophyImage.image = nil
			alpha = 0.0
		}
	}
	
	class func trophyIconForID(_ ID:String) -> String? {
		var icon:String? = nil
		for (_, item) in trophyDataArray.enumerated() {
			if let dictionary = item as? NSDictionary {
				if let id = dictionary["id"] as? String {
					if id == ID {
						icon = dictionary["icon"] as? String
						break
					}
				}
			}
		}
		return icon
	}
	
	@IBAction func selectTrophy(_ sender:UIButton) {
		ownerCell?.parent?.showDetailsForTrophy(theTrophy)
		ownerCelliPad?.parent?.showDetailsForTrophy(theTrophy)
	}
}

class TrophiesCell: UITableViewCell {
	
	@IBOutlet weak var leftTrophy:OneTrophyView!
	@IBOutlet weak var middleTrophy:OneTrophyView!
	@IBOutlet weak var rightTrophy:OneTrophyView!
	weak var parent:TrophiesVC?
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		leftTrophy.loadTrophy(nil, trophyCount: 0)
		middleTrophy.loadTrophy(nil, trophyCount: 0)
		rightTrophy.loadTrophy(nil, trophyCount: 0)
	}
	
	func loadTrophies(_ left:(trophy:Trophy?, total:Int), middle:(trophy:Trophy?, total:Int), right:(trophy:Trophy?, total:Int)) {
		leftTrophy.loadTrophy(left.trophy, trophyCount: left.total)
		leftTrophy.ownerCell = self
		middleTrophy.loadTrophy(middle.trophy, trophyCount: middle.total)
		middleTrophy.ownerCell = self
		rightTrophy.loadTrophy(right.trophy, trophyCount: right.total)
		rightTrophy.ownerCell = self
	}
}

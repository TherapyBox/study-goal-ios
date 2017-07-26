//
//  TrophiesCelliPad.swift
//  Jisc
//
//  Created by Therapy Box on 1/26/16.
//  Copyright © 2016 Therapy Box. All rights reserved.
//

import UIKit

let kTrophiesCelliPadIdentifier = "TrophiesCelliPadIdentifier"
let kTrophiesCelliPadNibName = "TrophiesCelliPad"

class TrophiesCelliPad: UITableViewCell {

	@IBOutlet weak var leftTrophy:OneTrophyView!
	@IBOutlet weak var middleLeftTrophy:OneTrophyView!
	@IBOutlet weak var middleRightTrophy:OneTrophyView!
	@IBOutlet weak var rightTrophy:OneTrophyView!
	weak var parent:SettingsVC?
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		leftTrophy.loadTrophy(nil, trophyCount: 0)
		middleLeftTrophy.loadTrophy(nil, trophyCount: 0)
		middleRightTrophy.loadTrophy(nil, trophyCount: 0)
		rightTrophy.loadTrophy(nil, trophyCount: 0)
	}
	
	func loadTrophies(_ left:(trophy:Trophy?, total:Int), middleLeft:(trophy:Trophy?, total:Int), middleRight:(trophy:Trophy?, total:Int), right:(trophy:Trophy?, total:Int)) {
		leftTrophy.loadTrophy(left.trophy, trophyCount: left.total)
		leftTrophy.ownerCelliPad = self
		middleLeftTrophy.loadTrophy(middleLeft.trophy, trophyCount: middleLeft.total)
		middleLeftTrophy.ownerCelliPad = self
		middleRightTrophy.loadTrophy(middleRight.trophy, trophyCount: middleRight.total)
		middleRightTrophy.ownerCelliPad = self
		rightTrophy.loadTrophy(right.trophy, trophyCount: right.total)
		rightTrophy.ownerCelliPad = self
	}
	
}

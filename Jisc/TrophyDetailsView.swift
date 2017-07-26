//
//  TrophyDetailsView.swift
//  Jisc
//
//  Created by Therapy Box on 1/26/16.
//  Copyright © 2016 Therapy Box. All rights reserved.
//

import UIKit

class TrophyDetailsView: UIView {

	@IBOutlet weak var trophyNameLabel:UILabel!
	@IBOutlet weak var trophyTypeLabel:UILabel!
	@IBOutlet weak var trophyImageContainer:UIView!
	@IBOutlet weak var trophyImage:UIImageView!
	@IBOutlet weak var trophyReasonLabel:UILabel!
	
	class func create(_ trophy:Trophy?) -> TrophyDetailsView {
		let view:TrophyDetailsView = Bundle.main.loadNibNamed("TrophyDetailsView", owner: nil, options: nil)!.first as! TrophyDetailsView
		view.translatesAutoresizingMaskIntoConstraints = false
		if (trophy != nil) {
			view.trophyNameLabel.text = trophy!.name
			if (trophy!.type.lowercased() == "silver") {
				view.trophyTypeLabel.text = localized("silver")
				view.trophyTypeLabel.textColor = silverBorderColor
				view.trophyImageContainer.backgroundColor = silverBorderColor
			} else {
				view.trophyTypeLabel.text = localized("gold")
				view.trophyTypeLabel.textColor = goldBorderColor
				view.trophyImageContainer.backgroundColor = goldBorderColor
			}
			let imageName = OneTrophyView.trophyIconForID(trophy!.id)
			if (imageName != nil) {
				view.trophyImage.image = UIImage(named: "\(imageName!)_big")
			}
			view.trophyReasonLabel.text = trophy!.descriptionText()
		}
		return view
	}
	
	@IBAction func closeTrophyDetails(_ sender:UIButton) {
		UIView.animate(withDuration: 0.25, animations: { () -> Void in
			self.alpha = 0.0
			}, completion: { (done) -> Void in
				self.removeFromSuperview()
		}) 
	}
}

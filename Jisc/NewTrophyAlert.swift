//
//  NewTrophyAlert.swift
//  Jisc
//
//  Created by Therapy Box on 1/7/16.
//  Copyright © 2016 Therapy Box. All rights reserved.
//

import UIKit

var pendingTrophyAlerts:[NewTrophyAlert] = [NewTrophyAlert]()

class NewTrophyAlert: LocalizableView {
	
	@IBOutlet weak var titleLabel:UILabel!
	@IBOutlet weak var trophyImage:UIImageView!
	
	class func showNewTrophy(_ trophy:Trophy) {
		let view:NewTrophyAlert = Bundle.main.loadNibNamed("NewTrophyAlert", owner: nil, options: nil)!.first as! NewTrophyAlert
		let imageName = OneTrophyView.trophyIconForID(trophy.id)
		if (imageName != nil) {
			view.trophyImage.image = UIImage(named: "\(imageName!)_big")
		}
		view.titleLabel.text = "\(localized("you_earned")) \(trophy.name)"
		if (trophy.type.lowercased() == localized("gold").lowercased()) {
			view.titleLabel.textColor = UIColor.black
		}
		view.frame = UIScreen.main.bounds
		view.alpha = 0
		DELEGATE.window?.addSubview(view)
		
		if (pendingTrophyAlerts.count > 0) {
			pendingTrophyAlerts.append(view)
		} else {
			pendingTrophyAlerts.append(view)
			UIView.animate(withDuration: 0.25, animations: { () -> Void in
				view.alpha = 1.0
			}) 
		}
	}
	
	@IBAction func close(_ sender:UIButton) {
		if (pendingTrophyAlerts.contains(self)) {
			pendingTrophyAlerts.remove(at: pendingTrophyAlerts.index(of: self)!)
		}
		if (pendingTrophyAlerts.count > 1) {
			let nextAlert = pendingTrophyAlerts.last
			self.removeFromSuperview()
			nextAlert?.alpha = 1.0
		} else {
			UIView.animate(withDuration: 0.5, animations: { () -> Void in
				self.alpha = 0.0
				}, completion: { (done) -> Void in
					self.removeFromSuperview()
			}) 
		}
	}
}

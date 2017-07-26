//
//  LocalizableLabel.swift
//  Jisc
//
//  Created by Therapy Box on 2/3/16.
//  Copyright © 2016 Therapy Box. All rights reserved.
//

import UIKit

class LocalizableLabel: UILabel {
	
	@IBInspectable var localizationKey:String?
	@IBInspectable var uppercase:Bool = false
	
	override func awakeFromNib() {
		super.awakeFromNib()
		localize()
		adjustsFontSizeToFitWidth = true
	}
	
	func localize() {
		if (uppercase) {
			text = localized(localizationKey).uppercased()
		} else {
			text = localized(localizationKey)
		}
	}
}

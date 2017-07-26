//
//  LocalizableButton.swift
//  Jisc
//
//  Created by Therapy Box on 2/3/16.
//  Copyright © 2016 Therapy Box. All rights reserved.
//

import UIKit

class LocalizableButton: UIButton {
	
	@IBInspectable var localizationKeyNormal:String?
	@IBInspectable var uppercaseNormal:Bool = false
	@IBInspectable var localizationKeySelected:String?
	@IBInspectable var uppercaseSelected:Bool = false
	
	override func awakeFromNib() {
		super.awakeFromNib()
		localize()
	}
	
	func localize() {
		if (uppercaseNormal) {
			setTitle(localized(localizationKeyNormal).uppercased(), for: UIControlState())
		} else {
			setTitle(localized(localizationKeyNormal), for: UIControlState())
		}
		
		if (uppercaseSelected) {
			setTitle(localized(localizationKeySelected).uppercased(), for: .selected)
		} else {
			setTitle(localized(localizationKeySelected), for: .selected)
		}
	}
}

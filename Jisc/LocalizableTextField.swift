//
//  LocalizableTextField.swift
//  Jisc
//
//  Created by Therapy Box on 2/3/16.
//  Copyright © 2016 Therapy Box. All rights reserved.
//

import UIKit

class LocalizableTextField: UITextField {
	
	@IBInspectable var localizationKeyPlaceholder:String?
	@IBInspectable var uppercasePlaceholder:Bool = false
	@IBInspectable var localizationKeyText:String?
	@IBInspectable var uppercaseText:Bool = false
	
	override func awakeFromNib() {
		super.awakeFromNib()
		localize()
	}
	
	func localize() {
		if (uppercasePlaceholder) {
			placeholder = localized(localizationKeyPlaceholder).uppercased()
		} else {
			placeholder = localized(localizationKeyPlaceholder)
		}
		
		if (uppercaseText) {
			text = localized(localizationKeyText).uppercased()
		} else {
			text = localized(localizationKeyText)
		}
	}
}

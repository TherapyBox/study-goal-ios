//
//  LocalizableView.swift
//  Jisc
//
//  Created by Therapy Box on 2/3/16.
//  Copyright © 2016 Therapy Box. All rights reserved.
//

import UIKit

class LocalizableView: UIView {
	
	@IBOutlet var localizableLabels:[LocalizableLabel] = []
	@IBOutlet var localizableButtons:[LocalizableButton] = []
	@IBOutlet var localizableTextFields:[LocalizableTextField] = []
	@IBOutlet var localizableTextViews:[LocalizableTextView] = []
	
	//MARK: Localization
	
	func localizeLabels() {
		if (localizableLabels.count > 0) {
			for (_, item) in localizableLabels.enumerated() {
				item.localize()
			}
		}
	}
	
	func localizeButtons() {
		if (localizableButtons.count > 0) {
			for (_, item) in localizableButtons.enumerated() {
				item.localize()
			}
		}
	}
	
	func localizeTextFields() {
		if (localizableTextFields.count > 0) {
			for (_, item) in localizableTextFields.enumerated() {
				item.localize()
			}
		}
	}
	
	func localizeTextViews() {
		if (localizableTextViews.count > 0) {
			for (_, item) in localizableTextViews.enumerated() {
				item.localize()
			}
		}
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		localizeLabels()
		localizeButtons()
		localizeTextFields()
		localizeTextViews()
	}
}

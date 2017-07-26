//
//  SingleBarView.swift
//  Jisc
//
//  Created by Therapy Box on 10/20/16.
//  Copyright © 2016 Therapy Box. All rights reserved.
//

import UIKit

class SingleBarView: UIView {
	
	@IBOutlet weak var valueLabel:UILabel!
	@IBOutlet weak var barView:UIView!
	@IBOutlet weak var barSuperview:UIView!
	var percentage:Double = 1.0
	
	class func create(_ value:Double, percentage:Double, color:UIColor) -> SingleBarView {
		let view:SingleBarView = Bundle.main.loadNibNamed("SingleBarView", owner: nil, options: nil)!.first as! SingleBarView
		view.translatesAutoresizingMaskIntoConstraints = false
		view.valueLabel.text = String(format: "%.0f", value)
		if percentage > 0.02 {
			view.percentage = percentage
		} else {
			view.percentage = 0.02
		}
		view.barView.backgroundColor = color
		let height = NSLayoutConstraint(item: view.barView, attribute: .height, relatedBy: .equal, toItem: view.barSuperview, attribute: .height, multiplier: CGFloat(view.percentage), constant: 0.0)
		view.barSuperview.addConstraint(height)
		return view
	}
}

//
//  DoubleBarView.swift
//  Jisc
//
//  Created by Therapy Box on 10/20/16.
//  Copyright © 2016 Therapy Box. All rights reserved.
//

import UIKit

class DoubleBarView: UIView {

	@IBOutlet weak var myValueLabel:UILabel!
	@IBOutlet weak var myBarView:UIView!
	@IBOutlet weak var myBarSuperview:UIView!
	var myPercentage:Double = 1.0
	
	@IBOutlet weak var otherValueLabel:UILabel!
	@IBOutlet weak var otherBarView:UIView!
	@IBOutlet weak var otherBarSuperview:UIView!
	var otherPercentage:Double = 1.0
	
	class func create(_ myValue:Double, myPercentage:Double, myColor:UIColor, otherValue:Double, otherPercentage:Double, otherColor:UIColor) -> DoubleBarView {
		let view:DoubleBarView = Bundle.main.loadNibNamed("DoubleBarView", owner: nil, options: nil)!.first as! DoubleBarView
		view.translatesAutoresizingMaskIntoConstraints = false
		
		view.myValueLabel.text = String(format: "%.0f", myValue)
		if myPercentage > 0.02 {
			view.myPercentage = myPercentage
		} else {
			view.myPercentage = 0.02
		}
		view.myBarView.backgroundColor = myColor
		let myHeight = NSLayoutConstraint(item: view.myBarView, attribute: .height, relatedBy: .equal, toItem: view.myBarSuperview, attribute: .height, multiplier: CGFloat(view.myPercentage), constant: 0.0)
		view.myBarSuperview.addConstraint(myHeight)
		
		view.otherValueLabel.text = String(format: "%.0f", otherValue)
		if otherPercentage > 0.02 {
			view.otherPercentage = otherPercentage
		} else {
			view.otherPercentage = 0.02
		}
		view.otherBarView.backgroundColor = otherColor
		let otherHeight = NSLayoutConstraint(item: view.otherBarView, attribute: .height, relatedBy: .equal, toItem: view.otherBarSuperview, attribute: .height, multiplier: CGFloat(view.otherPercentage), constant: 0.0)
		view.otherBarSuperview.addConstraint(otherHeight)
		
		return view
	}

}

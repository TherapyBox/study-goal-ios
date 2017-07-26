//
//  TargetGraphChart.swift
//  Jisc
//
//  Created by Therapy Box on 1/28/16.
//  Copyright © 2016 Therapy Box. All rights reserved.
//

import UIKit

class TargetGraphChart: UIView {
	
	@IBOutlet weak var targetGraphChartContainer:UIView!
	@IBOutlet weak var viewWithVerticalLabels:UIView!
	@IBOutlet weak var viewWithHorizontalLabels:UIView!
	
	var graph:UIView?
	var theTarget:Target?
	
	override func awakeFromNib() {
		super.awakeFromNib()
		translatesAutoresizingMaskIntoConstraints = false
	}

	func loadTarget(_ target:Target?) {
		graph?.removeFromSuperview()
		theTarget = target
		if (theTarget != nil) {
			let progress = target!.calculateProgress(false)
			graph = GraphGenerator.drawGraphInView(targetGraphChartContainer, frame: targetGraphChartContainer.bounds, values: progress.values, animationDuration: 0.0)
			var maximum = Double(0.0)
			var unit = "m"
			for (_, item) in progress.values.enumerated() {
				maximum = max(maximum, item)
			}
			if (maximum > 60.0) {
				maximum = maximum / 60.0
				unit = "h"
			}
			setVerticalValues(["0\(unit)", "\(Int(maximum / 2))\(unit)", "\(Int(maximum))\(unit)"])
			if let span = kTargetTimeSpan(rawValue: theTarget!.timeSpan) {
				switch (span) {
				case .Daily:
					setHorizontalValues(["9:00", "13:00", "17:00", "21:00"])
				case .Weekly:
					let today = todayNumber()
					var components = DateComponents()
					components.day = -(today - 1)
					let calendar = Calendar.current
					let firstDayOfTheWeek = (calendar as NSCalendar).date(byAdding: components, to: Date(), options: NSCalendar.Options.matchStrictly)!
					dateFormatter.dateFormat = "EEE"
					let string = dateFormatter.string(from: firstDayOfTheWeek)
					if (localized("sun").lowercased().contains(string.lowercased())) {
						setHorizontalValues([localized("sun"), localized("mon"), localized("tue"), localized("wed"), localized("thu"), localized("fri"), localized("sat")])
					} else {
						setHorizontalValues([localized("mon"), localized("tue"), localized("wed"), localized("thu"), localized("fri"), localized("sat"), localized("sun")])
					}
				case .Monthly:
					dateFormatter.dateFormat = "dd"
					let today = Int(dateFormatter.string(from: Date()))
					setHorizontalValues(createStringValuesWithInterval(1, max: today!, pace: 1))
				}
			}
		}
	}
	
	func createStringValuesWithInterval(_ min:Int, max:Int, pace:Int) -> [String] {
		var values = [String]()
		for i in stride(from: min, through: max, by: pace) {
			values.append("\(i)")
		}
		return values
	}
	
	func cleanSubviews(_ view:UIView) {
		while (view.subviews.count > 0) {
			view.subviews.first?.removeFromSuperview()
		}
	}
	
	func addSubview(_ view:UIView, firstAttribute:NSLayoutAttribute, secondAttribute:NSLayoutAttribute, superview:UIView) {
		superview.addSubview(view)
		let firstConstraint = makeConstraint(superview, attribute1: firstAttribute, relation: .equal, item2: view, attribute2: firstAttribute, multiplier: 1.0, constant: 0.0)
		let secondConstraint = makeConstraint(superview, attribute1: secondAttribute, relation: .equal, item2: view, attribute2: secondAttribute, multiplier: 1.0, constant: 0.0)
		superview.addConstraints([firstConstraint, secondConstraint])
	}
	
	func createLegendLabel() -> UILabel {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textAlignment = .center
		label.textColor = UIColor.darkGray
		label.font = myriadProLight(12)
		label.backgroundColor = UIColor.clear
		return label
	}
	
	func setVerticalValues(_ values:[String]) {
		cleanSubviews(viewWithVerticalLabels)
		var lastLabel:UILabel?
		var lastSeparator:UIView?
		for (_, item) in values.enumerated() {
			let label = createLegendLabel()
			label.text = item
			addSubview(label, firstAttribute: .leading, secondAttribute: .trailing, superview: viewWithVerticalLabels)
			let separator = UIView()
			separator.translatesAutoresizingMaskIntoConstraints = false
			addSubview(separator, firstAttribute: .leading, secondAttribute: .trailing, superview: viewWithVerticalLabels)
			let topConstraint = makeConstraint(label, attribute1: .top, relation: .equal, item2: separator, attribute2: .bottom, multiplier: 1.0, constant: 0.0)
			viewWithVerticalLabels.addConstraint(topConstraint)
			if (lastLabel == nil) {
				let bottomConstraint = makeConstraint(viewWithVerticalLabels, attribute1: .bottom, relation: .equal, item2: label, attribute2: .bottom, multiplier: 1.0, constant: 0.0)
				viewWithVerticalLabels.addConstraint(bottomConstraint)
			} else if (lastSeparator != nil) {
				let bottomConstraint = makeConstraint(lastSeparator!, attribute1: .top, relation: .equal, item2: label, attribute2: .bottom, multiplier: 1.0, constant: 0.0)
				viewWithVerticalLabels.addConstraint(bottomConstraint)
				let heightConstraint = makeConstraint(lastSeparator!, attribute1: .height, relation: .equal, item2: separator, attribute2: .height, multiplier: 1.0, constant: 0.0)
				viewWithVerticalLabels.addConstraint(heightConstraint)
			}
			lastLabel = label
			lastSeparator = separator
		}
		lastSeparator?.removeFromSuperview()
		if (lastLabel != nil) {
			let topConstraint = makeConstraint(lastLabel!, attribute1: .top, relation: .equal, item2: viewWithVerticalLabels, attribute2: .top, multiplier: 1.0, constant: 0.0)
			viewWithVerticalLabels.addConstraint(topConstraint)
		}
	}
	
	func setHorizontalValues(_ values:[String]) {
		cleanSubviews(viewWithHorizontalLabels)
		var lastView:UIView?
		for (_, item) in values.enumerated() {
			let label = createLegendLabel()
			label.text = item
			viewWithHorizontalLabels.addSubview(label)
			let topConstraint = makeConstraint(viewWithHorizontalLabels, attribute1: .top, relation: .equal, item2: label, attribute2: .top, multiplier: 1.0, constant: 0.0)
			let bottomConstraint = makeConstraint(viewWithHorizontalLabels, attribute1: .bottom, relation: .equal, item2: label, attribute2: .bottom, multiplier: 1.0, constant: 0.0)
			var leftConstraint:NSLayoutConstraint
			if (lastView != nil) {
				leftConstraint = makeConstraint(lastView!, attribute1: .trailing, relation: .equal, item2: label, attribute2: .leading, multiplier: 1.0, constant: 0.0)
				let widthConstraint = makeConstraint(lastView!, attribute1: .width, relation: .equal, item2: label, attribute2: .width, multiplier: 1.0, constant: 0.0)
				viewWithHorizontalLabels.addConstraint(widthConstraint)
			} else {
				leftConstraint = makeConstraint(viewWithHorizontalLabels, attribute1: .leading, relation: .equal, item2: label, attribute2: .leading, multiplier: 1.0, constant: 0.0)
			}
			viewWithHorizontalLabels.addConstraints([topConstraint, bottomConstraint, leftConstraint])
			lastView = label
		}
		if (lastView != nil) {
			let rightConstraint = makeConstraint(lastView!, attribute1: .trailing, relation: .equal, item2: viewWithHorizontalLabels, attribute2: .trailing, multiplier: 1.0, constant: 0.0)
			viewWithHorizontalLabels.addConstraint(rightConstraint)
		}
	}
}

//
//  TargetPieChart.swift
//  Jisc
//
//  Created by Therapy Box on 1/28/16.
//  Copyright © 2016 Therapy Box. All rights reserved.
//

import UIKit

class TargetPieChart: UIView {
	
	@IBOutlet weak var stretchPieChartContainer:UIView!
	@IBOutlet weak var targetPieChartContainer:UIView!
	@IBOutlet weak var progressLabel:UILabel!
	@IBOutlet weak var starContainerView:UIView!
	@IBOutlet weak var completeLabel:UILabel!
	
	var piechart:UIView?
	var stretchPiechart:UIView?
	var theTarget:Target?
	
	override func awakeFromNib() {
		super.awakeFromNib()
		translatesAutoresizingMaskIntoConstraints = false
	}

	func loadTarget(_ target:Target?) {
		piechart?.removeFromSuperview()
		stretchPiechart?.removeFromSuperview()
		theTarget = target
		if (theTarget != nil) {
			let progress = theTarget!.calculateProgress(false)
			progressLabel.text = theTarget!.progressText(progress)
			completeLabel.text = theTarget!.progressText(progress)
			
			let pieFrame = targetPieChartContainer.bounds
			piechart = GraphGenerator.drawPieChartInView(targetPieChartContainer, frame: pieFrame, fillValue: progress.completionPercentage, animationDuration: 0.0, color: appPurpleColor)
			
			if (progress.completionPercentage >= 1.0) {
				let stretchTarget = dataManager.getStretchTargetForTarget(theTarget!)
				if (stretchTarget != nil) {
					let frame = stretchPieChartContainer.bounds
					let fillValue = stretchTarget!.calculateProgress()
					let color = appPurpleColor.withAlphaComponent(0.75)
					stretchPiechart = GraphGenerator.drawPieChartInView(stretchPieChartContainer, frame: frame, fillValue: fillValue, animationDuration: 0.0, color: color)
					progressLabel.text = theTarget!.progressText(progress)
					completeLabel.text = theTarget!.progressText(progress)
				}
			}
		}
	}
	
	func setTargetIsComplete(_ complete:Bool) {
		if (complete) {
			starContainerView.alpha = 1.0
			progressLabel.alpha = 0.0
		} else {
			starContainerView.alpha = 0.0
			progressLabel.alpha = 1.0
		}
	}
}

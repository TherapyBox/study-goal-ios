//
//  CustomPickerView.swift
//  Jisc
//
//  Created by Therapy Box on 1/22/16.
//  Copyright © 2016 Therapy Box. All rights reserved.
//

import UIKit

protocol CustomPickerViewDelegate {
	func view(_ view:CustomPickerView, selectedRow:Int)
}

private let kItemTypeCellNibName = "ItemTypeCell"
private let kItemTypeCellIdentifier = "ItemTypeCellIdentifier"

class ItemTypeCell: UITableViewCell {
	
	@IBOutlet weak var titleLabel:UILabel!
	@IBOutlet weak var checkmark:UIImageView!
	var centered = false
	
	override func awakeFromNib() {
		super.awakeFromNib()
		checkmark.alpha = 0.0
		titleLabel.adjustsFontSizeToFitWidth = true
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		if (selected && !centered) {
			checkmark.alpha = 1.0
		} else {
			checkmark.alpha = 0.0
		}
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		checkmark.alpha = 0.0
		titleLabel.text = ""
	}
	
	func loadItem(_ item:String, isSelected:Bool, centered:Bool) {
		if isSelected {
			checkmark.alpha = 1.0
		} else {
			checkmark.alpha = 0.0
		}
		titleLabel.text = item
		self.centered = centered
		if centered {
			titleLabel.textAlignment = .center
		} else {
			titleLabel.textAlignment = .left
		}
	}
}

class CustomPickerView: UIView, UITableViewDataSource, UITableViewDelegate {
	
	@IBOutlet var viewsWithRoundedCorners:[ViewWithRoundedCorners] = []
	@IBOutlet weak var titleLabel:UILabel!
	@IBOutlet weak var contentTableView:UITableView!
	@IBOutlet weak var contentTableHeight:NSLayoutConstraint!
	var delegate:CustomPickerViewDelegate?
	var contentArray:[String] = [String]()
	var selectedItem:Int = -1
	var centerIndexes = [Int]()
	
	class func create(_ title:String, delegate:CustomPickerViewDelegate, contentArray:[String], selectedItem:Int) -> CustomPickerView {
		let view:CustomPickerView = Bundle.main.loadNibNamed("CustomPickerView", owner: nil, options: nil)!.first as! CustomPickerView
		view.translatesAutoresizingMaskIntoConstraints = false
		view.titleLabel.text = title
		view.delegate = delegate
		view.contentArray = contentArray
		view.selectedItem = selectedItem
		view.contentTableView.register(UINib(nibName: kItemTypeCellNibName, bundle: Bundle.main), forCellReuseIdentifier: kItemTypeCellIdentifier)
		return view
	}
	
	override func didMoveToSuperview() {
		if (superview != nil) {
			addMarginConstraintsWithView(self, toSuperView: superview!)
			contentTableView.reloadData()
			superview!.layoutIfNeeded()
			contentTableHeight.constant = contentTableView.contentSize.height
			superview!.layoutIfNeeded()
			self.alpha = 0.0
			UIView.animate(withDuration: 0.25, animations: { () -> Void in
				self.alpha = 1.0
			})
		}
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		if (viewsWithRoundedCorners.count > 0) {
			for (_, item) in viewsWithRoundedCorners.enumerated() {
				setCornerRadius(item)
			}
		}
	}
	
	func setCornerRadius(_ view:ViewWithRoundedCorners) {
		view.layer.cornerRadius = view.cornerRadius
		view.layer.masksToBounds = true
	}
	
	@IBAction func closePickerView(_ sender:UIButton) {
		UIView.animate(withDuration: 0.25, animations: { () -> Void in
			self.alpha = 0.0
		}, completion: { (done) -> Void in
			self.removeFromSuperview()
		})
	}
	
	//MARK: UITableView Datasource
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let nrRows = contentArray.count
		return nrRows
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var theCell = tableView.dequeueReusableCell(withIdentifier: kItemTypeCellIdentifier)
		if (theCell == nil) {
			theCell = UITableViewCell()
		}
		return theCell!
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 44.0
	}
	
	//MARK: UITableView Delegate
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		let item = contentArray[indexPath.row]
		let theCell:ItemTypeCell? = cell as? ItemTypeCell
		theCell?.loadItem(item, isSelected: (selectedItem == indexPath.row), centered: centerIndexes.contains(indexPath.row))
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if !centerIndexes.contains(indexPath.row) {
			selectedItem = indexPath.row
			delegate?.view(self, selectedRow: indexPath.row)
			closePickerView(UIButton())
		}
	}
}

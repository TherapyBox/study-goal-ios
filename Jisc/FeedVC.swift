//
//  FeedVC.swift
//  Jisc
//
//  Created by Therapy Box on 10/14/15.
//  Copyright © 2015 Therapy Box. All rights reserved.
//

import UIKit
import CoreData

let openPostMessageTopSpace:CGFloat = -60.0
let emptyFeedPageMessage = localized("empty_feed_page_message")

class FeedVC: BaseViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, CustomPickerViewDelegate {
	
	@IBOutlet weak var feedsTableView:UITableView!
	@IBOutlet weak var postsViewTopSpace:NSLayoutConstraint!
	@IBOutlet weak var postsViewHeight:NSLayoutConstraint!
	@IBOutlet weak var postButtonView:UIView!
	@IBOutlet weak var blockView:UIView!
	@IBOutlet weak var newPostTextView:UITextView!
	@IBOutlet weak var toolbarBottomSpace:NSLayoutConstraint!
	var refreshTimer:Timer?
	@IBOutlet weak var emptyScreenMessage:UIView!
	@IBOutlet weak var peopleButton:UIButton!
	var destinationSelectorView:CustomPickerView!
	var selectedStudent = 0
	var destinationStudentId = ""

	override func viewDidLoad() {
		super.viewDidLoad()
		feedsTableView.register(UINib(nibName: kOneFeedItemCellNibName, bundle: Bundle.main), forCellReuseIdentifier: kOneFeedItemCellIdentifier)
		feedsTableView.contentInset = UIEdgeInsetsMake(10.0, 0.0, 0.0, 0.0)
		refreshTimer = Timer(timeInterval: 30, target: self, selector: #selector(FeedVC.refreshFeeds(_:)), userInfo:nil, repeats: true)
		RunLoop.current.add(refreshTimer!, forMode: RunLoopMode.commonModes)
		let refreshControl = UIRefreshControl()
		refreshControl.addTarget(self, action: #selector(FeedVC.manuallyRefreshFeeds(_:)), for: UIControlEvents.valueChanged)
		feedsTableView.addSubview(refreshControl)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if (dataManager.friendRequests().count > 0) {
			peopleButton.setImage(UIImage(named: "profileButtonHighlighted"), for: UIControlState())
		} else {
			peopleButton.setImage(UIImage(named: "profileButton"), for: UIControlState())
		}
	}
	
	func refreshFeeds(_ sender:Timer) {
		dataManager.silentStudentFeedsRefresh(false) { (success, failureReason) -> Void in
			self.feedsTableView.reloadData()
		}
	}
	
	func manuallyRefreshFeeds(_ sender:UIRefreshControl) {
		dataManager.silentStudentFeedsRefresh(true) { (success, failureReason) -> Void in
			self.feedsTableView.reloadData()
			sender.endRefreshing()
		}
	}
	
	override var preferredStatusBarStyle : UIStatusBarStyle {
		return UIStatusBarStyle.lightContent
	}
	
	@IBAction func search(_ sender:UIButton) {
		let vc = SearchVC()
		navigationController?.pushViewController(vc, animated: true)
	}
	
	@IBAction func settings(_ sender:UIButton) {
		let vc = SettingsVC()
		navigationController?.pushViewController(vc, animated: true)
	}
	
	@IBAction func changeMessageDestination(_ sender:UIButton?) {
		var array:[String] = [String]()
		array.append(localized("everyone"))
		let colleagues = friendsInTheSameCourse()
		for (_, item) in colleagues.enumerated() {
			array.append("\(item.firstName) \(item.lastName)")
		}
		destinationSelectorView = CustomPickerView.create(localized("send_to"), delegate: self, contentArray: array, selectedItem: selectedStudent)
		view.addSubview(destinationSelectorView)
	}
	
	func friendsInTheSameCourse() -> [Friend] {
		var array:[Friend] = [Friend]()
		
		for (_, friend) in dataManager.friends().enumerated() {
			if (!friend.jisc_id.isEmpty) {
				array.append(friend)
			}
		}
		
		return array
	}
	
	func openPostMessageHeight() -> CGFloat {
		return postButtonView.frame.origin.y + postButtonView.frame.size.height
	}
	
	@IBAction func showPostMessageView(_ sender:UIButton) {
		UIView.animate(withDuration: 0.25, animations: { () -> Void in
			self.blockView.alpha = 1.0
			self.postsViewTopSpace.constant = openPostMessageTopSpace
			self.postsViewHeight.constant = self.openPostMessageHeight()
			self.view.layoutIfNeeded()
			}, completion: { (done) -> Void in 
				self.newPostTextView.becomeFirstResponder()
		}) 
	}
	
	@IBAction func hidePostMessageView(_ sender:UIButton) {
		UIView.animate(withDuration: 0.25, animations: { () -> Void in
			self.blockView.alpha = 0.0
			self.postsViewTopSpace.constant = 0.0
			self.postsViewHeight.constant = 0.0
			self.view.layoutIfNeeded()
		}, completion: { (done) -> Void in 
			self.newPostTextView.resignFirstResponder()
		}) 
	}
	
	@IBAction func postMessage(_ sender:UIButton) {
		UIView.animate(withDuration: 0.25, animations: { () -> Void in
			self.blockView.alpha = 0.0
			self.postsViewTopSpace.constant = 0.0
			self.postsViewHeight.constant = 0.0
			self.view.layoutIfNeeded()
		}, completion: { (done) -> Void in
			self.newPostTextView.resignFirstResponder()
			if (!self.newPostTextView.text.replacingOccurrences(of: " ", with: "").isEmpty) {
				if (!self.newPostTextView.text.isEmpty) {
					if self.destinationStudentId.isEmpty {
						DownloadManager().postFeedMessage(dataManager.currentStudent!.id, message: self.newPostTextView.text, alertAboutInternet: true, completion: { (success, result, results, error) -> Void in
							if (success) {
								AlertView.showAlert(true, message: localized("message_posted_successfully"), completion: nil)
							} else {
								var failureReason = kDefaultFailureReason
								if (error != nil) {
									failureReason = error!
								}
								AlertView.showAlert(false, message: failureReason, completion: nil)
							}
							self.newPostTextView.text = ""
							dataManager.getStudentFeeds({ (success, failureReason) -> Void in
								self.feedsTableView.reloadData()
							})
						})
					} else {
						DownloadManager().sendPrivateMessage(self.newPostTextView.text, to: self.destinationStudentId, from: dataManager.currentStudent!.id, alertAboutInternet: true, completion: { (success, result, results, error) in
							if (success) {
								AlertView.showAlert(true, message: localized("message_posted_successfully"), completion: nil)
							} else {
								var failureReason = kDefaultFailureReason
								if (error != nil) {
									failureReason = error!
								}
								AlertView.showAlert(false, message: failureReason, completion: nil)
							}
							self.newPostTextView.text = ""
							dataManager.getStudentFeeds({ (success, failureReason) -> Void in
								self.feedsTableView.reloadData()
							})
						})
					}
				}
			}
		})
	}
	
	//MARK: CustomPickerView Delegate
	
	func view(_ view: CustomPickerView, selectedRow: Int) {
		switch (view) {
		case destinationSelectorView:
			if selectedRow == 0 {
				destinationStudentId = ""
			} else {
				destinationStudentId = friendsInTheSameCourse()[selectedRow - 1].jisc_id
			}
			break
		default:break
		}
	}
	
	//MARK: UITableView Datasource
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let nrRows = dataManager.myFeeds().count
		if (nrRows == 0) {
			emptyScreenMessage.alpha = 1.0
		} else {
			emptyScreenMessage.alpha = 0.0
		}
		return nrRows
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var theCell = tableView.dequeueReusableCell(withIdentifier: kOneFeedItemCellIdentifier)
		if (theCell == nil) {
			theCell = UITableViewCell()
		}
		return theCell!
	}
	
	//MARK: UITableView Delegate
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 126.0
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		let theCell:OneFeedItemCell? = cell as? OneFeedItemCell
		if (theCell != nil) {
			theCell!.tableView = tableView
			theCell!.navigationController = self.navigationController
			theCell!.loadFeedPost(dataManager.myFeeds()[indexPath.row])
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let feed = dataManager.myFeeds()[indexPath.row]
		if (feed.activityType == "friend_request") {
			if (!feed.isMine()) {
				let message = localized("do_you_want_to_respond")
				let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: localized("yes"), style: .default, handler: { (action) in
					let vc = SearchVC()
					vc.newRequests(UIButton())
					self.navigationController?.pushViewController(vc, animated: true)
				}))
				alert.addAction(UIAlertAction(title: localized("no"), style: .cancel, handler: { (action) in }))
				self.navigationController?.present(alert, animated: true, completion: nil)
			}
		} else if feed.activityType == "temp_push_notification" {
			if let studentId = dataManager.currentStudent?.id {
				DownloadManager().markNotificationAsRead(studentdId: studentId, notificationId: feed.id, alertAboutInternet: false, completion: { (success, dictionary, array, error) in
					dataManager.silentStudentFeedsRefresh(true) { (success, failureReason) -> Void in
						self.feedsTableView.reloadData()
					}
				})
			}
		}
	}
	
	func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
		var style = UITableViewCellEditingStyle.none
		if dataManager.myFeeds()[indexPath.row].isMine() {
			style = .delete
		}
		return style
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			let alert = UIAlertController(title: localized("confirmation"), message: localized("are_you_sure_you_want_to_delete_this_message"), preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: localized("yes"), style: .destructive, handler: { (action) in
				let feed = dataManager.myFeeds()[indexPath.row]
				DownloadManager().deleteFeed(feed.id, myID: dataManager.currentStudent!.id, alertAboutInternet: true, completion: { (success, dictionary, array, error) in
					if success {
						dataManager.getStudentFeeds({ (success, error) in
							tableView.reloadData()
						})
					} else {
						var failureReason = kDefaultFailureReason
						if (error != nil) {
							failureReason = error!
						}
						AlertView.showAlert(false, message: failureReason, completion: nil)
					}
				})
			}))
			alert.addAction(UIAlertAction(title: localized("no"), style: .cancel, handler: nil))
			navigationController?.present(alert, animated: true, completion: nil)
		}
	}
	
	//MARK: UITextView Delegate
	
	func textViewDidBeginEditing(_ textView: UITextView) {
		UIView.animate(withDuration: 0.25, animations: { () -> Void in
			self.toolbarBottomSpace.constant = keyboardHeight - 49
			self.view.layoutIfNeeded()
		}) 
	}
	
	func textViewDidEndEditing(_ textView: UITextView) {
		UIView.animate(withDuration: 0.25, animations: { () -> Void in
			self.toolbarBottomSpace.constant = -44.0
			self.view.layoutIfNeeded()
		}) 
	}
	
	@IBAction func closeTextView(_ sender:UIBarButtonItem) {
		newPostTextView.resignFirstResponder()
		if (!newPostTextView.text.isEmpty) {
			postMessage(UIButton())
		}
	}
}

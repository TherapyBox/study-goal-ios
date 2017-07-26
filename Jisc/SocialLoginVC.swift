//
//  SocialLoginVC.swift
//  Jisc
//
//  Created by Paul on 3/3/17.
//  Copyright © 2017 XGRoup. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Google
import Fabric
import TwitterKit

class SocialLoginVC: BaseViewController, GIDSignInUIDelegate {

	weak var loginVC:LoginVC?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		GIDSignIn.sharedInstance().uiDelegate = self
		FBSDKLoginManager().logOut()
		GIDSignIn.sharedInstance().signOut()
        let store = Twitter.sharedInstance().sessionStore
        if let userID = store.session()?.userID {
            store.logOutUserID(userID)
        }
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
//		finishedWithEmail("temp@temp.com", name: "Temp User", userId: "tempuserid1")
		if let currentUser = GIDSignIn.sharedInstance().currentUser {
			if let profile = currentUser.profile {
				if let email = profile.email {
					if let name = profile.name {
						if let id = currentUser.userID {
							self.finishedWithEmail(email, name: name, userId: id)
						}
					}
				}
			}
		}
	}
	
	@IBAction func close(_ sender:UIButton?) {
		dismiss(animated: true, completion: nil)
	}
	
	@IBAction func facebook(_ sender:UIButton?) {
		FBSDKLoginManager().logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
			if error == nil {
				FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, email, name"]).start(completionHandler: { (connection, result, error) in
					if error == nil {
						var dataOk = false
						if let result = result as? [String:String] {
							if let email = result["email"] {
								if let id = result["id"] {
									if let name = result["name"] {
										dataOk = true
										self.finishedWithEmail(email, name: name, userId: id)
									}
								}
							}
						}
						if !dataOk {
							self.finishedWithError(localized("an_unknown_error_occured_please_try_again"))
						}
					} else {
						self.finishedWithError(error!.localizedDescription)
					}
				})
			} else {
				self.finishedWithError(error!.localizedDescription)
			}
		}
	}
	
	@IBAction func googlePlus(_ sender:UIButton?) {
		GIDSignIn.sharedInstance().signIn()
	}
	
	@IBAction func twitter(_ sender:UIButton?) {
		Twitter().logIn(with: self) { (session, error) in
			if error == nil {
				TWTRAPIClient.withCurrentUser().requestEmail(forCurrentUser: { (string, error) in
					if error == nil {
						var dataOk = false
						if let email = string {
							if let id = session?.userID {
								if let name = session?.userName {
									dataOk = true
									self.finishedWithEmail(email, name: name, userId: id)
								}
							}
						}
						if !dataOk {
                            print("DATA NOT OK")
							self.finishedWithError(localized("an_unknown_error_occured_please_try_again"))
						}
					} else {
                        print("ERR TWITTER")
						self.finishedWithError(error!.localizedDescription)
					}
				})
			} else {
				self.finishedWithError(error!.localizedDescription)
			}
		}
	}
	
	//MARK: - Google Delegate
	
	func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
		if error == nil {
			var dataOk = false
			if let signIn = signIn {
				if let currentUser = signIn.currentUser {
					if let profile = currentUser.profile {
						if let email = profile.email {
							if let name = profile.name {
								if let id = currentUser.userID {
									dataOk = true
									self.finishedWithEmail(email, name: name, userId: id)
								}
							}
						}
					}
				}
			}
			if !dataOk {
//				self.finishedWithError(localized("an_unknown_error_occured_please_try_again"))
			}
		} else {
			self.finishedWithError(error!.localizedDescription)
		}
	}
	
	func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
		navigationController?.present(viewController, animated: true, completion: nil)
	}
	
	func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
		viewController.dismiss(animated: true, completion: nil)
	}
	
	//MARK: - Handle completion
	
	func finishedWithError(_ message:String) {
		let alert = UIAlertController(title: localized("error"), message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: localized("ok"), style: .cancel, handler: nil))
		navigationController?.present(alert, animated: true, completion: nil)
	}
	
	func finishedWithEmail(_ email:String, name:String, userId:String) {
		navigationController?.dismiss(animated: true, completion: { 
			self.loginVC?.socialLogin(email: email, name: name, userId: userId)
		})
	}
}

//
//  xAPIRegisterVC.swift
//  Jisc
//
//  Created by Therapy Box on 4/20/16.
//  Copyright © 2016 Therapy Box. All rights reserved.
//

import UIKit

class xAPIRegisterVC: BaseViewController {

	@IBOutlet weak var registerWebView:UIWebView!
	
	var idp = ""
	
	override func viewDidLoad() {
		super.viewDidLoad()
		register();
	}
	
	@IBAction func close(_ sender:UIButton) {
		self.dismiss(animated: true, completion: {
			if let cookies = HTTPCookieStorage.shared.cookies {
				for cookie in cookies {
					HTTPCookieStorage.shared.deleteCookie(cookie)
				}
			}
		})
	}
	
	func register(){
		let defaults = UserDefaults.standard
		let uuid = defaults.string(forKey: "uuid")
		
		var urlString = "https://sp.data.alpha.jisc.ac.uk/Shibboleth.sso/Login?entityID=https://"
		urlString += idp
		urlString += "&target=https://sp.data.alpha.jisc.ac.uk/secure/register/form.php?u="
		urlString += uuid!
		
		let url = URL (string: urlString)
		let requestObj = URLRequest(url: url!);
		registerWebView.loadRequest(requestObj)
	}
}

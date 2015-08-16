//
//  StartupViewController.swift
//  GitClient
//
//  Created by thislooksfun on 7/8/15.
//  Copyright © 2015 thislooksfun. All rights reserved.
//

import UIKit

class StartupViewController: UIViewController
{	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		guard Connection.connectedToNetwork() else {
			self.performSegueWithIdentifier("NoConnection", sender: nil)
			return
		}
		
		if GithubAPI.signedIn() {
			self.navigationController!.parentViewController!.performSegueWithIdentifier("PreLogin", sender: nil)
		} else {
			self.performSegueWithIdentifier("Login", sender: nil)
		}
	}
}
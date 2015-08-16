//
//  AuthViewController.swift
//  GitClient
//
//  Created by thislooksfun on 7/8/15.
//  Copyright © 2015 thislooksfun. All rights reserved.
//

import UIKit

class AuthViewController: PortraitViewController, UITextFieldDelegate
{
	@IBOutlet var backButton: UIView! //The back button - used to return from the 2f auth screen
	
	var nav: UINavigationController!
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		self.nav = self.childViewControllers[0] as! UINavigationController
	}
	
	// Clears the forms and segues to the main view
	func signedIn()
	{
		let controllers = nav.viewControllers
		let login = controllers.count > 1 ? controllers[1] as? LoginViewController : nil
		let auth2f = controllers.count > 2 ? controllers[2] as? Auth2fViewController : nil
		
		login?.clear()  // Clear the username/password
		auth2f?.clear() // Clear the 2f auth code
		self.backButton.alpha = 0
		
		nav.popToRootViewControllerAnimated(false) // Pop back to loading screen
		
		self.performSegueWithIdentifier("SignedIn", sender: self)
	}
	
	// Go back from the 2f auth screen to the main login screen
	@IBAction func goBack() {
		nav.popToViewController(nav.viewControllers[1], animated: true)
		UIView.animateWithDuration(0.25, animations: {
			self.backButton.alpha = 0
		})
	}
	
	// Display the back button
	func showBackButton() {
		UIView.animateWithDuration(0.25, animations: {
			self.backButton.alpha = 1
		})
	}
}
//
//  NavController.swift
//  GitClient
//
//  Created by thislooksfun on 7/7/15.
//  Copyright © 2015 thislooksfun. All rights reserved.
//

import UIKit

class NavController: UINavigationController
{
	// Ask the currently displayed controller whether or not it should be allowed to rotate. Defaults to true
	override func shouldAutorotate() -> Bool {
		let auto = self.topViewController?.shouldAutorotate()
		return auto ?? true
	}
	
	// Ask the currently displayed controller what orientations it allows. Defaults to .All
	override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
		let mask = self.topViewController?.supportedInterfaceOrientations()
		return mask ?? UIInterfaceOrientationMask.All
	}
}
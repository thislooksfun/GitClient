//
//  PortraitViewController.swift
//  GitClient
//
//  Created by thislooksfun on 7/7/15.
//  Copyright © 2015 thislooksfun. All rights reserved.
//

import UIKit

class PortraitViewController: UIViewController
{
	// Make sure supportedInterfaceOrientations: gets called
	override func shouldAutorotate() -> Bool {
		return true
	}
	
	// Only allow portrait mode
	override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
		return UIInterfaceOrientationMask.Portrait
	}
}
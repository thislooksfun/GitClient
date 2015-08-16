//
//  JumpSegue.swift
//  GitClient
//
//  Created by thislooksfun on 7/8/15.
//  Copyright © 2015 thislooksfun. All rights reserved.
//

import UIKit

class JumpSegue: UIStoryboardSegue
{
	override func perform()
	{
		self.destinationViewController.view.frame = self.sourceViewController.view.frame
		if let nav = self.sourceViewController.navigationController {
			nav.pushViewController(self.destinationViewController, animated: true)
		} else {
			self.sourceViewController.presentViewController(self.destinationViewController, animated: true, completion: nil)
		}
	}
}
//
//  MenuBarController.swift
//  GitClient
//
//  Created by thislooksfun on 7/4/15.
//  Copyright (c) 2015 thislooksfun. All rights reserved.
//

import UIKit

class MenuBarController: UIViewController
{
	@IBOutlet var unread: UIView!
	@IBOutlet var ddMenu: UIView!
	@IBOutlet var bottomBar: UIView!
	@IBOutlet var backgroundFade: UIVisualEffectView!
	
	var hidden = true
	
	let barHeight: CGFloat = 70
	
	let gray = UIColor.lightGrayColor()
	let blue = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 255/255)
	
	
	// Init with a frame size - saves an extra call
	init(frame: CGRect) {
		super.init(nibName: "MenuBar", bundle: nil)
		self.view.frame = frame
	}
	
	required init(coder aDecoder: NSCoder) {
		super.init(nibName: "MenuBar", bundle: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		(self.view as! PassThrough).controller = self
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		self.ddMenu.hidden = true;
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		self.unread.hidden = false;
		
		self.setConstraints()
		self.postAnimation()
	}
	
	// Called when one of the menu items is tapped
	@IBAction func buttonPress(sender: UIButton)
	{
		var fun: (() -> Void)? //The function to run after the menu close animation completes
		
		switch (sender.tag) {
		case 1, // Notifications
		/*case*/ 2, // Dashboard
		/*case*/ 3, // Explore
		/*case*/ 4: // Profile
			Logger.debug("Pressed: \(sender.tag) (\(sender.titleLabel!.text!))")
		case 5: // Sign Out
			Logger.debug("Pressed: \(sender.tag) (\(sender.titleLabel!.text!))")
			GithubAPI.signOut()
			fun = { self.navigationController!.popToRootViewControllerAnimated(true) }
		default:
			let none = "nil"
			Logger.warn("Unknown tag \(sender.tag) text: \(sender.titleLabel?.text ?? none)")
		}
		self.toggleMenuWithAnimation(fun)
	}
	
	// Called when the menu button is tapped
	@IBAction func menuButtonPress(sender: UIButton) {
		self.toggleMenuWithAnimation()
	}
	
	// Called when the area outside the menu is tapped
	@IBAction func ousideTap(sender: UITapGestureRecognizer) {
		self.toggleMenuWithAnimation()
	}
	
	// Toggles the menu with an animation
	func toggleMenuWithAnimation() { self.toggleMenuWithAnimation(nil) }
	// Toggles the menu with an animation and an optional method callback on completion
	func toggleMenuWithAnimation(complete: (() -> Void)?)
	{
		preAnimation()
		UIView.animateWithDuration(0.5,
			animations: toggleMenu,
			completion: { (finished) in
				self.postAnimation()
				complete?()
			}
		);
	}
	
	// Sets the state of the menu before the animation starts - used to avoid weirdness
	func preAnimation()
	{
		if self.hidden {
			self.ddMenu.hidden = false
		}
		
		self.setConstraints()
	}
	
	// Sets the state of the menu after the animation ends - used to avoid weirdness
	func postAnimation() {
		if self.hidden {
			self.ddMenu.hidden = true
		}
		self.setConstraints()
	}
	
	// Toggles the state of the menu
	func toggleMenu()
	{
		self.hidden<!
		self.setConstraints()
	}
	
	// Sets the states of all the menu items
	func setConstraints()
	{
		let ddH = self.ddMenu.frame.height
		self.ddMenu.frame.origin.y = self.hidden ? self.barHeight - ddH : self.barHeight
		self.backgroundFade.frame.origin.y = self.hidden ? self.barHeight - ddH : (self.barHeight + ddH) - 2
		
		self.bottomBar.backgroundColor = self.hidden ? self.gray : self.blue
		self.backgroundFade.alpha = self.hidden ? 0 : 1
	}
}

// Allows the menu bar to ignore all taps outside the bar area when the menu is closed
class PassThrough: UIView
{
	var controller: MenuBarController!
	
	override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
		return self.controller.hidden ? point.y <= self.controller.barHeight : true
	}
}

/*
 * Copyright (c) 2013 Nils Mattisson, Martin Hartl
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

class DropdownMenuController: UIViewController
{
	weak var currentViewController: UIViewController!
	var currentSegueIdentifier: String = ""
	@IBOutlet weak var container: UIView!
	@IBOutlet weak var menubar: UIView!
	@IBOutlet weak var menu: UIView!
	@IBOutlet weak var menuButton: UIButton!
	@IBOutlet var titleLabel: UILabel!
	//@IBOutletCollection(UIButton) var buttons: NSArray //TODO
	
	var shouldDisplayDropShape: Bool = false
	var fadeAlpha: CGFloat = 0.0
	var trianglePlacement: CGFloat = 0.0

	var openMenuShape: CAShapeLayer!
	var closedMenuShape: CAShapeLayer!

	override func viewDidLoad() {
		super.viewDidLoad()
		shouldDisplayDropShape = true
		fadeAlpha = 0.5
		trianglePlacement = 0.87
	}

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		// Set the current view controller to the one embedded (in the storyboard).
		self.currentViewController = self.childViewControllers[0] as! UIViewController
		
		// Draw the shapes for the open and close menu triangle.
		self.drawOpenLayer()
		self.drawClosedLayer()
	}

	//Enables/Disables the 'drop' triangle from displaying when down
	func dropShapeShouldShowWhenOpen(shouldShow: Bool) {
		shouldDisplayDropShape = shouldShow
	}

	//Sets the color that background content will fade to when the menu is open
	func setFadeTintWithColor(color: UIColor) {
		self.view.backgroundColor = color
	}

	//Sets the amount of fade that should be applied to background content when menu is open
	func setFadeAmountWithAlpha(alphaVal: Float) {
		fadeAlpha = CGFloat(alphaVal)
	}

	func setMenubarTitle(menubarTitle: String) {
		self.titleLabel.text = menubarTitle
	}

	func setMenubarBackground(color: UIColor) {
		self.menubar.backgroundColor = color
	}

	@IBAction func menuButtonAction(sender: UIButton){
		self.toggleMenu()
	}

	@IBAction func listButtonAction(sender: UIButton) {
		self.hideMenu()
	}

	func toggleMenu() {
		if (self.menu.hidden) {
			self.showMenu()
		} else {
			self.hideMenu()
		}
	}

	func showMenu() {
		self.menu.hidden = false
		self.menu.translatesAutoresizingMaskIntoConstraints()
		self.menu.setTranslatesAutoresizingMaskIntoConstraints(true)
		
		closedMenuShape.removeFromSuperlayer()
		
		if (shouldDisplayDropShape) {
			self.view.layer.addSublayer(openMenuShape)
		}
		
		// Set new origin of menu
		var menuFrame = self.menu.frame
		
		menuFrame.origin.y = self.menubar.frame.size.height - self.offset()
		
		// Set new alpha of Container View (to get fade effect)
		let containerAlpha = fadeAlpha
		
		if (SYSTEM_VERSION_LESS_THAN("7.0")) {
			UIView.beginAnimations(nil, context:nil)
			UIView.setAnimationCurve(.EaseInOut)
			self.menu.frame = menuFrame
			self.container.alpha = CGFloat(containerAlpha)
		} else {
			UIView.animateWithDuration(0.4,
								delay: 0.0,
			   usingSpringWithDamping: CGFloat(1.0),
				initialSpringVelocity: CGFloat(4.0),
							  options: UIViewAnimationOptions.CurveEaseInOut,
						   animations: { () -> Void in
								self.menu.frame = menuFrame
								self.container.alpha = containerAlpha
							},
						   completion: nil)
		}
		
		UIView.commitAnimations()

	}

	func hideMenu() {
		// Set the border layer to hidden menu state
		openMenuShape.removeFromSuperlayer()
		self.view.layer.addSublayer(closedMenuShape)
		
		// Set new origin of menu
		var menuFrame = self.menu.frame
		menuFrame.origin.y = self.menubar.frame.size.height-menuFrame.size.height
		
		// Set new alpha of Container View (to get fade effect)
		let containerAlpha: CGFloat = 1.0
		
		if (SYSTEM_VERSION_LESS_THAN("7.0")) {
			UIView.beginAnimations(nil, context:nil)
			UIView.setAnimationCurve(.EaseInOut)
			UIView.setAnimationDelegate(self)
			UIView.setAnimationDidStopSelector("iOS6_hideMenuCompleted")

			self.menu.frame = menuFrame
			self.container.alpha = containerAlpha
		} else {
			UIView.animateWithDuration(0.3,
							    delay: 0.05,
			   usingSpringWithDamping: CGFloat(1.0),
				initialSpringVelocity: CGFloat(4.0),
							  options: UIViewAnimationOptions.CurveEaseInOut,
				animations: { () -> Void in
							self.menu.frame = menuFrame
								 self.container.alpha = containerAlpha
				},
				completion: { (finished: Bool) -> Void in
								 self.menu.hidden = true
							 })
		}
		
		UIView.commitAnimations()
	}

	func iOS6_hideMenuCompleted() {
		self.menu.hidden = true
	}


	func offset() -> CGFloat {
		return UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation) ? 20.0 : 0.0
	}


	func drawOpenLayer() {
		openMenuShape.removeFromSuperlayer()
		openMenuShape = CAShapeLayer()
		
		// Constants to ease drawing the border and the stroke.
		let height = self.menubar.frame.size.height
		let width = self.menubar.frame.size.width
		let triangleDirection: CGFloat = 1 // 1 for down, -1 for up.
		let triangleSize: CGFloat = 8
		let trianglePosition = trianglePlacement*width
		
		// The path for the triangle (showing that the menu is open).
		var triangleShape = UIBezierPath()
		triangleShape.moveToPoint(CGPointMake(trianglePosition, height))
		triangleShape.addLineToPoint(CGPointMake(trianglePosition + triangleSize, height + (triangleDirection * triangleSize)))
		triangleShape.addLineToPoint(CGPointMake(trianglePosition + (2 * triangleSize), height))
		triangleShape.addLineToPoint(CGPointMake(trianglePosition, height))
		
		openMenuShape.path = triangleShape.CGPath
		openMenuShape.fillColor = self.menubar.backgroundColor!.CGColor
		//[openMenuShape setFillColor:[self.menu.backgroundColor CGColor]]
		var borderPath = UIBezierPath()
		borderPath.moveToPoint(CGPointMake(0, height))
		borderPath.addLineToPoint(CGPointMake(trianglePosition, height))
		borderPath.addLineToPoint(CGPointMake(trianglePosition+triangleSize, height+triangleDirection*triangleSize))
		borderPath.addLineToPoint(CGPointMake(trianglePosition+2*triangleSize, height))
		borderPath.addLineToPoint(CGPointMake(width, height))
		
		openMenuShape.path = borderPath.CGPath
		openMenuShape.strokeColor = UIColor.whiteColor().CGColor
		
		openMenuShape.bounds = CGRectMake(0.0, 0.0, height+triangleSize, width)
		openMenuShape.anchorPoint = CGPointMake(0.0, 0.0)
		openMenuShape.position = CGPointMake(0.0, -self.offset())
	}

	func drawClosedLayer() {
		closedMenuShape.removeFromSuperlayer()
		closedMenuShape = CAShapeLayer()
		
		// Constants to ease drawing the border and the stroke.
		let height = self.menubar.frame.size.height
		let width = self.menubar.frame.size.width
		
		// The path for the border (just a straight line)
		let borderPath = UIBezierPath()
		borderPath.moveToPoint(CGPointMake(0, height))
		borderPath.addLineToPoint(CGPointMake(width, height))
		
		closedMenuShape.path = borderPath.CGPath
		closedMenuShape.strokeColor = UIColor.whiteColor().CGColor
		
		closedMenuShape.bounds = CGRectMake(0.0, 0.0, height, width)
		closedMenuShape.anchorPoint = CGPointMake(0.0, 0.0)
		closedMenuShape.position = CGPointMake(0.0, -self.offset())
	}

	@IBAction func displayGestureForTapRecognizer(recognizer: UITapGestureRecognizer) {
		// Get the location of the gesture
		let tapLocation = recognizer.locationInView(self.view)
		// NSLog("Tap location X:\(tapLocation.x), Y:\(tapLocation.y)")

		// If menu is open, and the tap is outside of the menu, close it.
		if (!CGRectContainsPoint(self.menu.frame, tapLocation) && !self.menu.hidden) {
			self.hideMenu()
		}
	}

	//pragma mark - Rotation

	override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
		closedMenuShape.removeFromSuperlayer()
		openMenuShape.removeFromSuperlayer()
		
		var menuFrame = self.menu.frame
		menuFrame.origin.y = self.menubar.frame.size.height - self.offset()
		self.menu.frame = menuFrame
		
		self.drawClosedLayer()
		self.drawOpenLayer()
		
		if (self.menu.hidden) {
			self.view.layer.addSublayer(closedMenuShape)
		} else if (shouldDisplayDropShape) {
			self.view.layer.addSublayer(openMenuShape)
		}
	}

	//pragma mark - Segue

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		self.currentSegueIdentifier = segue.identifier ?? ""
		super.prepareForSegue(segue, sender: sender)
	}

	override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
		return !self.currentSegueIdentifier.isEqual(identifier)
	}

	//pragma mark - Memory Warning

	override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
	}
}

func SYSTEM_VERSION_LESS_THAN(v: String) -> Bool {
	return UIDevice.currentDevice().systemVersion.compare(v, options: .NumericSearch, range: nil, locale: nil) == .OrderedAscending
}
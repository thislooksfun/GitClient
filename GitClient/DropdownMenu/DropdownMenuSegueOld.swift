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

class DropdownMenuSegue: UIStoryboardSegue
{
	override func perform() {
		let containerViewController = self.sourceViewController as! DropdownMenuController
		let nextViewController = self.destinationViewController as! UIViewController
		let currentViewController = containerViewController.currentViewController as UIViewController
		
		// Add nextViewController as child of container view controller.
		containerViewController.addChildViewController(nextViewController)
		// Tell current View controller that it will be removed.
		currentViewController.willMoveToParentViewController(nil)
		
		// Set the frame of the next view controller to equal the outgoing (current) view controller
		nextViewController.view.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight;
		nextViewController.view.frame = currentViewController.view.frame;
		nextViewController.view.setTranslatesAutoresizingMaskIntoConstraints(true)
		
		// Make the transition with a very short Cross disolve animation
		containerViewController.transitionFromViewController(currentViewController,
											toViewController: nextViewController,
													duration: 0.1,
													 options: UIViewAnimationOptions.TransitionCrossDissolve,
												  animations: { () -> Void in },
												  completion: { (finished: Bool) -> Void in
													   containerViewController.currentViewController = nextViewController;
													   currentViewController.removeFromParentViewController()
													   nextViewController.didMoveToParentViewController(containerViewController)
												   })
		
	}
}

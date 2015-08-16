//
//  AppDelegate.swift
//  GitClient
//
//  Created by thislooksfun on 6/27/15.
//  Copyright (c) 2015 thislooksfun. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	var octigonFont: UIFont?
	
	var authToken: String?
	
	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		// Override point for customization after application launch.
		
		//let splitViewController = self.window!.rootViewController
		//splitViewController.delegate = self
		
		octigonFont = UIFont(name: "octicons", size: 17)
		
		return true
	}

	func applicationWillResignActive(application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(application: UIApplication) {
		GithubAPI.onClose()
	}

	func applicationWillEnterForeground(application: UIApplication) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}
	
	func insert(fire: NSDate)
	{
		UIApplication.sharedApplication().cancelAllLocalNotifications()
		let localNotification = UILocalNotification()
		localNotification.fireDate = NSDate(timeIntervalSinceNow: 10)
		localNotification.alertAction = nil
		localNotification.soundName = UILocalNotificationDefaultSoundName
		localNotification.alertBody = "Hello there!"
		localNotification.alertAction = NSLocalizedString("Thing!", comment: "")
		localNotification.applicationIconBadgeNumber = 1
		UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
	}
	
	func application(app: UIApplication, didReceiveLocalNotification notif: UILocalNotification)
	{
		UIApplication.sharedApplication().cancelAllLocalNotifications();
		app.applicationIconBadgeNumber = notif.applicationIconBadgeNumber - 1;
		
		notif.soundName = UILocalNotificationDefaultSoundName;
		
		Logger.debug("Note!")
	}
}
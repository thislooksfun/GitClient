//
//  Settings.swift
//  GitClient
//
//  Created by thislooksfun on 7/9/15.
//  Copyright © 2015 thislooksfun. All rights reserved.
//

import UIKit

class Settings
{
	private static let defaults = NSUserDefaults.standardUserDefaults()
	
	static let Token = Settings(key: "GithubToken")
	static let User = Settings(key: "GithubUser")
	
	private let key: String
	
	private init(key: String) {
		self.key = key
	}
	
	func get() -> AnyObject? {
		return Settings.defaults.valueForKey(self.key)
	}
	
	func set(obj: AnyObject?) {
		Logger.debug("Setting key \(key) to \(obj)")
		Settings.defaults.setValue(obj, forKey: self.key)
	}
	
	static func save() {
		Logger.debug("Saving:\n\t\(Token.key) : \(Token.get())\n\t\(User.key) : \(User.get())")
		defaults.synchronize()
	}
}
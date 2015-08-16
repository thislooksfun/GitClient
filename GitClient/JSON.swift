//
//  JSON.swift
//  GitClient
//
//  Created by thislooksfun on 7/6/15.
//  Copyright (c) 2015 thislooksfun. All rights reserved.
//

import UIKit

class JSON
{
	private var dict: NSDictionary!
	private var string: String!
	
	init(data: NSData) throws {
		self.string = NSString(data: data, encoding: NSUTF8StringEncoding)! as String
		
		let error: NSError! = NSError(domain: "Migrator", code: 0, userInfo: nil)
		let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves) as? NSDictionary
		guard json != nil else {
			throw error
		}
		self.dict = json!
	}
	
	init?(dict: NSDictionary?) {
		guard dict != nil else {
			return nil
		}
		self.dict = dict!
	}
	
	// Returns a string version of this JSON object
	func toString() -> String {
		do {
			return NSString(data: try NSJSONSerialization.dataWithJSONObject(self.dict, options: NSJSONWritingOptions.PrettyPrinted), encoding: NSUTF8StringEncoding)! as String
		} catch _ {
			return ""
		}
	}
	
	// Gets the specified key, or nil if it doesn't exist
	func getKey(key: String) -> AnyObject? {
		return dict[key]
	}
	
	// Gets the specified key as a String, or nil if it can't be cast or doesn't exist
	func getString(key: String) -> String? {
		let k = getKey(key) as? NSString
		return k as? String
	}
	
	// Gets the specified key as an Int, or nil if it can't be cast or doesn't exist
	func getInt(key: String) -> Int? {
		return getKey(key) as? Int
	}
	
	// Gets the specified key as new JSON object, or nil if it can't be cast or doesn't exist
	func getJson(key: String) -> JSON? {
		return JSON(dict: getKey(key) as? NSDictionary)
	}
}
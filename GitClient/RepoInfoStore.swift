//
//  RepoInfoStore.swift
//  GitClient
//
//  Created by thislooksfun on 7/3/15.
//  Copyright (c) 2015 thislooksfun. All rights reserved.
//

import UIKit

class RepoInfoStore {
	
	var type: RepoType
	var name: String
	var stars: Int
	
	init(type: RepoType, name: String, stars: Int) {
		self.type = type
		self.name = name
		self.stars = stars
	}
	
	/*
	func width() -> CGFloat {
		let s = String(stars) as NSString
		return s.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(17)]).width
	}
	*/
	
	// Formats the name for nicer viewing
	func formatName() -> NSAttributedString {
		let mut = NSMutableAttributedString(string: self.name, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(17)])
		let index = stringLastIndexOf(self.name, target: "/")+1
		
		mut.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 64/255, green: 120/255, blue: 190/255, alpha: 1), range: NSRange(location: 0, length: self.name.characters.count))
		mut.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(17, weight: 2), range: NSRange(location: index, length: self.name.characters.count-index))
		
		return mut
	}
}
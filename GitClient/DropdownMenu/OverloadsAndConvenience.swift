//
//  OverloadsAndConvenience.swift
//  GitClient
//
//  Created by thislooksfun on 7/6/15.
//  Copyright (c) 2015 thislooksfun. All rights reserved.
//

import UIKit


/* == OVERLOADS == */

// Boolean operators
postfix operator <! {}
postfix func <!(inout left: Bool) {
	left = !left
}

infix operator &&= {}
func &&=(inout left: Bool, right: Bool) {
	left = left && right
}

// Int & CGFloat arithmetic
func +(left: CGFloat, right: Int) -> CGFloat {
	return left + CGFloat(right)
}
func +(left: Int, right: CGFloat) -> CGFloat {
	return right + left
}
func -(left: CGFloat, right: Int) -> CGFloat {
	return left - CGFloat(right)
}
func -(left: Int, right: CGFloat) -> CGFloat {
	return right - left
}


/* == CONVENIENCE FUNCTIONS == */

// Gets the last index of a character ina string
func stringLastIndexOf(src: String, target: UnicodeScalar) -> Int {
	let c = Int32(bitPattern: target.value)
	
	let i = src.withCString { s -> Int? in
		let pos = strrchr(s, c)
		return pos != nil ? pos - s : nil
	}
	
	return i ?? -1
}
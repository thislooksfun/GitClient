//
//  Logger.swift
//  GitClient
//
//  Created by thislooksfun on 7/15/15.
//  Copyright © 2015 thislooksfun. All rights reserved.
//

import UIKit

class Logger
{
	// Logs a message at the specified level
	static func log<T>(level: LogLevel, vals: T...) { log(level, seperator: " ", arr: vals) }
	static func log<T>(level: LogLevel, seperator: String, vals: T...) { log(level, seperator: seperator, arr: vals) }
	private static func log<T>(level: LogLevel, seperator: String, arr: [T]) {
		var s = ""
		for v in arr {
			s += (s == "" ? "" : seperator)+"\(v)"
		}
		s = s.stringByReplacingOccurrencesOfString("\n", withString: "\n\(level.prefix): ")
		print("\(level.prefix): [\(__LINE__)] \(s)")
		print(NSThread.callStackSymbols()[0])
	}
	
	// Logs a message at the debug level
	static func debug<T>(vals: T...) { debug(seperator: " ", arr: vals) }
	static func debug<T>(seperator seperator: String, vals: T...) { debug(seperator: seperator, arr: vals) }
	private static func debug<T>(seperator seperator: String, arr: [T]) {
		log(LogLevel.Debug, seperator: seperator, arr: arr)
	}
	
	// Logs a message at the trace level
	static func trace<T>(vals: T...) { trace(seperator: " ", arr: vals) }
	static func trace<T>(seperator seperator: String, vals: T...) { trace(seperator: seperator, arr: vals) }
	private static func trace<T>(seperator seperator: String, arr: [T]) {
		log(LogLevel.Trace, seperator: seperator, arr: arr)
	}
	
	// Logs a message at the info level
	static func info<T>(vals: T...) { info(seperator: " ", arr: vals) }
	static func info<T>(seperator seperator: String, vals: T...) { info(seperator: seperator, arr: vals) }
	private static func info<T>(seperator seperator: String, arr: [T]) {
		log(LogLevel.Info, seperator: seperator, arr: arr)
	}
	
	// Logs a message at the warn level
	static func warn<T>(vals: T...) { warn(seperator: " ", arr: vals) }
	static func warn<T>(seperator seperator: String, vals: T...) { warn(seperator: seperator, arr: vals) }
	private static func warn<T>(seperator seperator: String, arr: [T]) {
		log(LogLevel.Warn, seperator: seperator, arr: arr)
	}
	
	// Logs a message at the error level
	static func error<T>(vals: T...) { error(seperator: " ", arr: vals) }
	static func error<T>(seperator seperator: String, vals: T...) { error(seperator: seperator, arr: vals) }
	private static func error<T>(seperator seperator: String, arr: [T]) {
		log(LogLevel.Error, seperator: seperator, arr: arr)
	}
	
	// Logs a message at the plain level
	static func plain<T>(vals: T...) { plain(seperator: " ", arr: vals) }
	static func plain<T>(seperator seperator: String, vals: T...) { plain(seperator: seperator, arr: vals) }
	private static func plain<T>(seperator seperator: String, arr: [T]) {
		log(LogLevel.Plain, seperator: seperator, arr: arr)
	}
}

struct LogLevel {
	private static var nextIndex = 0
	
	static let Debug = LogLevel(prefix: "DEBUG", color: UIColor.whiteColor())
	static let Trace = LogLevel(prefix: "TRACE", color: UIColor.whiteColor())
	static let Info =  LogLevel(prefix: " INFO",  color: UIColor.whiteColor())
	static let Warn =  LogLevel(prefix: " WARN",  color: UIColor.yellowColor())
	static let Error = LogLevel(prefix: "ERROR", color: UIColor.redColor())
	static let Plain = LogLevel(prefix: "",      color: UIColor.redColor())
	
	let prefix: String
	let color: UIColor
	let index: Int
	private init(prefix: String, color: UIColor) {
		self.prefix = prefix
		self.color = color
		self.index = LogLevel.nextIndex++
		print("\(prefix): \(self.index)")
	}
}
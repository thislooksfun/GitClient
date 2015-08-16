//
//  GithubAPI.swift
//  GitClient
//
//  Created by thislooksfun on 7/6/15.
//  Copyright (c) 2015 thislooksfun. All rights reserved.
//

import UIKit

class GithubAPI
{
	// Variables
	
	private static var authorization: GithubAPIAuthorization?
	
	
	
	// So no one can create a new instance
	private init() {}
	
	private static let authJson = [
		"scopes": ["user", "repo", "delete_repo", "gist", "admin:repo_hook", "admin:org_hook", "admin:org", "admin:public_key"],
		"note": "GitClient app by thislooksfun",
		//"client_id": clientID,
		"client_secret": clientSecret
	] as [NSObject: AnyObject]
	
	// Functions
	
	// Authorizes (logs in) as the specified user
	static func auth(user user: String, pass: String, callback: (AuthState, Auth2fType?) -> Void) {
		self.auth(user: user, pass: pass, callback: callback, forceMainThread: false)
	}
	// Authorizes (logs in) as the specified user with the option to force to the main thread when performing the callback
	static func auth(user user: String, pass: String, callback: (AuthState, Auth2fType?) -> Void, forceMainThread: Bool)
	{
		Logger.debug("\n==============")
		var exitState: AuthState?
		var type: Auth2fType?
		
		let exit = { (state: AuthState, message: String?) -> Void in
			if message != nil { Logger.info(message!) }
			guard exitState == nil else {
				Logger.warn("exitState already set!")
				return
			}
			
			exitState = state
		}
		
		Logger.debug("Authorizing with username='\(user)' and password='\(pass)'")
		
		let authString = GithubAPIAuthorization.generateAuthString(user, pass: pass)
		
		GithubAPIBackend.apiCall("/authorizations/clients/\(clientID)/AppAuth", method: .PUT, headers: ["Authorization" : authString], json: authJson, errorCallback: { (message) in exit(AuthState.Other, message) })
		{ (let json, let httpResponse) in
			//19904254
			let s = json.getString("message")
			if (s == nil) {
				let t = json.getString("token")
				exit(t == nil ? AuthState.Other : AuthState.Success, nil)
			} else {
				switch (s!) {
				case "Must specify two-factor authentication OTP code.":
					let authType = httpResponse.allHeaderFields["X-GitHub-OTP"] as! NSString
					type = authType == "required; app" ? .App : .SMS
					exit(AuthState.Needs2fAuth, "2fauth! Type: \(authType)")
				case "Bad credentials":
					exit(AuthState.BadLogin, nil)
				default:
					exit(AuthState.Other, "Message: "+s!)
				}
			}
			
			if exitState == nil {
				exit(AuthState.Other, "Error: exitState not set!")
			}
			
			if exitState == AuthState.Other {
				Logger.debug(httpResponse)
			}
			
			if exitState == AuthState.Success {
				self.createAuthToken(json)
			}
			
			if (forceMainThread) {
				NSOperationQueue.mainQueue().addOperationWithBlock({
					callback(exitState!, type)
				})
			} else {
				callback(exitState!, type)
			}
		}
	}
	
	// Authorizes (logs in) as the specified user with a 2f auth code
	static func auth2f(user user: String, pass: String, code: String, callback: (Auth2fState) -> Void) {
		auth2f(user: user, pass: pass, code: code, callback: callback, forceMainThread: false)
	}
	// Authorizes (logs in) as the specified user with a 2f auth code with the option to force to the main thread when performing the callback
	static func auth2f(user user: String, pass: String, code: String, callback: (Auth2fState) -> Void, forceMainThread: Bool)
	{
		Logger.debug("\n==============")
		var exitState: Auth2fState?
		let exit = { (state: Auth2fState, message: String?) -> Void in
			if message != nil { Logger.info(message!) }
			guard (exitState == nil) else {
				Logger.warn("Error: exitState already set!")
				return
			}
			
			exitState = state
		}
		
		
		Logger.debug("Authorizing with username='\(user)' and password='\(pass)' and code='\(code)'")
		
		let authString = GithubAPIAuthorization.generateAuthString(user, pass: pass)
		
		GithubAPIBackend.apiCall("/authorizations/clients/\(clientID)/AppAuth", method: .PUT, headers: ["Authorization": authString, "X-GitHub-OTP": code], json: authJson, errorCallback: { (message) in exit(Auth2fState.Other, nil) })
		{ (let json, let httpResponse) in
			
			let s = json.getString("message")
			if (s == nil) {
				let t = json.getString("token")
				exit(t == nil ? Auth2fState.Other : Auth2fState.Success, nil)
			} else {
				if (s! == "Must specify two-factor authentication OTP code.") { exit(Auth2fState.BadCode, nil)
				} else { exit(Auth2fState.Other, "Message: "+s!) }
			}
			
			if exitState == nil { exit(Auth2fState.Other, "Error: exitState not set!") }
			
			if exitState == Auth2fState.Success {
				self.createAuthToken(json)
			}
			
			if exitState == Auth2fState.Other {
				Logger.debug(httpResponse)
			}
			
			if (forceMainThread) {
				NSOperationQueue.mainQueue().addOperationWithBlock({
					callback(exitState!)
				})
			} else {
				callback(exitState!)
			}
		}
	}
	
	// Creates an auth token
	private static func createAuthToken(json: JSON) {
		self.authorization = GithubAPIAuthorization(json: json)
		guard self.authorization != nil else {
			//TODO - error screen
			return
		}
		self.authorization?.save()
	}
	
	private static func checkAuthToken() -> Bool
	{
		self.authorization = GithubAPIAuthorization.load()
		return self.authorization != nil
	}
	
	// Returns true if the user is signed in and the auth token is still valid, otherwise returns false
	static func signedIn() -> Bool {
		return checkAuthToken()
	}
	
	// Clears the auth token for the current session
	static func signOut() {
		let authString = GithubAPIAuthorization.generateAuthString(clientID, pass: clientSecret)
		
		GithubAPIBackend.apiCall("/applications/\(clientID)/tokens/\(self.authorization?.token)", method: .PUT, headers: ["Authorization": authString], json: authJson, errorCallback: { (message) in Logger.debug(message) })
		{ (let json, let httpResponse) in
			Logger.info("Hi. :3")
		}
		
		self.authorization?.delete()
		self.authorization = nil
	}
	
	static func onClose() {
		self.authorization?.save()
	}
}

// Enums
enum AuthState {
	case Success
	case Needs2fAuth
	case BadLogin
	case Other
}

enum Auth2fState {
	case Success
	case BadCode
	case Other
}

enum Auth2fType {
	case App
	case SMS
}
//
//  GithubAPIAuthorization.swift
//  GitClient
//
//  Created by thislooksfun on 7/9/15.
//  Copyright © 2015 thislooksfun. All rights reserved.
//

import UIKit

class GithubAPIAuthorization
{
	let id: Int
	let note:        String
	let user:        String
	let token:       String
	let scopes:     [String]
	let tokenHash:   String
	let fingerprint: String
	
	convenience init?(json: JSON) {
		let tok = json.getString("token")
		guard tok != nil && tok != "" else { return nil }
		self.init(json: json, token: tok!)
	}
	init?(json: JSON, token: String)
	{
		Logger.debug("Loading JSON:\n\(json.toString())\nWith token: '\(token)'")
		var user: String?
		
		if let msg = json.getString("message") {
			Logger.warn("Msg: "+msg)
		}
		
		user = json.getJson("user")?.getString("login")
		
		self.id =          json.getInt("id")!
		self.note =        json.getString("note") ?? ""
		self.token =       token
		self.scopes =      json.getKey("scopes") as! [String]
		self.tokenHash =   json.getString("hashed_token")!
		self.fingerprint = json.getString("fingerprint") ?? ""
		
		
		let authString = GithubAPIAuthorization.generateAuthString(clientID, pass: clientSecret)
		
		if user == nil {
			GithubAPIBackend.apiCall("applications/\(clientID)/tokens/\(token)", method: .GET, headers: ["Authorization": authString], json: nil, errorCallback: { (message) in Logger.info(message); user = nil })
				{ (json, httpResponse) in
					user = json.getJson("user")?.getString("login") ?? ""
			}
			
			while user == nil {}
			
			self.user = user ?? ""
		} else {
			self.user = user!
		}
		
		guard self.user != "" else { return nil }
	}
	
	func save()
	{
		Settings.Token.set(self.token)
		Settings.User.set(self.user)
		Settings.save()
	}
	
	func delete()
	{
		GithubAPIBackend.apiCall("/authorizations/\(self.id)", method: .DELETE, headers: nil /*["Authorization": authString]*/, json: nil, errorCallback: nil)
		{ (json, httpResponse) in
			Logger.info(httpResponse)
		}
		
		Settings.Token.set(nil)
		Settings.User.set(nil)
		Settings.save()
	}
	
	static func load() -> GithubAPIAuthorization?
	{
		let token = Settings.Token.get() as? String
		Logger.debug("Token = \(token)")
		
		guard token != nil && token != "" else { return nil }
		
		var success: Bool?
		var out: GithubAPIAuthorization?
		
		let authString = generateAuthString(clientID, pass: clientSecret)
		
		GithubAPIBackend.apiCall("applications/\(clientID)/tokens/\(token!)", method: .GET, headers: ["Authorization": authString], json: nil, errorCallback: { (message) in Logger.info(message); success = false })
		{ (json, httpResponse) in
			out = GithubAPIAuthorization(json: json, token: token!)
			
			success = true
		}
		
		while success == nil {}
		
		return out
	}
	
	static func generateAuthString(user: String, pass: String) -> String {
		Logger.debug("Generating auth string for user: \(user) pass: \(pass)")
		let userPass = "\(user):\(pass)"
		return "Basic \(userPass.dataUsingEncoding(NSUTF8StringEncoding)!.base64EncodedStringWithOptions([]))"
	}
}
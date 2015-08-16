//
//  RepoViewCell.swift
//  GitClient
//
//  Created by thislooksfun on 7/2/15.
//  Copyright (c) 2015 thislooksfun. All rights reserved.
//

import UIKit

class RepoViewCell: UITableViewCell {
	
	@IBOutlet var repoType: UILabel!
	@IBOutlet var repoName: UILabel!
	@IBOutlet var starCount: UILabel!
	
	func loadItem(info: RepoInfoStore) {
		self.repoType.text = info.type.label
		self.repoName.attributedText = info.formatName()
		self.starCount.text = formatInt(info.stars)
	}
}

// Formats an integer with comma-seperated thousands
func formatInt(int: Int) -> String {
	var i = int
	var out = ""
	while (i > 1000) {
		out = String(i % 1000) + (out.characters.count > 0 ? "," : "") + out
		i /= 1000
	}
	out = String(i) + (out.characters.count > 0 ? "," : "") + out
	return out
}


// The type of the repository
struct RepoType {
	static let Repo = RepoType(id: 0, label: "")
	static let Clone = RepoType(id: 1, label: "")
	static let Fork = RepoType(id: 2, label: "")
	//When adding new repo types, you must add them to this array
	private static let items = [Repo, Clone, Fork]
	
	let id: Int
	let label: String
	
	init(id: Int, label: String) {
		self.id = id
		self.label = label
	}
	
	static func values() -> Array<RepoType> {
		return items
	}
}

func == (left: RepoType, right: RepoType) -> Bool {
	return left.id == right.id
}
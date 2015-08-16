//
//  MasterViewController.swift
//  GitClient
//
//  Created by thislooksfun on 6/27/15.
//  Copyright (c) 2015 thislooksfun. All rights reserved.
//

import UIKit

class MasterViewController: PortraitViewController, UITableViewDelegate, UITableViewDataSource
{
	var menuBar: MenuBarController!
	
	@IBOutlet var repoView: UITableView!
	@IBOutlet var starredView: UITableView!
	@IBOutlet var scrollView: UIScrollView!
	
	@IBOutlet var repoViewHeightConstraint: NSLayoutConstraint!
	@IBOutlet var starredViewHeightConstraint: NSLayoutConstraint!
	
	var repoObjects = [RepoInfoStore]()
	var starObjects = [RepoInfoStore]()
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		/* iPad stuff
		if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
		    self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
		}*/
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		self.menuBar = MenuBarController(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
		self.addChildViewController(self.menuBar)
		self.view.addSubview(self.menuBar.view)
		
		self.scrollView.contentInset.top = 35;
		self.scrollView.scrollIndicatorInsets.top = 30;
		
		let nib = UINib(nibName: "RepoViewCell", bundle: nil)
		self.repoView.registerNib(nib, forCellReuseIdentifier: "repoCell")
		self.starredView.registerNib(nib, forCellReuseIdentifier: "repoCell")
		
		let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "newRepo:")
		self.navigationItem.leftBarButtonItem = addButton
		
		self.repoView.rowHeight = UITableViewAutomaticDimension
		self.repoView.estimatedRowHeight = 44.0
		
		self.starredView.rowHeight = UITableViewAutomaticDimension
		self.starredView.estimatedRowHeight = 44.0
		
		/* iPad stuff
		if let split = self.splitViewController {
		    let controllers = split.viewControllers
		    self.detailViewController = controllers[controllers.count-1].topViewController as? DetailViewController
		}*/
		
		populateRepoTables()
	}
	
	let repos = [
		"Funwayguy/EnviroMine",
		"EnviroMine/EnviroMine-1.7",
		"EnviroMine/PhysicsRewrite",
		"EnviroMine/test-repo",
		"micdoodle8/Galacticraft",
		"NEATSnake",
		"clone-cursor",
		"vidr",
		"tlfbot",
		"ForgeUpdater",
		
		"Funwayguy/EnviroMine",
		"EnviroMine/EnviroMine-1.7",
		"EnviroMine/PhysicsRewrite",
		"EnviroMine/test-repo",
		"micdoodle8/Galacticraft",
		"NEATSnake",
		"clone-cursor",
		"vidr",
		"tlfbot",
		"ForgeUpdater",
	]
	
	func newRepo(sender: AnyObject) {
		//Segue to new repo page
	}
	
	func populateRepoTables() {
		for i in 0..<10 {
			insertNewObject(nil, info: RepoInfoStore(type: RepoType.Repo, name: repos[i], stars: randInt(23, max: 150)))
		}
		updateRepoHeight()
		
		for _ in 0..<20 {
			insertNewStar(nil, info: RepoInfoStore(type: RepoType.Fork, name: "EnviroMine/EnviroMine-1.7", stars: randInt(8, max: 90000)))
		}
		updateStarredHeight()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func insertNewObject(sender: AnyObject?, info: RepoInfoStore) {
		repoObjects.insert(info, atIndex: repoObjects.count)
		let indexPath = NSIndexPath(forRow: repoObjects.count-1, inSection: 0)
		repoView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .None)
		repoView.reloadData()
	}
	
	func insertNewStar(sender: AnyObject?, info: RepoInfoStore) {
		starObjects.insert(info, atIndex: starObjects.count)
		let indexPath = NSIndexPath(forRow: starObjects.count-1, inSection: 0)
		starredView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .None)
		starredView.reloadData()
	}
	
	func updateRepoHeight() {
		self.repoViewHeightConstraint.constant = self.repoView.contentSize.height + self.repoObjects.count
		self.view.needsUpdateConstraints()
	}
	
	func updateStarredHeight() {
		self.starredViewHeightConstraint.constant = self.starredView.contentSize.height + self.starObjects.count
		self.view.needsUpdateConstraints()
	}
	
	func afterSegue() {
		self.menuBar.toggleMenu()
	}
	
	// MARK: - Segues

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "showDetail" {
			//TODO
		} else {
			Logger.warn("Unknown segue with identifier: '"+(segue.identifier ?? "nil")+"'")
		}
	}
	
	// MARK: - Table View
	
	func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		// Return false if you do not want the specified item to be editable.
		return true
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if (tableView.tag == 1) {
			if editingStyle == .Delete {
				repoObjects.removeAtIndex(indexPath.row)
				tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
			} else if editingStyle == .Insert {
				// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
			}
		} else {
			if editingStyle == .Delete {
				starObjects.removeAtIndex(indexPath.row)
				tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
			} else if editingStyle == .Insert {
				// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
			}
		}
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if (tableView.tag == 1) {
			Logger.info("\nTable 1, index: \(indexPath.item)")
			Logger.info("\(repoObjects[indexPath.item].name)")
		} else {
			Logger.info("\nTable 2, index: \(indexPath.item)")
			Logger.info("\(starObjects[indexPath.item].name)")
		}
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if (tableView.tag == 1) {
			return repoObjects.count
		} else {
			return starObjects.count
		}
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if (tableView.tag == 1) {
			let cell = tableView.dequeueReusableCellWithIdentifier("repoCell", forIndexPath: indexPath) as! RepoViewCell
			
			let info = repoObjects[indexPath.row]
			cell.loadItem(info)
			return cell
		} else {
			let cell = tableView.dequeueReusableCellWithIdentifier("repoCell", forIndexPath: indexPath) as! RepoViewCell
			
			let info = starObjects[indexPath.row]
			cell.loadItem(info)
			return cell
		}
	}
}

func randInt(min: UInt32, max: UInt32) -> Int {
	let i = arc4random_uniform(max - min) + min
	return Int(i)
}

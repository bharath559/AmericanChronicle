//
//  MasterViewController.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/8/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    enum State: Int {
        case Alabama
        case Arizona
        case Arkansas
    }

    class Newspaper {
        let title: String
        let city: String
        var startYear: Int?
        var endYear: Int?

        init(title: String, city: String, startYear: Int?, endYear: Int?) {
            self.title = title
            self.city = city
            self.startYear = startYear
            self.endYear = endYear
        }
    }

    var newspapers = [State: [Newspaper]]()

    override func awakeFromNib() {
        super.awakeFromNib()

        newspapers[.Alabama] = [Newspaper(title: "Chattanooga daily rebel.", city: "Selma", startYear: 1865, endYear: 1865)]
        newspapers[.Arizona] = [
            Newspaper(title: "The argus", city: "Holbrook", startYear: 1895, endYear: 1900),
            Newspaper(title: "The Arizona champion", city: "Peach Springs", startYear: 1883, endYear: 1891),
            Newspaper(title: "Arizona citizen", city: "Tucson", startYear: 1870, endYear: 1880),
            Newspaper(title: "The Arizona daily orb", city: "Bisbee", startYear: 1898, endYear: 1900),
            Newspaper(title: "The Arizona kicker", city: "Tombstone", startYear: 1893, endYear: 1913),
            Newspaper(title: "Arizona miner", city: "Fort Whipple", startYear: 1864, endYear: 1868),
            Newspaper(title: "Arizona republican", city: "Phoenix", startYear: 1890, endYear: 1930)
        ]
        newspapers[.Arkansas] = [Newspaper(title: "The argus", city: "Holbrook", startYear: 1895, endYear: 1900)]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
//                let object = objects[indexPath.row] as! NSDate
//            (segue.destinationViewController as! DetailViewController).detailItem = object
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return newspapers.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let state = State(rawValue: section) {
            return newspapers[state]?.count ?? 0
        }
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        if let state = State(rawValue: indexPath.section) {
            if let papers = newspapers[state] {
                let paper = papers[indexPath.row]
                cell.textLabel?.text = paper.title
                return cell
            }
        }
        cell.textLabel?.text = nil
        return cell
    }


}


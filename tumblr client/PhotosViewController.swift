//
//  ViewController.swift
//  tumblr client
//
//  Created by phil_nachum on 8/3/16.
//  Copyright © 2016 phil_nachum. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var posts: [NSDictionary]!
    var refreshControl: UIRefreshControl = UIRefreshControl()


    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)

        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view, typically from a nib.
        fetchData()
    }

    private func fetchData() {
        let url = NSURL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)

        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )

        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                    data, options:[]) as? NSDictionary {
                    print("response: \(responseDictionary)")

                    let response = responseDictionary["response"] as! NSDictionary
                    self.posts = response["posts"] as! [NSDictionary]
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()

                }
            }
        })
        task.resume()
    }

    func refreshControlAction(refreshControl: UIRefreshControl) {
        fetchData()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts?.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("PostTableViewCell") as! PostTableViewCell

        let photo = post["photos"]![0] as! NSDictionary
        let photoUrl = photo["original_size"]!["url"] as! String
        cell.postImageView.setImageWithURL(NSURL(string: photoUrl)!)
        return cell
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)
        let post = posts![(indexPath?.row)!]

        let photoDetailsViewController = segue.destinationViewController as! PhotoDetailsViewController
        let photo = post["photos"]![0] as! NSDictionary
        let photoUrl = photo["original_size"]!["url"] as! String

        photoDetailsViewController.imageUrl = photoUrl
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.posts.count
    }

    optional func tableView(_ tableView: UITableView,
                              viewForHeaderInSection section: Int) -> UIView?

    let CellIdentifier = "PostTableViewCell", HeaderViewIdentifier = "TableViewHeaderView"


    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier(HeaderViewIdentifier) as UITableViewHeaderFooterView
        header.textLabel.text = data[section][0]
        return header
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

}

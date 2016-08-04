//
//  PhotoDetailsViewController.swift
//  tumblr client
//
//  Created by phil_nachum on 8/3/16.
//  Copyright © 2016 phil_nachum. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController {

    var imageUrl: String!


    @IBOutlet weak var photoImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        photoImage.setImageWithURL(NSURL(string: imageUrl)!)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

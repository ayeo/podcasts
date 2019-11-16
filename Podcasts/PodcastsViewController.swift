//
//  PodcastsViewController.swift
//  Podcasts
//
//  Created by Michał Grabowski on 16/11/2019.
//  Copyright © 2019 Michał Grabowski. All rights reserved.
//

import Cocoa

class PodcastsViewController: NSViewController {
    
    @IBOutlet weak var urlField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        urlField.stringValue = "http://www.espn.com/espnradio/podcast/feeds/itunes/podCast?id=2406595"
    }
    
    @IBAction func addClicked(_ sender: NSButton) {
        let url = URL(string: urlField.stringValue)
        URLSession.shared.dataTask(with: url!) {
            (data: Data?, response: URLResponse?, error: Error?) in
            if (data != nil) {
                let parser = Parser()
                parser.getMetadata(data: data!)
            }
        }.resume()
        print("clicked")
    }
}

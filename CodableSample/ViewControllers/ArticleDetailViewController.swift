//
//  ArticleDetailViewController.swift
//  NYTimesArticle
//
//  Created by sajeev Raj on 4/4/19.
//  Copyright © 2019 Sajeev. All rights reserved.
//

import UIKit
import WebKit

class ArticleDetailViewController : UIViewController {
    
    @IBOutlet weak var detailsWebView: WKWebView?
    var url : URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = url {
            let request = URLRequest(url: url)
            detailsWebView?.load(request)
        }
    }
}

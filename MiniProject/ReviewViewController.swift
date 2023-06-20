//
//  ReviewViewController.swift
//  MiniProject
//
//  Created by 유민아 on 2023/06/18.
//

import UIKit
import WebKit

class ReviewViewController: UIViewController, WKNavigationDelegate {
    var movieId = ""
    var reviewUrl: String {
        return "https://www.imdb.com/title/\(movieId)/reviews/?ref_=tt_ov_rt"
    }
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet var webView: WKWebView!
    @IBOutlet var activitiIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        loadWebPage(reviewUrl)
    }
    
    func loadWebPage(_ url:String) {
        let myUrl = URL(string: url)
        let myRequest = URLRequest(url: myUrl!)
        webView.load(myRequest)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        activitiIndicator.startAnimating()
        activitiIndicator.isHidden = false
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activitiIndicator.stopAnimating()
        activitiIndicator.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activitiIndicator.startAnimating()
        activitiIndicator.isHidden = true
    }
}

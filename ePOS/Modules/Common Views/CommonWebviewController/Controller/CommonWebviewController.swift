//
//  CommonWebview.swift
//  webview
//
//  Created by Abhishek Shakya
//  Copyright © 2019 Abhishek Shakya. All rights reserved.
//
import UIKit
import WebKit
internal  class CommonWebViewController: UIViewController
{
@IBOutlet weak var navigationBarButton: UIBarButtonItem?
@IBOutlet weak var webView: WKWebView?
var loadUrl:NSURL?;
    
override func viewDidLoad()
{
    super.viewDidLoad()
    webView?.uiDelegate = self
    webView?.navigationDelegate=self
    if let unwrappedloadUrl = loadUrl {
        let urlRequest = URLRequest(url: unwrappedloadUrl as URL)
        self.webView?.load(urlRequest)
    } else {
         fatalError("Error: Load url failed.")
    }
    
}
    
override func didReceiveMemoryWarning()
{
    super.didReceiveMemoryWarning()
}
    
override func viewWillAppear(_ animated: Bool)
{
    super.viewWillAppear(animated)
    self.navigationItem.hidesBackButton = true
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
}
    
// MARK: View Did Appear
override func viewDidAppear(_ animated: Bool)
{
    super.viewDidAppear(animated)
    print("viewDidAppear")
}
    
override func viewWillDisappear(_ animated: Bool)
{
    super.viewWillDisappear(animated)
    print("viewWillDisappear")
}
    
override func viewDidDisappear(_ animated: Bool)
{
    super.viewDidDisappear(animated)
    print("viewDidDisappear")
}

// MARK:- Cancel Button
@IBAction func CancelButton(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
}

extension CommonWebViewController:WKUIDelegate , WKNavigationDelegate,UIWebViewDelegate
{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
    {
        navigationBarButton?.isEnabled=true;
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!)
    {

        navigationBarButton?.isEnabled=true;
    }
        
}

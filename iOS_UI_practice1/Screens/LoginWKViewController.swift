//
//  LoginWKViewController.swift
//  iOS_UI_practice1
//
//  Created by Alex on 13/01/2020.
//  Copyright © 2020 Alexey Kuznetsov. All rights reserved.
//

import UIKit
import WebKit
import SwiftKeychainWrapper

class LoginWKViewController: UIViewController {
    
    let apiID = "7308268"
    let session = URLSession(configuration: URLSessionConfiguration.default)
    let firstPage = "/blank.html"
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    var webView: WKWebView!
    var vkAPI = VKApi()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webViewConfig = WKWebViewConfiguration()
        webView = WKWebView(frame: view.frame, configuration: webViewConfig)
        webView.navigationDelegate = self
        view.addSubview(webView)
        view.bringSubviewToFront(loader)
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [URLQueryItem(name: "client_id", value: apiID),
                              URLQueryItem(name: "display", value: "mobile"),
                              URLQueryItem(name: "redirect_uri", value: urlComponents.host! + firstPage),
                              URLQueryItem(name: "scope", value: "271446"),
                              URLQueryItem(name: "response_type", value: "token"),
                              URLQueryItem(name: "v", value: Session.shared.actualAPIVersion)]
        
        let request = URLRequest(url: urlComponents.url!)
        
        loader.startAnimating()
        webView.load(request)
    }
    
    func login() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: "MainTab")
        nextViewController.transitioningDelegate = self
        
        self.present(nextViewController, animated: true, completion: nil)
    }
}

extension LoginWKViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let url = navigationResponse.response.url, url.path == firstPage,
            let fragment = url.fragment
        else {
            decisionHandler(.allow)
            loader.stopAnimating()
            return
        }
        
        let params = fragment.components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
            }
        
        if let token = params["access_token"],
            let userId = params["user_id"] {
            Session.shared.token = token
            Session.shared.userId = Int(userId)!
            KeychainWrapper.standard.set(token, forKey: "access_token")
            KeychainWrapper.standard.set(Session.shared.userId, forKey: "user_id")
        }
        
        decisionHandler(.cancel)
        loader.stopAnimating()
        
        login()
    }
}

extension LoginWKViewController : UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CardRotateTransition()
    }
}

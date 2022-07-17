//
//  ViewController.swift
//  Project4
//
//  Created by DongKyu Kim on 2022/07/17.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    // reference로 활용하기 위해 선언
    var webView: WKWebView!
    var progressView: UIProgressView!
    var websites = ["apple.com", "hackingwithswift.com"]
    
    override func loadView() {
        webView = WKWebView()
        
        // 현재 root view를 webView로 만들기 위해 Delegation 필요
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        // space를 만들어줌
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        // refresh button
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        // progress 상태를 Toolbar에 띄울 수 있음
        let progressButton = UIBarButtonItem(customView: progressView)
        
        toolbarItems = [progressButton, spacer, refresh]
        navigationController?.isToolbarHidden = false
        
        // addObserver(observer, 어떤 프로퍼티를 observe할 것인지, 어떤 값을 원하는지, observer에게 전달되는 arbitrary 값)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        let url = URL(string: "https://" + websites[0])!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
        
    }

    @objc func openTapped() {
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        
        for website in websites {
            
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    func openPage(action: UIAlertAction) {
        let url = URL(string: "https://" + action.title!)!
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    // 어떤 페이지에서 navigation이 시작되었는지, 어떤 방법을 통해 trigger가 되었는지를 체크
    // decisionHandler -> (closure) 사용자에게 "정말 이 페이지를 로드할 것인가?"라는 UI를 보여줌(allow / cancel)
    // @escaping -> closure가 현재 메소드를 벗어날 수 있다(나중에 사용될 수 있다)는 표현
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        if let host = url?.host {
            for website in websites {
                if host.contains(website) {
                    // website가 찾아지면, 긍정적인 응답을 보내 로딩 허용
                    decisionHandler(.allow)
                    // 메소드 바로 탈출
                    return
                }
            }
        }
        decisionHandler(.cancel)
    }
}


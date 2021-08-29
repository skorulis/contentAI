//
//  WebView.swift
//  Magic
//
//  Created by Alexander Skorulis on 28/8/21.
//

import SwiftUI
import WebKit

struct WebView: NSViewRepresentable {
    
    let urlString: String
    
    func makeNSView(context: Context) -> WKWebView {
        let webView = WKWebView()
        
        
        return webView
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {
        nsView.navigationDelegate = context.coordinator
        let url = URL(string: urlString)!
        nsView.load(URLRequest(url: url))
        nsView.allowsBackForwardNavigationGestures = true
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
}

extension WebView {
    
    final class Coordinator: NSObject, WKNavigationDelegate {
        
        var parent: WebView
        
        init(parent: WebView) {
            self.parent = parent
        }
        
        func webView(_ view: WKWebView, didFinish: WKNavigation!) {
            print("Finish navigation")
            let js = "document.documentElement.outerHTML.toString()"
            view.evaluateJavaScript(js,
                                       completionHandler: { (html: Any?, error: Error?) in
                print(html)
            })
        }
        
        func webView(_ view: WKWebView, didFail: WKNavigation!, withError: Error) {
            print("error \(withError)")
        }

        
        
    }
}

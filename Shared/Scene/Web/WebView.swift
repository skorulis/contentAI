//
//  WebView.swift
//  Magic
//
//  Created by Alexander Skorulis on 28/8/21.
//

import SwiftUI
import WebKit
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

#if canImport(UIKit)

struct WebView: UIViewRepresentable {
    
    let urlString: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }
    
    func updateUIView(_ nsView: WKWebView, context: Context) {
        nsView.navigationDelegate = context.coordinator
        let url = URL(string: urlString)!
        nsView.load(URLRequest(url: url))
        nsView.allowsBackForwardNavigationGestures = true
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
}

#else

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

#endif



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
                //print(html)
            })
        }
        
        func webView(_ view: WKWebView, didFail: WKNavigation!, withError: Error) {
            print("error \(withError)")
        }

        
        
    }
}

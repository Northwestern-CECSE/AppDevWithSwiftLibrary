//
//  WebView.swift
//  WebView
//
//  Created by Kevin McQuown on 4/26/21.
//

import SwiftUI
import WebKit

public struct SwiftUIWebView: UIViewRepresentable {
    
    public let url: URL?
    
    public func makeUIView(context: Context) -> some WKWebView {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let config  = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        return WKWebView(frame: .zero, configuration: config)
    }
    
    public func updateUIView(_ uiView: UIViewType, context: Context) {
        guard let myURL  = url else {
            return
        }
        let request = URLRequest(url: myURL)
        uiView.load(request)
    }
}

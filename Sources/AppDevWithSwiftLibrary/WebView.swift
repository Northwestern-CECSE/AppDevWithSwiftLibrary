//
//  WebView.swift
//  WebView
//
//  Created by Kevin McQuown on 4/26/21.
//

#if !os(watchOS)
import SwiftUI
import WebKit

public struct SwiftUIWebView: UIViewRepresentable {
    
    public let url: URL?
    
    public init(url: URL?) {
        self.url = url
    }
    
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

public extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

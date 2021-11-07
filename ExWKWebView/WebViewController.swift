//
//  WebViewController.swift
//  ExWKWebView
//
//  Created by 김종권 on 2021/11/05.
//

import UIKit
import WebKit

protocol WebViewDelegate: AnyObject {

}

class WebViewController: BaseViewController {
    weak var delegate: WebViewDelegate?
    var url: URL

    private var webView: WKWebView!

    private var headers: [String: String] {
        let bundleVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        var header = ["Content-Type": "application/json"]
        header["device-uuid"] = UUID().uuidString
        header["device-os-version"] = UIDevice.current.systemVersion
        header["device-device-manufacturer"] = "apple"
        header["version"] = bundleVersion
        return header
    }

    private var authCookie: HTTPCookie? {
        let cookie = HTTPCookie(properties: [
            .domain: "https://ios-development.tistory.com/",
            .path: "748",
            .name: "CID_AUTH",
            .value: "test-access-token",
            .maximumAge: 7200, // Cookie의 유효한 지속시간
            .secure: "TRUE"
        ])
        return cookie
    }

    init(url: URL, title: String) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("required init?(coder: NSCoder) is not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        loadWebPage()
        addSubviews()
        makeConstraints()
        addBottomToolBar()
    }

    private func setupWebView() {
        let configuration = WKWebViewConfiguration()
        if let authCookie = authCookie {
            let dataStore = WKWebsiteDataStore.nonPersistent()
            dataStore.httpCookieStore.setCookie(authCookie)
            configuration.websiteDataStore = dataStore
        }

        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.allowsBackForwardNavigationGestures = true
        webView.navigationDelegate = self
    }

    private func loadWebPage() {
        var urlRequest = URLRequest(url: url)
        headers.forEach { urlRequest.setValue($0.value, forHTTPHeaderField: $0.key) }
        webView.load(urlRequest)
    }

    private func addSubviews() {
        view.addSubview(webView)
    }

    private func makeConstraints() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    }

    override func didTapToolBarBackButton() {
        webView.goBack()
    }

    override func didTapToolBarForwardButton() {
        webView.goForward()
    }

}

// 페이지의 화면 전환 이벤트 수신
extension WebViewController: WKNavigationDelegate {
    /// WKWebView에서 다른곳으로 이동할때마다 호출되는 메소드 (didFinish와 짝꿍)
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("show loading indicator ...")
        // didFinish에 하지 않고 didCommit에 해야 페이지에 들어가면서 자연스럽게 활성화
        barBackButtonItem.isEnabled = webView.canGoBack
        barForwardButtonItem.isEnabled = webView.canGoForward
    }

    /// WKWebView에서 다른곳으로 이동된 후에 호출되는 메소드 (didCommit와 짝꿍)
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("hide loading indicator ...")
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        if let url = navigationAction.request.url, url.scheme == "mailto" || url.scheme == "tel" {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            // url이 mailto, tel인 경우, webView에서 열리지 않도록 .cancel
            decisionHandler(.cancel)
            return
        }

        // url이 네이티브에서 여는작업이 아닌 경우, webView에서 열리도록 .allow
        decisionHandler(.allow)
    }
}

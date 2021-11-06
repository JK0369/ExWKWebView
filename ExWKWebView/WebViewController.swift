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

    private lazy var webView: WKWebView = {
        let webview = WKWebView(frame: .zero)
        webview.allowsBackForwardNavigationGestures = true
        webview.navigationDelegate = self
        return webview
    }()

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
        addSubviews()
        makeConstraints()
        addBottomToolBar()
        loadWebPage()
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

    private func loadWebPage() {
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
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

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        // TODO: handleError(error)
    }

    // WebView로부터 딥링크 처리에 이용
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else { return }
        if url.scheme == "mailto" || url.scheme == "tel", UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }
}

// 페이지의 start, loading, finish, error와 같은 action 이벤트 수신 (Javascript interface 사용)
extension WebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        // TODO: message.body 값을 파싱하여 javascript interface action처리
    }
}

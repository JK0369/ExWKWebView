//
//  ViewController.swift
//  ExWKWebView
//
//  Created by 김종권 on 2021/11/05.
//

import UIKit

class ViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        showBackButton(isHide: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showBackButton(isHide: false)
    }

    @IBAction func didTapNextButton(_ sender: Any) {
        guard let url = URL(string: "https://ios-development.tistory.com/") else { return }
        let nextViewController = WebViewController(url: url, title: "웹 페이지 예제")
        navigationController?.pushViewController(nextViewController, animated: true)
    }
}

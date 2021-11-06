//
//  BaseViewController.swift
//  ExWKWebView
//
//  Created by 김종권 on 2021/11/05.
//

import UIKit

class BaseViewController: UIViewController {

    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(backButtonImage, for: .normal)
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()

    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(closeButtonImage, for: .normal)
        button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        return button
    }()

    private lazy var navigationTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        return label
    }()

    lazy var toolBarBackButton: UIButton = {
        let toolBarBackButton = UIButton()
        toolBarBackButton.setImage(backButtonImage, for: .normal)
        toolBarBackButton.addTarget(self, action: #selector(didTapToolBarBackButton), for: .touchUpInside)
        return toolBarBackButton
    }()

    lazy var toolBarTowardButton: UIButton = {
        let toolBarTowardButton = UIButton()
        toolBarTowardButton.setImage(backButtonImage, for: .normal)
        toolBarTowardButton.addTarget(self, action: #selector(didTapToolBarTowardButton), for: .touchUpInside)
        return toolBarBackButton
    }()

    lazy var navigationBackButtonImage: UIImage? = {
        return UIImage(systemName: "LeftBackButton")
    }()

    lazy var backButtonImage: UIImage? = {
        return UIImage(systemName: "chevron.left")
    }()

    lazy var closeButtonImage: UIImage? = {
        return UIImage(named: "CloseButton")
    }()

    lazy var towardButtonImage: UIImage? = {
        return UIImage(named: "chevron.right")
    }()

//    private lazy var bottomToolBar: UIToolbar = {
//        let bar = UIToolbar()
//        view.addSubview(bar)
//        bar.translatesAutoresizingMaskIntoConstraints = false
//        bar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        bar.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        bar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        bar.heightAnchor.constraint(equalToConstant: 44).isActive = true
//        return bar
//    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        if navigationController?.viewControllers.first == self {
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeButton)
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        }
    }

    @objc func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }

    @objc func didTapCloseButton() {
        dismiss(animated: true, completion: nil)
    }

    func showBackButton(isHide: Bool) {
        backButton.isHidden = isHide
        closeButton.isHidden = isHide
    }

    func addBottomToolBar() {
        let barBackButtonItem = UIBarButtonItem(customView: toolBarBackButton)
        let barTowardButtonItem = UIBarButtonItem(customView: toolBarTowardButton)

        // 주의: toolbarItems이나 setToolbarItems(_:animated:) 둘 중하나만 실행 시 표출 안되는 현상
        setToolbarItems([barBackButtonItem, barTowardButtonItem], animated: true)
        toolbarItems = [barBackButtonItem, barTowardButtonItem]
        navigationController?.isToolbarHidden = false
    }

    @objc func didTapToolBarBackButton() {
        // override this method
    }

    @objc func didTapToolBarTowardButton() {
        // override this method
    }
}

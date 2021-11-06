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

    private lazy var navigationBackButtonImage: UIImage? = {
        return UIImage(systemName: "LeftBackButton")
    }()

    private lazy var backButtonImage: UIImage? = {
        return UIImage(systemName: "chevron.left")
    }()

    private lazy var closeButtonImage: UIImage? = {
        return UIImage(named: "CloseButton")
    }()

    private lazy var towardButtonImage: UIImage? = {
        return UIImage(systemName: "chevron.right")
    }()

    lazy var barBackButtonItem: UIBarButtonItem = {
        // 주의: UIBarButtonItem을 생성할 때 CustomView로 button을 넣을경우 하나만 표출되므로 image로 넣어서 사용
        return UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(didTapToolBarBackButton))
    }()

    lazy var barTowardButtonItem: UIBarButtonItem = {
        // 주의: UIBarButtonItem을 생성할 때 CustomView로 button을 넣을경우 하나만 표출되므로 image로 넣어서 사용
        return UIBarButtonItem(image: towardButtonImage, style: .plain, target: self, action: #selector(didTapToolBarTowardButton))
    }()

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

    // MARK: - UIToolBar

    func addBottomToolBar() {
        let paddingButtonItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        paddingButtonItem.width = 24.0
        toolbarItems = [barBackButtonItem, paddingButtonItem, barTowardButtonItem]
        navigationController?.isToolbarHidden = false
    }

    @objc func didTapToolBarBackButton() {
        // override this method
    }

    @objc func didTapToolBarTowardButton() {
        // override this method
    }
}

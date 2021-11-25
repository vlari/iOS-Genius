//
//  MainViewController.swift
//  LyricsApp
//
//  Created by Obed Garcia on 14/11/21.
//

import UIKit

class MainViewController: UIViewController {
    private var logoImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "logo")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    private var textField: LTextField = {
        let textField = LTextField(placeHolder: "Search lyrics")
        return textField
    }()
    private var searchbutton: LButton = {
        let button = LButton(title: "Search")
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.theme.primary
        view.addSubview(logoImageView)
        view.addSubview(textField)
        view.addSubview(searchbutton)
        searchbutton.addTarget(self, action: #selector(pushResultList), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        textField.text = ""
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        let padding: CGFloat = 30
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 60),
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: (UIScreen.main.bounds.height - 200)/2)
        ])
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 16),
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            textField.heightAnchor.constraint(equalToConstant: 60)
        ])
        NSLayoutConstraint.activate([
            searchbutton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 16),
            searchbutton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            searchbutton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            searchbutton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
   
    @objc func pushResultList() {
        guard let text = textField.text,
              !text.isEmpty else {
            return
        }
        
        let lyricVC = LyricResultViewController()
        lyricVC.baseFilterText = text
        navigationController?.pushViewController(lyricVC, animated: true)
    }
}

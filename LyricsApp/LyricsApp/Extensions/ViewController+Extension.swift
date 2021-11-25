//
//  ViewController+Extensino.swift
//  LyricsApp
//
//  Created by Obed Garcia on 24/11/21.
//

import Foundation
import UIKit

extension UIViewController {
    func addDismissButton() {
        let dismissButton = UIBarButtonItem(image: UIImage(systemName: "xmark"),
                                            landscapeImagePhone: nil, style: .done,
                                            target: self,
                                            action: #selector(didTapCustomDismiss))
        navigationItem.leftBarButtonItem = dismissButton
    }
    
    @objc func didTapCustomDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
}

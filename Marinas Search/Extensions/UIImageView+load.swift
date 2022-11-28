//
//  UIImageView+load.swift
//  Marinas Search
//
//  Created by mattesona on 11/26/22.
//

import Foundation
import UIKit

/// UIImageView extension to load images into an UIImageView
/// sourche: https://www.hackingwithswift.com/example-code/uikit/how-to-load-a-remote-image-url-into-uiimageview
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                } else {
                    print("Unable to convert data to image. URL = \(url)")
                }
            } else {
                print("Unable to get data. URL = \(url)")
            }
        }
    }
}

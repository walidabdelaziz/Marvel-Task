//
//  Extensions.swift
//  Marvel Task
//
//  Created by Walid Ahmed on 14/09/2023.
//

import Foundation
import Kingfisher
import UIKit
extension UIImageView{
     func setImage(imageStr: String, placeholder: String? = nil) {
        let imageURL = URL(string: imageStr)
        self.kf.setImage(with: imageURL, placeholder: placeholder != nil ? UIImage(named: placeholder!) : nil) { result in
            switch result {
            case .success(let imageResult):
                // Set the image
                self.image = imageResult.image
            case .failure(let error):
                // Handle the error
                print("Error: \(error)")
                self.image = placeholder != nil ? UIImage(named: placeholder!) : nil
                self.contentMode = .scaleAspectFit
            }
        }
    }
}

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
    func setImage(with character: Character, placeholder: String? = nil) {
        if let imageData = character.cachedThumbnailData,
           let image = UIImage(data: imageData) {
            self.image = image
        }else {
            let imageURL = URL(string: "\(character.thumbnail?.path ?? "").\(character.thumbnail?.thumbnailExtension ?? "")")
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
}
extension UIView{
    func dropShadow(radius: CGFloat, opacity: Float = 0.3, offset: CGSize = CGSize(width: 1.5, height: 3)) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.rasterizationScale = UIScreen.main.scale
    }
}
extension UICollectionView{
    func setupCollectionViewLayout(cellWidthRatio: CGFloat, cellHeight: CGFloat, minimumInteritemSpacing: CGFloat = 0, minimumLineSpacing: CGFloat = 0, scrollDirection: UICollectionView.ScrollDirection = .horizontal, contentInsets: UIEdgeInsets = .zero) {
           
           let layout = UICollectionViewFlowLayout()
           layout.itemSize = CGSize(width: frame.width / cellWidthRatio, height: cellHeight)
           layout.scrollDirection = scrollDirection
           layout.minimumLineSpacing = minimumLineSpacing
           layout.minimumInteritemSpacing = minimumInteritemSpacing
           contentInset = contentInsets
           setCollectionViewLayout(layout, animated: false)
       }
}

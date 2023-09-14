//
//  SectionDataCell.swift
//  Marvel Task
//
//  Created by Walid Ahmed on 14/09/2023.
//

import UIKit
import RxSwift
import RxCocoa

class SectionDataCell: UICollectionViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    
    var sectionItem: SectionsItem? {
        didSet {
            guard let sectionItem = sectionItem else { return }
            titleLbl.text = sectionItem.name
            characterViewModel.getSectionImage(url: sectionItem.resourceURI ?? "")
            bindViewModel()
        }
    }
    var disposeBag = DisposeBag()
    var characterViewModel = CharactersViewModel()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    func bindViewModel() {
        // fetch item images
        characterViewModel.selectedCharacter.asObservable()
            .bind(onNext: {[weak self] (item) in
                guard let self = self else{return}
                self.img.setImage(with: item.thumbnail ?? Thumbnail())
        }).disposed(by: disposeBag)
    }
}

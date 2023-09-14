//
//  SectionsTVCell.swift
//  Marvel Task
//
//  Created by Walid Ahmed on 14/09/2023.
//

import UIKit
import RxSwift
import RxCocoa

class SectionsTVCell: UITableViewCell {

    @IBOutlet weak var itemsCV: UICollectionView!
    @IBOutlet weak var titleLbl: UILabel!
    
    var section: GenericSectionModel? {
        didSet {
            guard let section = section else { return }
            titleLbl.text = section.title.uppercased()
            characterViewModel.sectionItems.accept(section.items)
            bindViewModel()
        }
    }
    var disposeBag = DisposeBag()
    var characterViewModel = CharactersViewModel()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupCollectionViewUI()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    func setupCollectionViewUI() {
        itemsCV.register(UINib(nibName: "SectionDataCell", bundle: nil), forCellWithReuseIdentifier: "SectionDataCell")
        itemsCV.setupCollectionViewLayout(cellWidthRatio: 3.4, cellHeight: itemsCV.frame.height,scrollDirection: .horizontal, contentInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
    }
    func bindViewModel() {
        characterViewModel.sectionItems.asObservable()
        .bind(to: itemsCV.rx.items(cellIdentifier: "SectionDataCell", cellType: SectionDataCell.self)) {
                (index, item, cell) in
            cell.sectionItem = item
        }.disposed(by: disposeBag)
    }
}

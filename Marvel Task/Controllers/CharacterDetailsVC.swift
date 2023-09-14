//
//  CharacterDetailsVC.swift
//  Marvel Task
//
//  Created by Walid Ahmed on 14/09/2023.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class CharacterDetailsVC: UIViewController {

    let characterViewModel = CharactersViewModel()
    let disposeBag = DisposeBag()

    @IBOutlet weak var dataTV: UITableView!
    @IBOutlet weak var descriptionDetailsLbl: UILabel!
    @IBOutlet weak var nameDetailsLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var characterImg: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupSectionsTableView()
        bindViewModel()
        characterViewModel.getCharacterDetails()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let headerView = dataTV.tableHeaderView else {return}
        let size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        if headerView.frame.size.height != size.height {
            headerView.frame.size.height = size.height
            dataTV.tableHeaderView = headerView
            dataTV.layoutIfNeeded()
        }
    }
    func setupSectionsTableView(){
        dataTV.register(UINib(nibName: "SectionsTVCell", bundle: nil), forCellReuseIdentifier: "SectionsTVCell")
        dataTV.rowHeight = UITableView.automaticDimension
        if #available(iOS 15.0, *) {
            dataTV.sectionHeaderTopPadding = 0
        }
        dataTV.sectionHeaderHeight =  UITableView.automaticDimension
        dataTV.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 32, right: 0)
    }
    func bindViewModel(){        
        // handle back action
        backBtn.rx.tap
            .bind(onNext: {[weak self] in
                guard let self = self else{return}
                self.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
        
        // show loader
        characterViewModel.isLoading.asObservable()
            .bind { (loading) in
                loading ? IndicatorManager.showLoader(self.view) : IndicatorManager.hideLoader()
            }.disposed(by: disposeBag)
        
        // show error
        characterViewModel.error
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }).disposed(by: disposeBag)
        
        // fetch data
        characterViewModel.selectedCharacter.asObservable()
            .bind(onNext: {[weak self] (selectedCharacter) in
                guard let self = self else{return}
                self.fetchData(selectedCharacter: selectedCharacter)
            }).disposed(by: disposeBag)
        
        // Bind the combinedSections property to the collection view
        
        characterViewModel.combinedSections.asObservable()
            .bind(to: dataTV.rx.items) {
                (tableView, row, item) -> UITableViewCell in
                let cell = tableView.dequeueReusableCell(withIdentifier: "SectionsTVCell", for: IndexPath(row: row, section: 0)) as! SectionsTVCell
                cell.selectionStyle = .none
                cell.section = item
                return cell
            }.disposed(by: disposeBag)
    }
    func fetchData(selectedCharacter: Character){
        nameDetailsLbl.text = selectedCharacter.name
        descriptionDetailsLbl.text = selectedCharacter.description?.isEmpty == true || selectedCharacter.description == "" ? "N/A" : selectedCharacter.description
        characterImg.setImage(with: selectedCharacter)
    }
}

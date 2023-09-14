//
//  CharactersVC.swift
//  Marvel Task
//
//  Created by Walid Ahmed on 14/09/2023.
//

import UIKit
import RxCocoa
import RxSwift

class CharactersVC: UIViewController {

    let charactersViewModel = CharactersViewModel()
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var charactersTV: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTableView()
        bindViewModel()
        charactersViewModel.getCharacters()
    }

    func setupTableView(){
        charactersTV.register(UINib(nibName: "CharactersTVCell", bundle: nil), forCellReuseIdentifier: "CharactersTVCell")
        charactersTV.estimatedRowHeight = UITableView.automaticDimension
        charactersTV.rowHeight = 200
    }
    func bindViewModel(){
        charactersViewModel.characters
            .bind(to: charactersTV.rx.items(cellIdentifier: "CharactersTVCell", cellType: CharactersTVCell.self)) { row, character, cell in
                cell.selectionStyle = .none
                cell.character = character
            }.disposed(by: disposeBag)
        
        // show loader
        charactersViewModel.isLoading.asObservable()
            .bind { (loading) in
                loading ? IndicatorManager.showLoader(self.view) : IndicatorManager.hideLoader()
            }.disposed(by: disposeBag)
        
        // show error
        charactersViewModel.error
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }).disposed(by: disposeBag)
            
       // handle selection in tableview
        Observable
            .zip(charactersTV.rx.itemSelected, charactersTV.rx.modelSelected(Character.self))
            .bind { [unowned self] indexPath, character in
                self.naviagateToDetailsScreen(character: character)
            }.disposed(by: disposeBag)
        
        if ReachabilityManager.shared.currentNetworkStatus() != .notReachable{
            // handle next page trigger
            charactersViewModel.bindLoadNextPageTrigger()

            // Load the next page when reaching the end
            charactersTV.rx.willDisplayCell
                .subscribe(onNext: { [weak self] cell, indexPath in
                    guard let self = self else { return }
                    let lastElement = self.charactersViewModel.characters.value.count - 4
                    if indexPath.row == lastElement {
                        self.charactersViewModel.loadNextPageTrigger.onNext(())
                    }
                }).disposed(by: disposeBag)
        }
    }
    func naviagateToDetailsScreen(character: ControlEvent<Character>.Element){
        let storyboard = UIStoryboard(name: "Characters", bundle: nil)
        let CharacterDetailsVC = storyboard.instantiateViewController(withIdentifier: "CharacterDetailsVC") as! CharacterDetailsVC
        CharacterDetailsVC.characterViewModel.selectedCharacter.accept(character)
        navigationController?.pushViewController(CharacterDetailsVC, animated: true)
    }
}

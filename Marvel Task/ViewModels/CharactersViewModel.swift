//
//  CharactersViewModel.swift
//  Marvel Task
//
//  Created by Walid Ahmed on 14/09/2023.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
import SwiftyJSON

class CharactersViewModel {

    private let serialQueue = DispatchQueue(label: "com.Marvel-Task.serialQueue")
    let disposeBag = DisposeBag()
    var currentPage = 1
    let characters = BehaviorRelay<[Character]>(value: [])
    let isSuccess = BehaviorRelay<Bool>(value: false)
    let isLoading = BehaviorRelay<Bool>(value: false)
    let error = PublishSubject<Error>()
    let loadNextPageTrigger = PublishSubject<Void>()


    func getCharacters() {
        guard !isLoading.value else { return }
        isLoading.accept(true)
        NetworkManager.shared.request("\(Consts.CHARACTERS)?offset=\(currentPage)&limit=20", encoding: URLEncoding.default) { [weak self] (result: Result<CharactersModel>, statusCode) in
            guard let self = self else { return }

            self.serialQueue.sync {
                self.isLoading.accept(false)

                switch result {
                case .success(let response):
                    self.currentPage += 1
                    self.characters.accept((self.characters.value) + (response.data?.results ?? []))
                case .failure(let error):
                    self.error.onNext(error)
                }
            }
        }
    }
    func bindLoadNextPageTrigger() {
        loadNextPageTrigger
            .subscribe(onNext: { [weak self] in
                self?.getCharacters()
            }).disposed(by: disposeBag)
    }
}

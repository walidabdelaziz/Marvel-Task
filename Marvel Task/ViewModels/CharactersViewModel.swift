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
    var offset = 0
    let characters = BehaviorRelay<[Character]>(value: [])
    let isSuccess = BehaviorRelay<Bool>(value: false)
    let isLoading = BehaviorRelay<Bool>(value: false)
    let error = PublishSubject<Error>()
    let loadNextPageTrigger = PublishSubject<Void>()
    let selectedCharacter = BehaviorRelay<Character>(value: Character())
    lazy var combinedSections: Observable<[GenericSectionModel]> = {
        return selectedCharacter
            .map { character -> [GenericSectionModel] in
                guard let comicsItems = character.comics?.items, !comicsItems.isEmpty else {
                    return []
                }
                guard let seriesItems = character.series?.items, !seriesItems.isEmpty else {
                    return []
                }
                var sections: [GenericSectionModel] = []
                sections.append(GenericSectionModel(title: "Comics", items: comicsItems))
                sections.append(GenericSectionModel(title: "Series", items: seriesItems))
                return sections
            }
    }()
    let sectionItems = BehaviorRelay<[SectionsItem]>(value: [])
    
    func getCachedCharacters(){
        characters.accept(CachingManager.getCachedCharacters())
        isLoading.accept(false)
        return
    }
    func getCharacters() {
        guard !isLoading.value else { return }
        isLoading.accept(true)
        
        if ReachabilityManager.shared.currentNetworkStatus() == .notReachable{
            getCachedCharacters()
        }
        NetworkManager.shared.request("\(Consts.CHARACTERS)?offset=\(offset)&limit=20", encoding: URLEncoding.default) { [weak self] (result: Result<CharactersModel>, statusCode) in
            guard let self = self else { return }
            self.serialQueue.sync {
                self.isLoading.accept(false)
                switch result {
                case .success(let response):
                    self.offset += 20
                    let allCharacters = (self.characters.value) + (response.data?.results ?? [])
                    self.characters.accept(allCharacters)
                    CachingManager.cacheCharactersData(characters: allCharacters)
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
    func getCharacterDetails() {
        guard !isLoading.value else { return }
        isLoading.accept(true)
        NetworkManager.shared.request("\(Consts.CHARACTERS)/\(selectedCharacter.value.id ?? 0)", encoding: URLEncoding.default) { [weak self] (result: Result<CharactersModel>, statusCode) in
            guard let self = self else { return }
            self.serialQueue.sync {
                self.isLoading.accept(false)
                switch result {
                case .success(let response):
                    if let character = response.data?.results?.first {
                        self.selectedCharacter.accept(character)
                    } 
                case .failure(let error):
                    self.error.onNext(error)
                }
            }
        }
    }
    func getSectionImage(url: String) {
        guard !isLoading.value else { return }
        isLoading.accept(true)
        NetworkManager.shared.request(url, encoding: URLEncoding.default) { [weak self] (result: Result<CharactersModel>, statusCode) in
            guard let self = self else { return }
            self.serialQueue.sync {
                self.isLoading.accept(false)
                switch result {
                case .success(let response):
                    if let character = response.data?.results?.first {
                        self.selectedCharacter.accept(character)
                    }
                case .failure(let error):
                    self.error.onNext(error)
                }
            }
        }
    }
}

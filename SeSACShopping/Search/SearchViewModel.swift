//
//  SearchViewModel.swift
//  SeSACShopping
//
//  Created by SangRae Kim on 2/26/24.
//

import Foundation

class SearchViewModel {
    
    let repository = RealmRepository()
    let recommendation = Recommendation()
    var recList: [String] = []
    
    var nickname = ""
    
    var inputViewDidLoad: Observable<Void?> = Observable(nil)
    var inputAllEraseButtonTrigger: Observable<Void?> = Observable(nil)
    var inputCellEraseButton: Observable<Int?> = Observable(nil)
    var inputSearchText: Observable<String?> = Observable(nil)
    
    var outputViewState = Observable(false)
    var searchList: Observable<[SearchList]> = Observable([])
    
    init() {
        inputViewDidLoad.bind { _ in self.fetch() }
        inputSearchText.bind { text in self.appendSearchList(text) }
        inputAllEraseButtonTrigger.bind { value in self.allErase(value) }
        inputCellEraseButton.bind { value in self.cellErase(value) }
    }
    
    private func fetch() {
        searchList.value = repository.readAll(SearchList.self)
        recList = recommendation.returnShuffledList
        nickname = repository.readUser().nickname!
        stateChange()
    }
    
    private func appendSearchList(_ text: String?) {
        guard let text else { return }
        repository.appendSearchList(text)
        searchList.value = repository.readAll(SearchList.self).reversed()
        stateChange()
    }
    
    private func allErase(_ value: Void?) {
        guard let _ = value else { return }
        repository.deleteAllSearchList()
        searchList.value = repository.readAll(SearchList.self)
        stateChange()
    }
    
    private func cellErase(_ value: Int?) {
        guard let value else { return }

        repository.deleteSearchList(searchList.value[value])
        searchList.value = repository.readAll(SearchList.self)
        stateChange()
    }
    
    private func stateChange() {
        outputViewState.value = searchList.value.count > 0 ? true : false
    }
}

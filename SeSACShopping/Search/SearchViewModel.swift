//
//  SearchViewModel.swift
//  SeSACShopping
//
//  Created by SangRae Kim on 2/26/24.
//

import Foundation
import RealmSwift

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
    var searchList: Observable<Results<SearchList>?> = Observable(nil)
    
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
    }
    
    private func appendSearchList(_ text: String?) {
        guard let text else { return }
        repository.appendSearchList(text)
        searchList.value = repository.readAll(SearchList.self)
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
        guard let searchListValue = searchList.value else { return }

        repository.deleteSearchList(searchListValue[value])
        searchList.value = repository.readAll(SearchList.self)
        stateChange()
    }
    
    private func stateChange() {
        guard let searchListValue = searchList.value else {
            print(#function)
            outputViewState.value = false
            return
        }
        outputViewState.value = searchListValue.count > 0 ? true : false
    }
}

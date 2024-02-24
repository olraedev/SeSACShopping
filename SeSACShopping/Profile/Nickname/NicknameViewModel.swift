//
//  NicknameViewModel.swift
//  SeSACShopping
//
//  Created by SangRae Kim on 2/24/24.
//

import Foundation

class NicknameViewModel {
    
    var inputNicknameText = Observable("")
    var outputState = Observable(NicknameState.available)
    
    init() {
        inputNicknameText.bind { value in
            self.validation()
        }
    }
    
    func validation() {
        let text = inputNicknameText.value
        
        do {
            let _ = try isCheck(text)
            outputState.value = .available
        } catch {
            switch error {
            case NicknameError.special: outputState.value = .special
            case NicknameError.number: outputState.value = .number
            case NicknameError.length: outputState.value = .length
            case NicknameError.space: outputState.value = .space
            default:
                print("예상치 못한 에러")
            }
        }
    }
    
    func isCheck(_ text: String) throws -> Bool {
        if text.contains(" ") {
            throw NicknameError.space
        }
        // @, #, $, % 특수문자가 들어 있을 경우
        if text.contains("@") || text.contains("#") || text.contains("$") || text.contains("%") {
            throw NicknameError.special
        }
        // 숫자가 들어 있을 경우
        if text.contains("0") || text.contains("1") || text.contains("2") || text.contains("3") || text.contains("4") || text.contains("5") || text.contains("6") || text.contains("7") || text.contains("8") || text.contains("9") {
            throw NicknameError.number
        }
        // 2글자 이상 10글자 미만이 아닐 경우
        if text.count < 2 || text.count >= 10 {
            throw NicknameError.length
        }
        
        return true
    }
}

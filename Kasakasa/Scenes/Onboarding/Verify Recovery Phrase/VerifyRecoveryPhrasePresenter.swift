//
//  VerifyRecoveryPhrasePresenter.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-18.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

class VerifyRecoveryPhrasePresenter: BasePresenter {
    weak var view: VerifyRecoveryPhraseView?
    private let underscore = "______"

    private var originalPhrase: String = ""

    func setRecoveryPhrase(_ phrase: String) {
        originalPhrase = phrase
    }

    func removeWords()  {
        var wordList = originalPhrase.components(separatedBy: " ")
        let count = wordList.count
        let firstIndex = Int.random(in: 0..<count / 2)
        let secondIndex = Int.random(in: count / 2 ..< count-1)
        wordList[firstIndex] = underscore
        wordList[secondIndex] = underscore
        let modifiedPhrase = wordList.joined(separator: " ")
        view?.onWordsRemoved(phrase: modifiedPhrase, firstIndex: firstIndex, secondIndex: secondIndex)
    }

    func verifyRecoveryPhrase(_ phrase: String, word1: String, word2: String) {
        var wordList = phrase.components(separatedBy: " ")
        let firstIndex = wordList.firstIndex(of: underscore)
        let lastIndex = wordList.lastIndex(of: underscore)
        if let firstIndex = firstIndex, let lastIndex = lastIndex,
            (0..<wordList.count).contains(firstIndex), (0..<wordList.count).contains(lastIndex), firstIndex < lastIndex {
            wordList[firstIndex] = word1
            wordList[lastIndex] = word2
            let phraseToVerify = wordList.joined(separator: " ")
            if phraseToVerify == originalPhrase {
                view?.onPhraseVerified()
            } else {
                view?.onVerificationError()
            }
        } else {
            view?.onVerificationError()
        }
    }
}


//
//  Web3Bridge.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-18.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation
import web3swift

class Web3Bridge {

    func generateMnemonic() throws -> Mnemonics {
        var mnemonics: Mnemonics?
        repeat {
            mnemonics = Mnemonics(entropySize: .b128)
        } while (mnemonics != nil && !isValidSeedPhrase(mnemonics!.string))

        let keystore = try! BIP32Keystore(mnemonics: mnemonics!)
        self.setDefaultKeystore(keystore)
        return mnemonics!
    }

    func generateBip39Wallet(password: String, path: String) throws -> Mnemonics? {
        let mnemonics = Mnemonics()
        let keystore = try! BIP32Keystore(mnemonics: mnemonics, password: password, prefixPath: path)
        self.setDefaultKeystore(keystore)
        return mnemonics
    }

    func setDefaultKeystore(_ keystore: BIP32Keystore) {
        let keystoreManager = KeystoreManager([keystore])
        Web3.default.keystoreManager = keystoreManager
    }

    func isValidSeedPhrase(_ phrase: String, language: BIP39Language = .english) -> Bool {
        let splits = phrase.split(separator: Character(language.separator))
        if splits.count != 12 {
            return false
        }
        let set = Set(splits)
        if set.count != splits.count {
            return false
        }
        for word in splits {
            if !language.words.contains(String(word)) {
                return false
            }
        }
        return true
    }
}

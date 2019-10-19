//
//  PassphrasedCommand.swift
//  Basic
//
//  Created by Thibault Defeyter on 23/02/2019.
//

import Foundation


/// Protocol to share passphrase prompt across commands
protocol PassphrasedCommand {
    func getPassphrase() -> String
}


/// Default PassphrasedCommand implementation
extension PassphrasedCommand {
    func getPassphrase() -> String {

        // get the password from prompt
        guard let passphrase = getpass("Enter passphrase: ") else {
            return ""
        }

        // make sure we can cast it to String
        guard let passphraseStr = String.init(validatingUTF8: passphrase) else {
            return ""
        }

        // return the entered value
        return passphraseStr
    }
}

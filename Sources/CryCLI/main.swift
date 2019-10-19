//
//  main.swift
//  CryCLI
//
//  Created by Thibault Defeyter on 17/02/2019.
//

import Foundation
import CryCommands

let rooter = CommandRooter()

do {
    try rooter.run()
} catch {
    print("Whoops! An error occurred: \(error)")
}

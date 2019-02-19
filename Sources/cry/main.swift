//
//  main.swift
// cry
//
//  Created by Thibault Defeyter on 17/02/2019.
//

import Foundation
import Basic
import Utility

var rooter = CommandRooter()
rooter.register(EncryptCommand.self)
rooter.register(DecryptCommand.self)
rooter.register(ReadCommand.self, isDefault: true)
rooter.process(Array(ProcessInfo.processInfo.arguments.dropFirst()))


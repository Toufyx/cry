//
//  Command.swift
//  cry
//
//  Created by Thibault Defeyter on 17/02/2019.
//

import Foundation
import Basic
import Utility


protocol Command {
    var command: String { get }
    var usage: String { get }
    var overview: String { get }
    
    init()
    func run(with arguments: [String]) throws
}

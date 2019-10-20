//
//  Command.swift
//  CryCommands
//
//  Created by Thibault Defeyter on 20/10/2019.
//


/// Common Interface for CLI entrypoint
protocol Command {
    func run(argc: Int, argv: [String]) throws
}

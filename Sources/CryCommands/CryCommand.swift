//
//  CryCommand.swift
//  CryCommands
//
//  Created by Thibault Defeyter on 20/10/2019.
//


// Main class to be run in script
public class CryCommand: Command {

    public init() {}

    public func run(argc: Int, argv: [String]) throws {
        print("hello world")
    }
}

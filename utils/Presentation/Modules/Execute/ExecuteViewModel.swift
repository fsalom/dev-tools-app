//
//  ExecuteViewModel.swift
//  utils
//
//  Created by Fernando Salom Carratala on 23/1/23.
//

import Foundation

extension ExecuteView {
    @MainActor class ExecuteViewModel: ObservableObject {
        @Published var isLoading: Bool = false
        @Published var message: String = ""

        init() { }

        func speak() {
            let executableURL = URL(fileURLWithPath: "/usr/bin/say")
            #if os(macOS)
            try! Process.run(executableURL,
                             arguments: [self.message],
                             terminationHandler: nil)
            #endif
        }

        func ruby() {
            #if os(macOS)
            if let file = Bundle.main.url(forResource: "addFileToXcode", withExtension: "rb") {
              let task = Process()

              task.launchPath = "/usr/bin/env"
              task.arguments = ["ruby", file.path, "arg1"]

              let pipe = Pipe()
              task.standardOutput = pipe
              task.launch()

              let data:Data = pipe.fileHandleForReading.readDataToEndOfFile()
              if let output = String(data: data, encoding: String.Encoding.utf8) {
                print(output)
              }
            }
            #endif
        }

        func executeXcode() {
            print(shell("find /Users -type f -name \"*.xcodeproj\""))
            print(shell("ls -la"))
        }

        func shell(_ command: String) -> String {
            #if os(macOS)
            let task = Process()
            let pipe = Pipe()

            task.standardOutput = pipe
            task.standardError = pipe
            task.arguments = ["-c", command]
            task.launchPath = "/bin/zsh"
            task.standardInput = nil
            task.launch()

            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data: data, encoding: .utf8)!
            return output
            #else
            return ""
            #endif
        }
    }
}

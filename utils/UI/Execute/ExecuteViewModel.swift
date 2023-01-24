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

        init() { }

        /*
        func execute() {
            shell("ls")
            //shell("xcodebuild", "-workspace", "myApp.xcworkspace")
        }

        func shell(_ command: String) -> String {
            #if targetEnvironment(macCatalyst)
            let task = Process()
            let pipe = Pipe()
            task.standardOutput = pipe
            task.standardError = pipe
            task.arguments = ["-c", command]
            task.standardInput = nil
            task.resume()
            task.start
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data: data, encoding: .utf8)!
            return output
            #else
            print("Your regular code")
            return ""
            #endif

        }
         */
    }
}

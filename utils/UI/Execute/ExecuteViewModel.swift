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

        func execute() {
            let executableURL = URL(fileURLWithPath:"/Users/myname/Desktop/run.sh")
                                    try! Process.run(executableURL,
                                                     arguments: [],
                                                     terminationHandler: { _ in  })
        }
    }
}


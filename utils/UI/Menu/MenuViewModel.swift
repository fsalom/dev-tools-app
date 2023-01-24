//
//  MenuViewModel.swift
//  utils
//
//  Created by Fernando Salom Carratala on 9/1/23.
//

import Foundation

final class MenuViewModel: ObservableObject {
    @Published public var menuOptions = [Menu]()

    var url: String = ""

    init() {

    }

    func load() {
        menuOptions = [Menu(name: "JSON Parser", destination: JsonParserView()),
                       Menu(name: "Generate", destination: JsonEditorView()),
                       Menu(name: "Execute", destination: ExecuteView()),
                       Menu(name: "Date Formatter", destination: DateFormatterView())]
    }
}

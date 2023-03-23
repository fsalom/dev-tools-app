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
        menuOptions = [Menu(name: "Llamada API", icon: "phone.arrow.right", destination: JsonParserView()),
                       Menu(name: "Parseador JSON", icon: "newspaper", destination: JsonEditorView()),
                       Menu(name: "Ejecutar scripts", icon: "scroll", destination: ExecuteView()),
                       Menu(name: "Formateador de fecha", icon: "calendar.badge.clock", destination: DateFormatterView()),
                       Menu(name: "Firebase tester", icon: "phone.arrow.right", destination: FirebaseTesterView()),
                       Menu(name: "ChatGPT", icon: "phone.arrow.right", destination: ChatView())]
    }
}

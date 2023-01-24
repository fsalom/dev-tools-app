//
//  DateFormatterViewModel.swift
//  utils
//
//  Created by Fernando Salom Carratala on 24/1/23.
//

import Foundation

extension DateFormatterView {
    @MainActor class DateFormatterViewModel: ObservableObject {
        @Published var isLoading: Bool = false

        init() {
        }

    }
}

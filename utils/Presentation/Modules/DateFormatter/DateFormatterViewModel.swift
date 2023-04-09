//
//  DateFormatterViewModel.swift
//  utils
//
//  Created by Fernando Salom Carratala on 24/1/23.
//

import Foundation

extension DateFormatterView {
    @MainActor class DateFormatterViewModel: ObservableObject {
        @Published var date: String = "" {
            didSet{
                calculateDate(with: date, and: formatDate)
            }
        }
        @Published var formatDate: String = "" {
            didSet{
                calculateDate(with: date, and: formatDate)
            }
        }
        @Published var resultDate: String = ""
        @Published var resultFormat: String = ""

        init() {
        }

        func calculateDate(with date: String, and format: String) {
            if date.isEmpty || format.isEmpty {
                resultFormat = "not match"
                resultDate = ""
                return
            }
            let dateFormatter = DateFormatter()
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = format

            if let intDate = Int(date) {
                let timeInterval = TimeInterval(intDate)
                let date = Date(timeIntervalSince1970: timeInterval)
                resultDate = "⏰ " + dateFormatter.string(from: date)
            }
            else if let floatDate = Float(date) {
                let timeInterval = TimeInterval(floatDate)
                let date = Date(timeIntervalSince1970: timeInterval)
                resultDate = "⏰ " + dateFormatter.string(from: date)
            } else {
                if let _ = dateFormatter.date(from: date) {
                    resultDate = "Formato correcto ✅ "
                    resultFormat = "match"
                } else {
                    resultDate = ""
                    resultFormat = "not match"
                }
            }
        }
    }
}

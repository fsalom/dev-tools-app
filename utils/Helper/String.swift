//
//  String.swift
//  utils
//
//  Created by Fernando Salom Carratala on 16/1/23.
//

import Foundation
import UIKit

extension String {
    func canOpenUrl() -> Bool {        
        let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
        return predicate.evaluate(with: self)
    }
}

//
//  TextEditor.swift
//  utils
//
//  Created by Fernando Salom Carratala on 7/2/23.
//

import Foundation
#if os(macOS)
import SwiftUI

extension NSTextView {
  open override var frame: CGRect {
    didSet {
      backgroundColor = .clear
      drawsBackground = true
    }
  }
}
#endif

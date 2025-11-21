//
//  SxnnyStackSpacer.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 23/05/25.
//

import SwiftUI

public struct SxnnyStackSpacer: View {
    private let minLength: CGFloat?
    private let maxLength: CGFloat?
    private let animated: Bool

    public init(minLength: CGFloat? = nil, maxLength: CGFloat? = nil, animated: Bool = false) {
        self.minLength = minLength
        self.maxLength = maxLength
        self.animated = animated
    }

    public var body: some View {
        Spacer(minLength: minLength)
            .frame(minHeight: minLength, maxHeight: maxLength)
            .animation(animated ? .default : nil, value: UUID()) // Animar en cambio
    }
}

//
//  SxnnyResponsiveView.swift
//  SxnnyUI
//
//  Created by Sxnnyside Project on 23/05/25.
//

import SwiftUI

public struct SxnnyResponsiveView<Small: View, Medium: View, Large: View>: View {
    private let small: () -> Small
    private let medium: () -> Medium
    private let large: () -> Large

    public init(
        @ViewBuilder small: @escaping () -> Small,
        @ViewBuilder medium: @escaping () -> Medium,
        @ViewBuilder large: @escaping () -> Large
    ) {
        self.small = small
        self.medium = medium
        self.large = large
    }

    public var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            Group {
                if width < 400 {
                    small()
                } else if width < 800 {
                    medium()
                } else {
                    large()
                }
            }
        }
    }
}

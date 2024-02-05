//
//  MarqueeText.swift
//

import SwiftUI

struct MarqueeText: View {

    // MARK: - Property Wrappers

    @State private var animate: Bool = false

    // MARK: - Internal Properties

    var text: String
    var font: UIFont = .boldSystemFont(ofSize: 25)
    var leftFade: CGFloat = 5
    var rightFade: CGFloat = 5
    var startDelay: Double = 2
    var alignment: Alignment = .center

    var isCompact: Bool = false

    // MARK: - Body 

    var body: some View {
        let stringWidth = text.widthOfString(usingFont: font)
        let stringHeight = text.heightOfString(usingFont: font)

        let animation: Animation = .linear(duration: Double(stringWidth) / 30)
            .delay(startDelay)
            .repeatForever(autoreverses: false)

        let nullAnimation: Animation = .linear(duration: 0)

        ZStack {
            GeometryReader { geo in
                if stringWidth > geo.size.width {
                    Group {
                        Text(self.text)
                            .lineLimit(1)
                            .font(.init(font))
                            .offset(x: self.animate ? -stringWidth - stringHeight * 2 : 0)
                            .animation(self.animate ? animation : nullAnimation, value: self.animate)
                            .onAppear {
                                DispatchQueue.main.async {
                                    self.animate = geo.size.width < stringWidth
                                }
                            }
                            .fixedSize(horizontal: true, vertical: false)
                            .frame(
                                minWidth: 0,
                                maxWidth: .infinity,
                                minHeight: 0,
                                maxHeight: .infinity,
                                alignment: .topLeading
                            )

                        Text(self.text)
                            .lineLimit(1)
                            .font(.init(font))
                            .offset(x: self.animate ? 0 : stringWidth + stringHeight * 2)
                            .animation(self.animate ? animation : nullAnimation, value: self.animate)
                            .onAppear {
                                DispatchQueue.main.async {
                                    self.animate = geo.size.width < stringWidth
                                }
                            }
                            .fixedSize(horizontal: true, vertical: false)
                            .frame(
                                minWidth: 0,
                                maxWidth: .infinity,
                                minHeight: 0,
                                maxHeight: .infinity,
                                alignment: .topLeading
                            )
                    }
                    .onChange(of: self.text) { text in
                        self.animate = geo.size.width < stringWidth
                    }
                    .offset(x: leftFade)
                    .mask {
                        HStack(spacing: 0) {
                            Rectangle()
                                .frame(width: 2)
                                .opacity(0)

                            LinearGradient(
                                gradient: Gradient(colors: [Color.black.opacity(0), Color.black]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            .frame(width: leftFade)

                            LinearGradient(
                                gradient: Gradient(colors: [Color.black, Color.black]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )

                            LinearGradient(
                                gradient: Gradient(colors: [Color.black, Color.black.opacity(0)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            .frame(width: rightFade)

                            Rectangle()
                                .frame(width: 2)
                                .opacity(0)
                        }
                    }
                    .frame(width: geo.size.width + leftFade)
                    .offset(x: -leftFade)
                } else {
                    Text(self.text)
                        .font(.init(font))
                        .onChange(of: self.text) { text in
                            self.animate = geo.size.width < stringWidth
                        }
                        .frame(
                            minWidth: 0,
                            maxWidth: .infinity,
                            minHeight: 0,
                            maxHeight: .infinity,
                            alignment: alignment
                        )
                }
            }
        }
        .frame(height: stringHeight)
        .frame(maxWidth: isCompact ? stringWidth : nil)
        .onDisappear { self.animate = false }

    }
}

//
//  WXMAlertView.swift
//  wxm-ios
//
//  Created by Pantelis Giazitsis on 23/8/23.
//

import SwiftUI
import Toolkit

struct WXMAlertConfiguration {
    let title: String
    let text: AttributedString
    var buttonsLayout: Layout = .vertical
    var secondaryButtons: [ActionButton] = []
    let primaryButtons: [ActionButton]

    enum Layout {
        case horizontal
        case vertical
    }

    struct ActionButton: Identifiable {
        var id: String {
            title
        }

        let title: String
        let action: VoidCallback
    }
}

struct WXMAlertView<V: View>: View {
    @Binding var show: Bool
    let configuration: WXMAlertConfiguration
    let bottomView: () -> V

    var body: some View {
        GeometryReader { proxy in
            VStack {
                Spacer()

                HStack {
                    Spacer()

                    alertView
                        .frame(width: 0.8 * proxy.size.width)

                    Spacer()
                }

                Spacer()
            }
        }
    }
}

private extension WXMAlertView {

    @ViewBuilder
    var alertView: some View {
        VStack(spacing: CGFloat(.smallSpacing)) {
            HStack {
                Text(configuration.title)
                    .foregroundColor(Color(colorEnum: .darkestBlue))
                    .font(.system(size: CGFloat(.titleFontSize), weight: .bold))

                Spacer()

                Button {
                    show = false
                } label: {
                    Image(asset: .closeIcon)
                        .renderingMode(.template)
                        .foregroundColor(Color(colorEnum: .text))
                }

            }

            HStack {
                Text(configuration.text)
                    .foregroundColor(Color(colorEnum: .text))
                    .font(.system(size: CGFloat(.normalFontSize)))
                Spacer()
            }

            buttonsView

            bottomView()
        }
        .WXMCardStyle()
    }

    @ViewBuilder
    var buttonsView: some View {
        buttonsContainer {
            Group {
                ForEach(configuration.secondaryButtons) { button in
                    Button {
                        show = false
                        button.action()
                    } label: {
                        Text(button.title)
                    }
                    .buttonStyle(WXMButtonStyle())
                }

                ForEach(configuration.primaryButtons) { button in
                    Button {
                        show = false
                        button.action()
                    } label: {
                        Text(button.title)
                    }
                    .buttonStyle(WXMButtonStyle.filled())
                }
            }
        }
    }

    @ViewBuilder
    func buttonsContainer<V: View>(content: () -> V) -> some View {
        switch configuration.buttonsLayout {
            case .horizontal:
                HStack {
                    content()
                }
            case .vertical:
                VStack {
                    content()
                }
        }

    }
}

struct WXMAlertView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.red

            WXMAlertView(show: .constant(true),
                         configuration: .init(
                            title: "Add to favorites",
                            text: "Login to add **Perky Magenta Clothes** to your favorites and see historical & forecast data.".attributedMarkdown!,
                            secondaryButtons: [.init(title: "Cancel", action: {})],
                            primaryButtons: [.init(title: "Sign In", action: {})])) {
                                HStack {
                                    Text(verbatim: "Don’t have an account? SIGN UP")
                                }
                            }
        }
    }
}

struct WXMAlertView_Horizontal_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.red

            WXMAlertView(show: .constant(true),
                         configuration: .init(
                            title: "Add to favorites",
                            text: "Login to add **Perky Magenta Clothes** to your favorites and see historical & forecast data.".attributedMarkdown!,
                            buttonsLayout: .horizontal,
                            secondaryButtons: [.init(title: "Cancel", action: {})],
                            primaryButtons: [.init(title: "Sign In", action: {})])) {
                                EmptyView()
                            }
        }
    }
}

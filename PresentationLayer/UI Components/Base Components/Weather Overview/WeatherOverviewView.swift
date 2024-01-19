//
//  WeatherOverviewView.swift
//  wxm-ios
//
//  Created by Pantelis Giazitsis on 6/3/23.
//

import SwiftUI
import DomainLayer

struct WeatherOverviewView: View {
	var mode: Mode = .default
    let weather: CurrentWeather?
    var showSecondaryFields: Bool = false
    var noDataText: LocalizableString = .stationNoDataText
    var lastUpdatedText: String?
    var buttonTitle: String?
    var isButtonEnabled: Bool = true
    var buttonAction: (() -> Void)?

	let unitsManager: WeatherUnitsManager = .default
	var weatherIconDimensions: CGFloat {
		switch mode {
			case .minimal, .medium:
				CGFloat(.weatherIconMinDimension)
			case .large:
				CGFloat(.weatherIconLargeDimension)
			case .default:
				CGFloat(.weatherIconDefaultDimension)
		}
	}

    var body: some View {
        VStack(spacing: CGFloat(.defaultSpacing)) {
            Group {
                if weather != nil {
                    weatherDataView
                } else {
                    noDataView
                }
            }
            .WXMCardStyle(backgroundColor: Color(colorEnum: .top),
						  insideHorizontalPadding: CGFloat(.defaultSidePadding),
						  insideVerticalPadding: mainViewVerticalPadding,
						  cornerRadius: CGFloat(.cardCornerRadius))

			if showSecondaryFields {
				secondaryFieldsView
					.WXMCardStyle(backgroundColor: Color(colorEnum: .layer1),
								  insideHorizontalPadding: CGFloat(.defaultSidePadding),
								  insideVerticalPadding: 0.0,
								  cornerRadius: CGFloat(.cardCornerRadius))
					.if(mode == .default) { view in
						view.padding(.bottom)
					}
			}
        }
		.if(showSecondaryFields) { view in
			view
				.background(Color(colorEnum: .layer1))
		}
		.if(mode == .default) { view in
			view
				.cornerRadius(CGFloat(.cardCornerRadius))
		}
    }
}

extension WeatherOverviewView {
	enum Mode {
		case minimal
		case medium
		case large
		case `default`
	}

	private var mainViewVerticalPadding: CGFloat {
		switch mode {
			case .minimal:
				CGFloat(.minimumPadding)
			case .medium:
				CGFloat(.minimumPadding)
			case .large:
				CGFloat(.smallSidePadding)
			case .default:
				CGFloat(.defaultSidePadding)
		}
	}
}

struct WeatherOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        return ZStack {
            Color(.red)
            WeatherOverviewView(weather: CurrentWeather.mockInstance, showSecondaryFields: true, buttonTitle: "Button text", isButtonEnabled: false) {}
        }
    }
}

#Preview {
	return ZStack {
		Color(.red)
		WeatherOverviewView(mode: .minimal, weather: CurrentWeather.mockInstance, showSecondaryFields: false) {}
	}
}

#Preview {
	return ZStack {
		Color(.red)
		WeatherOverviewView(mode: .minimal, weather: nil, showSecondaryFields: false) {}
	}
}

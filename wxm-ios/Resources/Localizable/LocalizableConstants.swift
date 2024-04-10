//
//  LocalizableConstants.swift
//  wxm-ios
//
//  Created by Pantelis Giazitsis on 29/8/23.
//

import Foundation

protocol WXMLocalizable {
    var localized: String { get }
    var key: String { get }
}

enum LocalizableString: WXMLocalizable {
    case confirm
    case email
    case mandatoryEmail
    case firstName
    case lastName
    case password
    case signIn
    case signUp
    case dontHaveAccount
    case forgotPassword
    case resetPasswordTitle
    case weatherStationsHomeTitle
    case total(Int?)
    case owned(Int?)
    case following(Int?)
    case resetPassword
    case sendEmail
    case signInDescription
    case createAccount
    case registerDescription
    case unfollowAlertTitle
    case unfollowAlertDescription(String)
    case followAlertTitle
    case followAlertDescription(String)
    case deviceSerialNumber
    case issues(Int?)
    case viewMore
	case viewAll
    case celsiusSymbol
    case fahrenheitSymbol
    case temperature
    case feelsLike
    case humidity
    case wind
    case windSpeed
    case windDirection
    case rainRate
    case precipitation
    case precipitationRate
    case precipRate
    case precipitationProbability
    case dailyPrecipitation
    case dailyPrecip
    case windGust
    case pressure
    case pressureAbs
    case solar
    case solarRadiation
	case illuminance
    case dewPoint
    case uv
    case offlineStation
    case stationNoDataTitle
    case stationNoDataText
    case walletAddressMissingTitle
    case walletAddressMissingText
    case addWalletTitle
    case stationWarningUpdateTitle
    case stationWarningUpdateDescription
    case stationWarningUpdateButtonTitle
	case stationWarningLowBatteryTitle
	case stationWarningLowBatteryDescription
	case stationWarningLowBatteryButtonTitle
    case deviceInfoTitle
    case deviceInfoStationName
	case deviceInfoStationLocation
	case deviceInfoOwnedStationLocationDescription(String)
	case deviceInfoStationLocationDescription(String)
	case deviceinfoStationLocationButtonTitle
    case deviceInfoStationFrequency
    case deviceInfoStationReboot
    case deviceInfoStationMaintenance(String)
    case deviceInfoStationRemove
    case deviceInfoStationReconfigureWifi
    case deviceInfoStationHeliumFrequencyDescription(String)
    case deviceInfoStationM5FrequencyDescription
    case deviceInfoStationRebootDescription
    case deviceInfoStationMaintenanceDescription(String)
    case deviceInfoStationRemoveDescription(String)
    case deviceInfoStationReconfigureWifiDescription
    case deviceInfoStationRemoveWarning
    case deviceInfoButtonChangeName
    case deviceInfoButtonChangeFrequency
    case deviceInfoButtonReboot
    case deviceInfoButtonEnterMaintenance
    case deviceInfoButtonRemove
    case deviceInfoButtonReconfigureWifi
    case deviceInfoStationInformation
    case deviceInfoStationInfoName
    case deviceInfoStationInfoDevEUI
    case deviceInfoStationInfoHardwareVersion
    case deviceInfoStationInfoFirmwareVersion
    case deviceInfoStationInfoLastHotspot
    case deviceInfoStationInfoLastRSSI
    case deviceInfoStationInfoSerialNumber
    case deviceInfoStationInfoATECC
    case deviceInfoStationInfoGPS
    case deviceInfoStationInfoWifiSignal
    case deviceInfoStationInfoBattery
    case deviceInfoEditNameAlertTitle
    case deviceInfoEditNameAlertMessage
    case changingFrequency
    case deviceInfoClaimDate
    case deviceInfoFollowedContactSupportTitle
    case deviceInfoStationRebooted
    case deviceInfoStationRebootedDescription
    case deviceInfoStationBackToSettings
    case deviceInfoStationRebootFailed
    case deviceInfoStationRebootErrorDescription(String)
    case deviceInfoStationFrequencyChanged
    case deviceInfoStationFrequencyChangedDescription(String)
    case deviceInfoStationFrequencyChangeFailed
    case deviceInfoStationFrequencyChangeFailureDescription(String)
    case deviceInfoLowBatteryWarningMarkdown
    case deviceInfoRemoveStationAccountConfirmationMarkdown
    case invalidLocationErrorText
    case confirmPasswordTitle
    case explorerViewTitle
    case explorerLocationNotFound
    case justNow
    case rate
    case daily
    case speed
    case gust
    case uvIndex
    case share
    case retry
    case clear
    case cancel
    case change
    case days
    case connectToStation
    case yes
    case no
    case good
    case low
    case display
    case about
	case feedback
    case theme
    case appVersion
    case light
    case dark
    case system
    case emptyGenericTitle
    case emptyGenericDescription
    case percentage(Float)
    case lastUpdated(String)
    case alerts
    case favorite
    case favoritesloginAlertTitle
    case favoritesloginAlertText(String)
    case hiddenContentTitle
    case hiddenContentDescription(String)
    case alertsStationOfflineTitle
    case alertsStationOfflineDescription
    case profileTitleText
    case settings
    case save
    case success
    case goToSettingsButton
    case contactSupport
    case rebootingStation
    case successResetPasswordTitle
    case successResetPasswordDesc
    case deny
    case soundsGood
    case noEmail
    case addressAdded
    case scannerGuide
    case reload
    case logout
    case account
    case finish
    case timeZoneDisclaimer(String)
    case successRegisterDesc1
    case successRegisterDesc2
    case settingsOptionAnalyticsTitle
    case settingsOptionAnalyticsDescription
	case settingsOptionChangePasswordTitle
	case settingsOptionChangePasswordDescription
    case logoutAlertTitle
    case logoutAlertText
    case historyTitle
    case rewardScoreText
    case networkMax
    case typeYourPassword
    case noTransactionTitle
    case noTransactionDesc
	case mailLeaveMessageNote
	case activeStations(Int?)
	case activeStation(Int?)
	case presentStations(Int?)

    var localized: String {
        var localized = NSLocalizedString(self.key, comment: "")
        switch self {
            case .total(let count),
                    .owned(let count),
                    .following(let count),
                    .issues(let count),
					.activeStations(let count),
					.activeStation(let count),
					.presentStations(let count):
                localized = String(format: localized, count ?? 0)
            case .unfollowAlertDescription(let text),
                    .followAlertDescription(let text),
                    .deviceInfoStationMaintenance(let text),
					.deviceInfoStationLocationDescription(let text),
					.deviceInfoOwnedStationLocationDescription(let text),
                    .deviceInfoStationHeliumFrequencyDescription(let text),
                    .deviceInfoStationMaintenanceDescription(let text),
                    .deviceInfoStationRemoveDescription(let text),
                    .deviceInfoStationRebootErrorDescription(let text),
                    .deviceInfoStationFrequencyChangedDescription(let text),
                    .deviceInfoStationFrequencyChangeFailureDescription(let text),
                    .lastUpdated(let text),
                    .favoritesloginAlertText(let text),
                    .hiddenContentDescription(let text),
                    .timeZoneDisclaimer(let text):
                localized = String(format: localized, text)
            case .percentage(let count):
                localized = String(format: localized, count)
            default: break
        }

        return localized
    }
}

extension LocalizableString {
    var key: String {
        switch self {
            case .confirm:
                return "confirm"
            case .email:
                return "email"
            case .mandatoryEmail:
                return "mandatory_email"
            case .firstName:
                return "first_name"
            case .lastName:
                return "last_name"
            case .password:
                return "password"
            case .signIn:
                return "sign_in"
            case .signUp:
                return "sign_up"
            case .dontHaveAccount:
                return "dont_have_account"
            case .forgotPassword:
                return "forgot_password"
            case .resetPasswordTitle:
                return "reset_password_title"
            case .weatherStationsHomeTitle:
                return "weather_stations_home_title"
            case .total(let count):
                guard count != nil else {
                    return "total"
                }

                return "total_format"
            case .owned(let count):
                guard count != nil else {
                    return "owned"
                }

                return "owned_format"
            case .following(let count):
                guard count != nil else {
                    return "following"
                }

                return "following_format"
            case .resetPassword:
                return "reset_password"
            case .sendEmail:
                return "send_email"
            case .signInDescription:
                return "sign_in_description"
            case .createAccount:
                return "create_account"
            case .registerDescription:
                return "register_description"
            case .unfollowAlertTitle:
                return "unfollow_alert_title"
            case .unfollowAlertDescription:
                return "unfollow_alert_description_format"
            case .followAlertTitle:
                return "follow_alert_title"
            case .followAlertDescription:
                return "follow_alert_description_format"
            case .deviceSerialNumber:
                return "device_serial_number"
            case .issues:
                return "issues_format"
            case .viewMore:
                return "view_more"
			case .viewAll:
				return "view_all"
            case .celsiusSymbol:
                return "celsius_symbol"
            case .fahrenheitSymbol:
                return "fahrenheit_symbol"
            case .temperature:
                return "temperature"
            case .feelsLike:
                return "feels_like"
            case .humidity:
                return "humidity"
            case .wind:
                return "wind"
            case .windSpeed:
                return "wind_speed"
            case .windDirection:
                return "wind_direction"
            case .rainRate:
                return "rain_rate"
            case .precipitation:
                return "precipitation"
            case .precipitationRate:
                return "precipitation_rate"
            case .precipRate:
                return "precip_rate"
            case .precipitationProbability:
                return "precipitation_probability"
            case .dailyPrecipitation:
                return "daily_precipitation"
            case .dailyPrecip:
                return "daily_precip"
            case .windGust:
                return "wind_gust"
            case .pressure:
                return "pressure"
            case .pressureAbs:
                return "pressure_abs"
            case .solar:
                return "solar"
            case .solarRadiation:
                return "solar_radiation"
			case .illuminance:
				return "illuminance"
            case .dewPoint:
                return "dew_point"
            case .uv:
                return "uv"
            case .offlineStation:
                return "offline_station"
            case .stationNoDataTitle:
                return "station_no_data_title"
            case .stationNoDataText:
                return "station_no_data_text"
            case .walletAddressMissingTitle:
                return "wallet_address_missing_title"
            case .walletAddressMissingText:
                return "wallet_address_missing_text"
            case .addWalletTitle:
                return "add_wallet_title"
            case .stationWarningUpdateTitle:
                return "station_warning_update_title"
            case .stationWarningUpdateDescription:
                return "station_warning_update_description"
            case .stationWarningUpdateButtonTitle:
                return "station_warning_update_button_title"
			case .stationWarningLowBatteryTitle:
				return "station_warning_low_battery_title"
			case .stationWarningLowBatteryDescription:
				return "station_warning_low_battery_description"
			case .stationWarningLowBatteryButtonTitle:
				return "station_warning_low_battery_button_title"
            case .deviceInfoTitle:
                return "device_info_title"
            case .deviceInfoStationName:
                return "device_info_station_name"
			case .deviceInfoStationLocation:
				return "device_info_station_location"
			case .deviceInfoOwnedStationLocationDescription:
				return "device_info_owned_station_location_description_format"
			case .deviceInfoStationLocationDescription:
				return "device_info_station_location_description_format"
			case .deviceinfoStationLocationButtonTitle:
				return "device_info_station_location_button_title"
            case .deviceInfoStationFrequency:
                return "device_info_station_frequency"
            case .deviceInfoStationReboot:
                return "device_info_station_reboot"
            case .deviceInfoStationMaintenance:
                return "device_info_station_maintenance_format"
            case .deviceInfoStationRemove:
                return "device_info_station_remove"
            case .deviceInfoStationReconfigureWifi:
                return "device_info_station_reconfigure_wifi"
            case .deviceInfoStationHeliumFrequencyDescription:
                return "device_info_station_helium_frequency_description_format"
            case .deviceInfoStationM5FrequencyDescription:
                return "device_info_station_m5_frequency_description"
            case .deviceInfoStationRebootDescription:
                return "device_info_station_reboot_description"
            case .deviceInfoStationMaintenanceDescription:
                return "device_info_station_maintenance_description_format"
            case .deviceInfoStationRemoveDescription:
                return "device_info_station_remove_description_format"
            case .deviceInfoStationReconfigureWifiDescription:
                return "device_info_station_reconfigure_wifi_description"
            case .deviceInfoStationRemoveWarning:
                return "device_info_station_remove_warning"
            case .deviceInfoButtonChangeName:
                return "device_info_button_change_name"
            case .deviceInfoButtonChangeFrequency:
                return "device_info_button_change_frequency"
            case .deviceInfoButtonReboot:
                return "device_info_button_reboot"
            case .deviceInfoButtonEnterMaintenance:
                return "device_info_button_enter_maintenance"
            case .deviceInfoButtonRemove:
                return "device_info_button_remove"
            case .deviceInfoButtonReconfigureWifi:
                return "device_info_button_reconfigure_wifi"
            case .deviceInfoStationInformation:
                return "device_info_station_information"
            case .deviceInfoStationInfoName:
                return "device_info_station_info_name"
            case .deviceInfoStationInfoDevEUI:
                return "device_info_station_info_dev_EUI"
            case .deviceInfoStationInfoHardwareVersion:
                return "device_info_station_info_hardware_version"
            case .deviceInfoStationInfoFirmwareVersion:
                return "device_info_station_info_firmware_version"
            case .deviceInfoStationInfoLastHotspot:
                return "device_info_station_info_last_hotspot"
            case .deviceInfoStationInfoLastRSSI:
                return "device_info_station_info_last_RSSI"
            case .deviceInfoStationInfoSerialNumber:
                return "device_info_station_info_serial_number"
            case .deviceInfoStationInfoATECC:
                return "device_info_station_info_ATECC"
            case .deviceInfoStationInfoGPS:
                return "device_info_station_info_GPS"
            case .deviceInfoStationInfoWifiSignal:
                return "device_info_station_info_wifi_signal"
            case .deviceInfoStationInfoBattery:
                return "device_info_station_info_battery"
            case .deviceInfoEditNameAlertTitle:
                return "device_info_edit_name_alert_title"
            case .deviceInfoEditNameAlertMessage:
                return "device_info_edit_name_alert_message"
            case .changingFrequency:
                return "changing_requency"
            case .deviceInfoClaimDate:
                return "device_info_claim_date"
            case .deviceInfoFollowedContactSupportTitle:
                return "device_info_followed_contact_support_title"
            case .deviceInfoStationRebooted:
                return "device_info_station_rebooted"
            case .deviceInfoStationRebootedDescription:
                return "device_info_station_rebooted_description"
            case .deviceInfoStationBackToSettings:
                return "device_info_station_back_to_settings"
            case .deviceInfoStationRebootFailed:
                return "device_info_station_reboot_failed"
            case .deviceInfoStationRebootErrorDescription:
                return "device_info_station_reboot_error_description_format"
            case .deviceInfoStationFrequencyChanged:
                return "device_info_station_frequency_changed"
            case .deviceInfoStationFrequencyChangedDescription:
                return "device_info_station_frequency_changed_description_format"
            case .deviceInfoStationFrequencyChangeFailed:
                return "device_info_station_frequency_change_failed"
            case .deviceInfoStationFrequencyChangeFailureDescription:
                return "device_info_station_frequency_change_failure_description_format"
            case .deviceInfoLowBatteryWarningMarkdown:
                return "device_info_low_battery_warning_markdown"
            case .deviceInfoRemoveStationAccountConfirmationMarkdown:
                return "device_info_remove_station_account_confirmation_markdown"
            case .invalidLocationErrorText:
                return "invalid_location_error_text"
            case .confirmPasswordTitle:
                return "confirm_password_title"
            case .explorerViewTitle:
                return "explorer_title"
            case .explorerLocationNotFound:
                return "explorer_location_not_found"
            case .justNow:
                return "just_now"
            case .rate:
                return "rate"
            case .daily:
                return "daily"
            case .speed:
                return "speed"
            case .gust:
                return "gust"
            case .uvIndex:
                return "uv_index"
            case .share:
                return "share"
            case .retry:
                return "retry"
            case .clear:
                return "clear"
            case .cancel:
                return "cancel"
            case .change:
                return "change"
            case .days:
                return "days"
            case .connectToStation:
                return "connect_to_station"
            case .yes:
                return "yes"
            case .no:
                return "no"
            case .good:
                return "good"
            case .low:
                return "low"
            case .display:
                return "display"
            case .about:
                return "about"
			case .feedback:
				return "feedback"
            case .theme:
                return "theme"
            case .appVersion:
                return "app_version"
            case .light:
                return "light"
            case .dark:
                return "dark"
            case .system:
                return "system"
            case .emptyGenericTitle:
                return "empty_generic_title"
            case .emptyGenericDescription:
                return "empty_generic_description"
            case .percentage:
                return "percentage_format"
            case .lastUpdated:
                return "last_updated_format"
            case .alerts:
                return "alerts"
            case .favorite:
                return "favorite"
            case .favoritesloginAlertTitle:
                return "favorites_login_alert_title"
            case .favoritesloginAlertText:
                return "favorites_login_alert_text_format"
            case .hiddenContentTitle:
                return "hidden_content_title"
            case .hiddenContentDescription:
                return "hidden_content_description_format"
            case .alertsStationOfflineTitle:
                return "alerts_station_offline_title"
            case .alertsStationOfflineDescription:
                return "alerts_station_offline_description"
            case .profileTitleText:
                return "profile_title_text"
            case .settings:
                return "settings"
            case .save:
                return "save"
            case .success:
                return "success"
            case .goToSettingsButton:
                return "go_to_settings_button"
            case .contactSupport:
                return "contact_support"
            case .rebootingStation:
                return "rebooting_station"
            case .successResetPasswordTitle:
                return "success_reset_password_title"
            case .successResetPasswordDesc:
                return "success_reset_password_desc"
            case .deny:
                return "deny"
            case .soundsGood:
                return "sounds_good"
            case .noEmail:
                return "no_email"
            case .addressAdded:
                return "address_added"
            case .scannerGuide:
                return "scanner_guide"
            case .reload:
                return "reload"
            case .logout:
                return "logout"
            case .account:
                return "account"
            case .finish:
                return "finish"
            case .timeZoneDisclaimer:
                return "timezone_disclaimer_format"
            case .successRegisterDesc1:
                return "success_register_desc1"
            case .successRegisterDesc2:
                return "success_register_desc2"
            case .settingsOptionAnalyticsTitle:
                return "settings_option_analytics_title"
            case .settingsOptionAnalyticsDescription:
                return "settings_option_analytics_description"
			case .settingsOptionChangePasswordTitle:
				return "settings_option_change_password_title"
			case .settingsOptionChangePasswordDescription:
				return "settings_option_change_password_description"
            case .logoutAlertTitle:
                return "logout_alert_title"
            case .logoutAlertText:
                return "logout_alert_text"
            case .historyTitle:
                return "history_title"
            case .rewardScoreText:
                return "reward_score_text"
            case .networkMax:
                return "network_max"
            case .typeYourPassword:
                return "type_your_password"
            case .noTransactionTitle:
                return "no_transaction_title"
            case .noTransactionDesc:
                return "no_transaction_desc"
			case .mailLeaveMessageNote:
				return "mail_leave_message_note"
			case .activeStations:
				return "active_stations_format"
			case .activeStation:
				return "active_station_format"
			case .presentStations:
				return "present_stations_format"
        }
    }
}

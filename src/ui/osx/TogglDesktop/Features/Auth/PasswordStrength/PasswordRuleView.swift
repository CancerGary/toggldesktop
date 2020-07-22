//
//  PasswordRuleView.swift
//  TogglDesktop
//
//  Created by Nghia Tran on 5/7/20.
//  Copyright © 2020 Alari. All rights reserved.
//

import Cocoa

/// Represent a single Rule View
final class PasswordRuleView: NSView {

    // MARK: Variables

    @IBOutlet weak var titleLbl: NSTextField!
    @IBOutlet weak var iconImageView: NSImageView!

    // MARK: Variable

    private(set) var rule: PasswordStrengthValidation.Rule?
    private static var greenColor: NSColor {
        if #available(OSX 10.13, *) {
            return NSColor(named: NSColor.Name("green-color"))!
        } else {
            return ConvertHexColor.hexCode(toNSColor: "#28cd41")
        }
    }

    private static var redColor: NSColor {
        if #available(OSX 10.13, *) {
            return NSColor(named: NSColor.Name("error-title-color"))!
        } else {
            return ConvertHexColor.hexCode(toNSColor: "#FF3B30")
        }
    }

    private static var greyColor: NSColor {
        if #available(OSX 10.13, *) {
            return NSColor(named: NSColor.Name("grey-text-color"))!
        } else {
            return ConvertHexColor.hexCode(toNSColor: "#555555")
        }
    }

    // MARK: Public

    /// Update UI with given rule
    /// - Parameters:
    ///   - rule: Password Rule
    ///   - status: Status
    func config(with rule: PasswordStrengthValidation.Rule, status: PasswordStrengthValidation.MatchStatus) {
        self.rule = rule
        titleLbl.stringValue = rule.title
        updateStatus(status)
    }

    /// Update UI for current rule
    /// - Parameter status: A new status
    func updateStatus(_ status: PasswordStrengthValidation.MatchStatus) {
        titleLbl.textColor = getTextColor(for: status)
        iconImageView.image = getIconImageView(for: status)
    }

    /// Get proper color for given status
    /// - Parameter status: Match status
    /// - Returns: Text Color
    private func getTextColor(for status: PasswordStrengthValidation.MatchStatus) -> NSColor {
        switch status {
        case .match:
            return PasswordRuleView.greenColor
        case .unmatch:
            return PasswordRuleView.redColor
        case .none:
            return PasswordRuleView.greyColor
        }
    }

    /// Get proper Icon for given status
    /// - Parameter status: Password Status
    /// - Returns: An Image
    private func getIconImageView(for status: PasswordStrengthValidation.MatchStatus) -> NSImage {
        switch status {
        case .match:
            return NSImage(named: "password_green_check")!
        case .unmatch:
            return NSImage(named: NSImage.statusUnavailableName)!
        case .none:
            return NSImage(named: NSImage.statusNoneName)!
        }
    }
}

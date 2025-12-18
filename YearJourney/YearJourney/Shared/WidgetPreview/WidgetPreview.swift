//
//  WidgetPreview.swift
//  YearJourney
//
//  Created by KoJeongseok on 12/18/25.
//

import SwiftUI
import WidgetKit

enum WidgetPreviewSize {
    static func size(for family: WidgetFamily) -> CGSize {
        switch family {
        case .systemSmall:
            return CGSize(width: 155, height: 155)
        case .systemMedium:
            return CGSize(width: 329, height: 155)
        case .systemLarge:
            return CGSize(width: 329, height: 345)
        case .systemExtraLarge:
            return CGSize(width: 329, height: 345) // iPad에서만 의미 있음(필요 시 보정)
        default:
            return CGSize(width: 329, height: 155)
        }
    }
}

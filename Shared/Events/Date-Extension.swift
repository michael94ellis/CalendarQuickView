//
//  Date-Extension.swift
//  TimeDraw
//
//  Created by Michael Ellis on 1/4/22.
//

import Foundation

extension DateFormatter {
    convenience public init(format: String) {
        self.init()
        self.dateFormat = format
    }
}

extension Date {
    
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }

    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        // swiftlint:disable:next force_unwrapping
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
}

extension Array where Element: Hashable {
    func uniqued<T: Equatable>(_ keyPath: KeyPath<Element, T>) -> [Element] {
        var buffer = Array()
        var added = Set<Element>()
        for elem in self {
            if !added.contains(where: { $0[keyPath: keyPath] == elem[keyPath: keyPath] }) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
}

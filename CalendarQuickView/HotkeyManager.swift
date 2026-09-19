//
//  HotkeyManager.swift
//  CalendarQuickView
//

import Carbon.HIToolbox
import AppKit

/// Registers a fixed global keyboard shortcut (Control+Option+C) using Carbon's
/// Register/InstallEventHandler APIs. Unlike an `NSEvent` global monitor, this does not
/// require the user to grant Accessibility permission, and is safe under the App Sandbox.
final class HotkeyManager {

    static let shared = HotkeyManager()

    private static var registeredHandlers: [UInt32: () -> Void] = [:]
    private static var eventHandlerRef: EventHandlerRef?
    private static var nextID: UInt32 = 1

    private var hotKeyRef: EventHotKeyRef?
    private var hotKeyID: UInt32 = 0

    private init() {}

    /// Registers the shortcut to invoke `action`. Safe to call more than once; a later call
    /// replaces the previous registration. Returns false if the OS refused registration
    /// (e.g. another app already owns that shortcut).
    @discardableResult
    func registerToggleShortcut(action: @escaping () -> Void) -> Bool {
        unregister()
        Self.installHandlerIfNeeded()

        let id = Self.nextID
        Self.nextID += 1
        Self.registeredHandlers[id] = action
        hotKeyID = id

        let eventHotKeyID = EventHotKeyID(signature: OSType(0x51434C56), id: id) // "QCLV"
        let keyCode: UInt32 = 0x08 // kVK_ANSI_C
        let modifiers: UInt32 = UInt32(controlKey | optionKey)

        var ref: EventHotKeyRef?
        let status = RegisterEventHotKey(keyCode, modifiers, eventHotKeyID, GetEventDispatcherTarget(), 0, &ref)
        hotKeyRef = ref

        if status != noErr {
            Self.registeredHandlers.removeValue(forKey: id)
            hotKeyID = 0
            hotKeyRef = nil
        }
        return status == noErr
    }

    func unregister() {
        if let hotKeyRef {
            UnregisterEventHotKey(hotKeyRef)
            self.hotKeyRef = nil
        }
        if hotKeyID != 0 {
            Self.registeredHandlers.removeValue(forKey: hotKeyID)
            hotKeyID = 0
        }
    }

    private static func installHandlerIfNeeded() {
        guard eventHandlerRef == nil else { return }

        var eventType = EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: OSType(kEventHotKeyPressed))

        let handler: EventHandlerUPP = { _, eventRef, _ -> OSStatus in
            guard let eventRef else { return noErr }
            var pressedID = EventHotKeyID()
            let status = GetEventParameter(
                eventRef,
                EventParamName(kEventParamDirectObject),
                EventParamType(typeEventHotKeyID),
                nil,
                MemoryLayout<EventHotKeyID>.size,
                nil,
                &pressedID
            )
            guard status == noErr, let action = HotkeyManager.registeredHandlers[pressedID.id] else {
                return noErr
            }
            DispatchQueue.main.async {
                action()
            }
            return noErr
        }

        InstallEventHandler(GetEventDispatcherTarget(), handler, 1, &eventType, nil, &eventHandlerRef)
    }

    deinit {
        unregister()
    }
}

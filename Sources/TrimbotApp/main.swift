import AppKit
import TrimbotCore

@MainActor
final class ClipboardWatcher {
    static let markerType = NSPasteboard.PasteboardType("com.dansusman.trimbot.marker")

    private let pasteboard = NSPasteboard.general
    private var lastChangeCount: Int
    private var timer: Timer?

    var isEnabled: Bool = true {
        didSet { isEnabled ? start() : stop() }
    }

    init() {
        lastChangeCount = pasteboard.changeCount
        start()
    }

    func start() {
        stop()
        timer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { [weak self] _ in
            Task { @MainActor in self?.tick() }
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }

    private func tick() {
        guard isEnabled else { return }
        let count = pasteboard.changeCount
        guard count != lastChangeCount else { return }
        lastChangeCount = count

        if pasteboard.types?.contains(Self.markerType) == true { return }
        guard let original = pasteboard.string(forType: .string) else { return }
        let result = Cleaner.process(original)
        guard result.changed else { return }
        pasteboard.clearContents()
        pasteboard.setString(result.cleaned, forType: .string)
        pasteboard.setData(Data(), forType: Self.markerType)
        lastChangeCount = pasteboard.changeCount
    }
}

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private let watcher = ClipboardWatcher()

    func applicationDidFinishLaunching(_: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.button?.title = "✄"
        rebuildMenu()
    }

    private func rebuildMenu() {
        let menu = NSMenu()
        let toggle = NSMenuItem(
            title: watcher.isEnabled ? "Auto-clean: ON" : "Auto-clean: OFF",
            action: #selector(toggleEnabled),
            keyEquivalent: ""
        )
        toggle.target = self
        menu.addItem(toggle)
        menu.addItem(.separator())
        let quit = NSMenuItem(title: "Quit Trimbot", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        menu.addItem(quit)
        statusItem.menu = menu
    }

    @objc private func toggleEnabled() {
        watcher.isEnabled.toggle()
        rebuildMenu()
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.setActivationPolicy(.accessory)
app.run()

//
//  ViewController.swift
//  MacTerminal
//
//  Created by Miguel de Icaza on 3/11/20.
//  Copyright © 2020 Miguel de Icaza. All rights reserved.
//

import Cocoa
import SwiftTerm

class ViewController: NSViewController, LocalProcessTerminalViewDelegate, NSUserInterfaceValidations {
    @IBOutlet var loggingMenuItem: NSMenuItem?

    var changingSize = false
    var logging: Bool = false
    var zoomGesture: NSMagnificationGestureRecognizer?

    func sizeChanged(source _: LocalProcessTerminalView, newCols _: Int, newRows _: Int) {
        if changingSize {
            return
        }
        changingSize = true
        // var border = view.window!.frame - view.frame
        var newFrame = terminal.getOptimalFrameSize()
        let windowFrame = view.window!.frame

        newFrame = CGRect(x: windowFrame.minX, y: windowFrame.minY, width: newFrame.width, height: windowFrame.height - view.frame.height + newFrame.height)

        view.window?.setFrame(newFrame, display: true, animate: true)
        changingSize = false
    }

    func setTerminalTitle(source _: LocalProcessTerminalView, title: String) {
        view.window?.title = title
    }

    func processTerminated(source _: TerminalView, exitCode: Int32?) {
        view.window?.close()
        if let e = exitCode {
            print("Process terminated with code: \(e)")
        } else {
            print("Process vanished")
        }
    }

    var terminal: LocalProcessTerminalView!

    static var lastTerminal: LocalProcessTerminalView!

    func updateLogging() {
        let path = logging ? "/Users/miguel/Downloads/Logs" : nil
        terminal.setHostLogging(directory: path)
        NSUserDefaultsController.shared.defaults.set(logging, forKey: "LogHostOutput")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        terminal = LocalProcessTerminalView(frame: view.frame)
        zoomGesture = NSMagnificationGestureRecognizer(target: self, action: #selector(zoomGestureHandler))
        terminal.addGestureRecognizer(zoomGesture!)
        ViewController.lastTerminal = terminal
        terminal.processDelegate = self
        terminal.startProcess()
        view.addSubview(terminal)

        logging = NSUserDefaultsController.shared.defaults.bool(forKey: "LogHostOutput")
        updateLogging()
    }

    @objc
    func zoomGestureHandler(_ sender: NSMagnificationGestureRecognizer) {
        if sender.magnification > 0 {
            biggerFont(sender)
        } else {
            smallerFont(sender)
        }
    }

    override func viewDidLayout() {
        super.viewDidLayout()
        changingSize = true
        terminal.frame = view.frame
        changingSize = false
        terminal.needsLayout = true
    }

    @IBAction
    func set80x25(_: AnyObject) {
        terminal.resize(cols: 80, rows: 25)
    }

    var lowerCol = 80
    var lowerRow = 25
    var higherCol = 160
    var higherRow = 60

    func queueNextSize() {
        // If they requested a stop
        if resizificating == 0 {
            return
        }
        var next = terminal.getTerminal().getDims()
        if resizificating > 0 {
            if next.cols < higherCol {
                next.cols += 1
            }
            if next.rows < higherRow {
                next.rows += 1
            }
        } else {
            if next.cols > lowerCol {
                next.cols -= 1
            }
            if next.rows > lowerRow {
                next.rows -= 1
            }
        }
        terminal.resize(cols: next.cols, rows: next.rows)
        var direction = resizificating

        if next.rows == higherRow, next.cols == higherCol {
            direction = -1
        }
        if next.rows == lowerRow, next.cols == lowerCol {
            direction = 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.03) {
            self.resizificating = direction
            self.queueNextSize()
        }
    }

    var resizificating = 0

    @IBAction
    func resizificator(_: AnyObject) {
        if resizificating != 1 {
            resizificating = 1
            queueNextSize()
        } else {
            resizificating = 0
        }
    }

    @IBAction
    func resizificatorDown(_: AnyObject) {
        if resizificating != -1 {
            resizificating = -1
            queueNextSize()
        } else {
            resizificating = 0
        }
    }

    @IBAction
    func allowMouseReporting(_: AnyObject) {
        terminal.allowMouseReporting.toggle()
    }

    @IBAction
    func softReset(_: AnyObject) {
        terminal.getTerminal().softReset()
        terminal.setNeedsDisplay(terminal.frame)
    }

    @IBAction
    func hardReset(_: AnyObject) {
        terminal.getTerminal().resetToInitialState()
        terminal.setNeedsDisplay(terminal.frame)
    }

    @IBAction
    func toggleOptionAsMetaKey(_: AnyObject) {
        terminal.optionAsMetaKey.toggle()
    }

    @IBAction
    func biggerFont(_: AnyObject) {
        let size = terminal.font.pointSize
        guard size < 72 else {
            return
        }

        terminal.font = NSFont.monospacedSystemFont(ofSize: size + 1, weight: .regular)
    }

    @IBAction
    func smallerFont(_: AnyObject) {
        let size = terminal.font.pointSize
        guard size > 5 else {
            return
        }

        terminal.font = NSFont.monospacedSystemFont(ofSize: size - 1, weight: .regular)
    }

    @IBAction
    func defaultFontSize(_: AnyObject) {
        terminal.font = NSFont.monospacedSystemFont(ofSize: NSFont.systemFontSize, weight: .regular)
    }

    @IBAction
    func addTab(_: AnyObject) {
//        if let win = view.window {
//            win.tabbingMode = .preferred
//            if let wc = win.windowController {
//                if let d = wc.document as? Document {
//                    do {
//                        let x = Document()
//                        x.makeWindowControllers()
//
//                        try NSDocumentController.shared.newDocument(self)
//                    } catch {}
//                    print ("\(d.debugDescription)")
//                }
//            }
//        }
//            win.tabbingMode = .preferred
//            win.addTabbedWindow(win, ordered: .above)
//
//            if let wc = win.windowController {
//                wc.newWindowForTab(self()
//                wc.showWindow(source)
//            }
//        }
    }

    func validateUserInterfaceItem(_ item: NSValidatedUserInterfaceItem) -> Bool {
        if item.action == #selector(debugToggleHostLogging(_:)) {
            if let m = item as? NSMenuItem {
                m.state = logging ? NSControl.StateValue.on : NSControl.StateValue.off
            }
        }
        if item.action == #selector(resizificator(_:)) {
            if let m = item as? NSMenuItem {
                m.state = resizificating == 1 ? NSControl.StateValue.on : NSControl.StateValue.off
            }
        }
        if item.action == #selector(resizificatorDown(_:)) {
            if let m = item as? NSMenuItem {
                m.state = resizificating == -1 ? NSControl.StateValue.on : NSControl.StateValue.off
            }
        }
        if item.action == #selector(allowMouseReporting(_:)) {
            if let m = item as? NSMenuItem {
                m.state = terminal.allowMouseReporting ? NSControl.StateValue.on : NSControl.StateValue.off
            }
        }
        if item.action == #selector(toggleOptionAsMetaKey(_:)) {
            if let m = item as? NSMenuItem {
                m.state = terminal.optionAsMetaKey ? NSControl.StateValue.on : NSControl.StateValue.off
            }
        }
        return true
    }

    @IBAction
    func debugToggleHostLogging(_: AnyObject) {
        logging = !logging
        updateLogging()
    }
}

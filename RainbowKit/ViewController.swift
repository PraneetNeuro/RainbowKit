//
//  ViewController.swift
//  RainbowKit
//
//  Created by Praneet S on 26/10/21.
//

import Cocoa

extension NSImage {
    convenience init(color: NSColor, size: NSSize) {
        self.init(size: size)
        lockFocus()
        color.drawSwatch(in: NSRect(origin: .zero, size: size))
        unlockFocus()
    }
}

extension NSColor {
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0

        getRed(&r, green: &g, blue: &b, alpha: &a)

        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0

        return NSString(format:"#%06x", rgb) as String
    }

    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

}

class ViewController: NSViewController {
    
    @IBOutlet weak var hexCodeForColorInContext: NSTextField!
    var driver: DriverObject?
    var colorInContext: NSColor = .white
    
    func captureColorInContext() {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(colorInContext.toHexString(), forType: .string)
    }
    
    func updateColorInContext() {
        self.colorInContext = driver?.runLoop() ?? .white
        hexCodeForColorInContext.stringValue = self.colorInContext.toHexString()
        view.layer?.backgroundColor = CGColor(red: colorInContext.redComponent, green: colorInContext.greenComponent, blue: colorInContext.blueComponent, alpha: 1.0)
        let appDockTile =  NSApplication.shared.dockTile
//        let appImageView = NSImageView(image: NSImage(color: self.colorInContext, size: NSSize(width: 128, height: 128)))
        let appImageView = NSImageView(image: NSImage(size: NSSize(width: 128, height: 128), flipped: false, drawingHandler: {
            (dstRect: NSRect) -> Bool in
            self.colorInContext.drawSwatch(in: dstRect)
            let hexCode: NSString = NSString(string: self.hexCodeForColorInContext.stringValue)
            let textAlignment = NSMutableParagraphStyle()
            textAlignment.alignment = .center
            textAlignment.minimumLineHeight = dstRect.height / 2
            hexCode.draw(in: dstRect, withAttributes: [NSAttributedString.Key.paragraphStyle : textAlignment, NSAttributedString.Key.foregroundColor : NSColor.white, NSAttributedString.Key.font : NSFont(name: "Helvetica-Bold", size: 26)])
            return true
        }))
        appImageView.wantsLayer = true
        appImageView.layer?.borderWidth = 1
        appImageView.layer?.cornerRadius = 16
        appDockTile.contentView = appImageView
        appDockTile.display()
    }
    
    override func viewDidLoad() {
        driver = DriverObject()
        super.viewDidLoad()
        
        NSEvent.addGlobalMonitorForEvents(matching: .rightMouseDown, handler: {
            _ in
            self.captureColorInContext()
        })
        
        NSEvent.addGlobalMonitorForEvents(matching: .mouseMoved) { _ in
            self.updateColorInContext()
        }
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}


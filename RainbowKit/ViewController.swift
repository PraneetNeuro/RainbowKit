//
//  ViewController.swift
//  RainbowKit
//
//  Created by Praneet S on 26/10/21.
//

import Cocoa

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
        view.layer?.backgroundColor = CGColor(red: colorInContext.redComponent, green: colorInContext.greenComponent, blue: colorInContext.blueComponent, alpha: colorInContext.alphaComponent)
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


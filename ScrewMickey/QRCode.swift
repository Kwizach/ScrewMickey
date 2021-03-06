//
//  QRCode.swift
//  Syluaq DP Team
//
//  Created by Syluaq DP Team on 11/01/2016.
//  Copyright © 2016 Syluaq DP Team. All rights reserved.
//

import Foundation
import UIKit

/////////////////////////////////////////

public var configQrafter : ConfigCrafter = ConfigCrafter()

public struct ConfigCrafter {
    
    public enum CraftFrom {
        case range
        case rangeRandomly
        case list
    }
    
    public var isUpdatable : Bool
    public var incrementationValue : Int
    public var timeBetweenCraft : Double
    public var lowerRangeValue : DataToCraft
    public var upperRangeValue : DataToCraft
    public var rangeLength : Int
    public var listOfValues : [DataToCraft]
    public var errorCorrection : QRCode.ErrorCorrection
    public var craftFromRangeOrList : CraftFrom
    public var withVibration : Bool
    
    public let incrementationValueDefault : Int = 1
    public let itimeBetweenCraftDefault : Double = 2.0
    public let errorCorrectionDefault : QRCode.ErrorCorrection = .Low
    public let emptyDataToCraft : DataToCraft = DataToCraft(string: "", type: .anyText)
    
    init() {
        isUpdatable = false
        incrementationValue = incrementationValueDefault
        timeBetweenCraft = itimeBetweenCraftDefault
        lowerRangeValue = emptyDataToCraft
        upperRangeValue = emptyDataToCraft
        listOfValues = []
        craftFromRangeOrList = .range
        errorCorrection = errorCorrectionDefault
        withVibration = false
        rangeLength = 0
    }
}

/////////////////////////////////////////

public struct QRCode {
    
    /**
     The level of error correction.
     
     - Low:      7%
     - Medium:   15%
     - Quartile: 25%
     - High:     30%
     */
    public enum ErrorCorrection: String {
        case Low = "L"
        case Medium = "M"
        case Quartile = "Q"
        case High = "H"
        
        static let allValues = ["L", "M", "Q", "H"]
        static let allFullValues = ["Low", "Medium", "Quartile", "High"]
    }
    
    /// The error correction. The default value is `.Low`.
    public var errorCorrection = ErrorCorrection.Low
    
    /// Size of the output
    public var size = CGSize(width: 200, height: 200)
    
    /// CIQRCodeGenerator generates 27x27px images per default
    fileprivate let DefaultQRCodeSize = CGSize(width: 27, height: 27)
    
    /// Data contained in the generated QRCode
    fileprivate var data: Data = Data()
    
    // MARK: - Change Data
    
    public mutating func setText(_ string: String) {
        if let newData = string.data(using: String.Encoding.isoLatin1) {
            self.data = newData
        }
    }
    
    
    // MARK: - Generate QRCode
    
    /// The QRCode's UIImage representation
    public var image: UIImage? {
        guard let ciImage = ciImage else { return nil }
        return UIImage(ciImage: ciImage)
    }
    
    /// The QRCode's CIImage representation
    public var ciImage: CIImage? {
        // Generate QRCode
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        
        qrFilter.setDefaults()
        qrFilter.setValue(data, forKey: "inputMessage")
        qrFilter.setValue(self.errorCorrection.rawValue, forKey: "inputCorrectionLevel")
        
        // Size
        let sizeRatioX = size.width / DefaultQRCodeSize.width
        let sizeRatioY = size.height / DefaultQRCodeSize.height
        let transform = CGAffineTransform(scaleX: sizeRatioX, y: sizeRatioY)
        
        if let transformedImage = qrFilter.outputImage?.applying(transform) {
            return transformedImage
        }
        return nil
    }
}

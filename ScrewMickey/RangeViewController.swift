//
//  RangeViewController.swift
//  ScrewMickey
//
//  Created by clement rabourdin on 14/01/2016.
//  Copyright © 2016 Syluaq DP Team. All rights reserved.
//

import UIKit

class RangeViewController: UIViewController {

    @IBOutlet weak var ticketNumberLabel: UILabel!
    @IBOutlet weak var upperRangeLabel: UILabel!
    @IBOutlet weak var lowerRangeLabel: UILabel!
    @IBOutlet weak var upperRangeSlider: UISlider!
    @IBOutlet weak var lowerRangeSlider: UISlider!
    
    var upperVal = ""
    var lowerVal = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        ticketNumberLabel.text = scannedTicket.leText
        upperRangeLabel.text = scannedTicket.leText
        lowerRangeLabel.text = scannedTicket.leText
        
        upperVal = scannedTicket.leText
        lowerVal = scannedTicket.leText
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Sliders
    
    @IBAction func upperSliderChanged(sender: UISlider) {
        upperVal = incrementOurTicket(sender.value).leText
        let nouvelleValeur = upperVal + " (+\(Int(sender.value)))"
        
        upperRangeLabel.text = nouvelleValeur
        
        configQrafter.rangeLength = Int(upperRangeSlider.value - lowerRangeSlider.value)
    }
    
    @IBAction func lowerSliderChanged(sender: UISlider) {
        lowerVal = incrementOurTicket(sender.value).leText
        let nouvelleValeur = lowerVal + " (\(Int(sender.value)))"
        
        lowerRangeLabel.text = nouvelleValeur
        
        configQrafter.rangeLength = Int(upperRangeSlider.value - lowerRangeSlider.value)
        configQrafter.lowerRangeValue = DataToCraft(string: lowerVal, type: .Entier)
    }
    
    func incrementOurTicket(valeur: Float) -> DataToCraft {
        var nouvelleValeur = scannedTicket
        nouvelleValeur.incrementText(Int(valeur))
        
        return nouvelleValeur
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.

        // On ne passe rien au controller crafterviewcontroller... on utilise les variables globales
        
        configQrafter.isUpdatable = true
        
        if segue.identifier == "rangeToCraft" {
            configQrafter.craftFromRangeOrList = .Range
        }
        else if segue.identifier == "rangeToCraftRandomly" {
            configQrafter.craftFromRangeOrList = .RangeRandomly
        }
        configQrafter.lowerRangeValue = DataToCraft(string: lowerVal, type: .Entier)
        configQrafter.upperRangeValue = DataToCraft(string: upperVal, type: .Entier)
    }

}

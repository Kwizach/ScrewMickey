//
//  SQLiTableViewController.swift
//  ScrewMickey
//
//  Created by clement rabourdin on 19/01/2016.
//  Copyright © 2016 Syluaq DP Team. All rights reserved.
//

import UIKit

class SQLiTableViewController: UITableViewController {
    
    var menu : AZDropdownMenu? = nil
    var codeToAdd : String = ""

    @IBOutlet var listOfSQLiTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return theSQLList.listOfSQLi.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sqliIdentifier", for: indexPath)

        // Configure the cell...
        /// Title
        var title = codeToAdd
        title += theSQLList.listOfSQLi[indexPath.row].value
        cell.textLabel?.text = title
        
        /// Subtitle
        var subTitle : String = ""
        switch theSQLList.listOfSQLi[indexPath.row].typeDB {
        case .any:
            subTitle = "Any DB"
        case .mySQL:
            subTitle = "mySQL"
        case .others:
            subTitle = "Other DB"
        }
        cell.detailTextLabel?.text = subTitle

        return cell
    }

    @IBAction func showMenu(_ sender: UIBarButtonItem) {
        if menu == nil {
            let titles = ["Our Ticket #", "Random in Range", "Random in Saved"]
            menu = AZDropdownMenu(titles: titles )
            menu!.overlayColor = UIColor.lightGray
            menu!.overlayAlpha = 0.5
            menu!.itemColor = UIColor.black
            menu!.itemFontColor = UIColor.white
            menu!.itemAlpha = 0.8
            menu!.itemWidth = 150
            menu!.itemOriginX = .right
            
            menu!.cellTapHandler = { [weak self] (indexPath: IndexPath) -> Void in
                var data : DataToCraft = DataToCraft(string: "")
                
                switch indexPath.row {
                case 0:
                    data = DataToCraft(string: scannedTicket.leText)
                case 1:
                    if configQrafter.lowerRangeValue.leText != "" && configQrafter.rangeLength > 0 {
                        data = DataToCraft(string: configQrafter.lowerRangeValue.leText, type: .entier)
                        data.getRandomlyInRange(configQrafter.lowerRangeValue.leText, range: configQrafter.rangeLength)
                    }
                case 2:
                    if savedNumbers.count > 0 {
                        data = savedNumbers[Int(arc4random_uniform(UInt32(savedNumbers.count)))]
                    }
                default:
                    break
                }
                
                self!.menu!.hideMenu()
                self!.codeToAdd = data.leText
                self!.listOfSQLiTableView.reloadData()
                
            }
            
            menu!.showMenuFromView(self.view)
        }
        else {
            menu!.showMenuFromView(self.view)
        }
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "sqliToCraft" {
            configQrafter.isUpdatable = false
            configQrafter.craftFromRangeOrList = .range
            let row = self.tableView.indexPathForSelectedRow?.row
            let stringToCraft = codeToAdd + theSQLList.listOfSQLi[row!].value
            let data = DataToCraft(string: stringToCraft)
            configQrafter.lowerRangeValue = data
        }
    }

}

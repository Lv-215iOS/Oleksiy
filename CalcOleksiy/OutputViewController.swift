//
//  MyViewController.swift
//  CalcOleksiy
//
//  Created by Oleksiy Bilyi on 12/10/16.
//  Copyright © 2016 adminaccount. All rights reserved.
//

import UIKit

protocol OutputInterface {
    func outputInfo(info: String)
}

class OutputViewController: UIViewController, OutputInterface{
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var secondLabel: UILabel!
    
    func outputInfo(info: String){
        label.text = info//
    }
    
    func appendInfo(info: String){
        if label.text != nil {
            label.text = label.text! + info
        } else {
            label.text = info
        }
    }
    
    func fillSecondLabel(str : String) {
        secondLabel.text = str
    }
    
    func  mainLabel() -> String {
        if label.text != nil {
            return label.text!
        }
        return ""
    }
    
    func deleteLast() {
        label.text!.remove(at: label.text!.index(before: label.text!.endIndex))
    }

    
    var mainViewController : ViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

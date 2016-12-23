//
//  InputViewController.swift
//  CalcOleksiy
//
//  Created by Oleksiy Bilyi on 12/12/16.
//  Copyright © 2016 adminaccount. All rights reserved.
//

import UIKit

protocol InputInterface {
    var buttonDidPress: ((String) -> ())? {get set}
}

class InputViewController: UIViewController, InputInterface {
    
    var mainViewController : ViewController? = nil
    var buttonDidPress: ((String) -> ())? = nil
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        buttonDidPress?(sender.currentTitle!)
        //mainViewController?.pressedButton(operation: sender.currentTitle!)//
        
    }

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

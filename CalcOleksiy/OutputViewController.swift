//
//  MyViewController.swift
//  CalcOleksiy
//
//  Created by Oleksiy Bilyi on 12/10/16.
//  Copyright © 2016 adminaccount. All rights reserved.
//

import UIKit

protocol OutputInterface {
    func Output()
}

class OutputViewController: UIViewController {
    
    @IBOutlet weak var Label: UILabel!
    var mainViewController : ViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OutputControllerEmbedSegue" {
            mainViewController = segue.source as? ViewController
        }
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

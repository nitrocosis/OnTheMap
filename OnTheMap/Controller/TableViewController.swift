//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Sarah Rebecca Estrellado on 4/30/19.
//  Copyright © 2019 Sarah Rebecca Estrellado. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UITableViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentArray.sharedInstance.studentArray.count
    }
    
    func displayError(_ errorString: String?) {
        let alert = UIAlertController(title: "Error!", message: errorString, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        UdacityClient.sharedInstance().deleteSession { (success, error) in
            if (error != nil) {
                self.displayError(error?.userInfo.description)
            } else {
                DispatchQueue.main.async {
                    // Close all open VCs
                    self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func refreshButton(_ sender: Any) {
        tableView.reloadData()
    }
    
    @IBAction func addButton(_ sender: Any) {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "InformationPostingViewController") as! InformationPostingViewController
        self.present(controller, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        let student = StudentArray.sharedInstance.studentArray[indexPath.row]
        let mediaURL = StudentArray.sharedInstance.studentArray[indexPath.row].mediaURL
        cell.nameLabel?.text = "\(student.firstName!) \(student.lastName!)"
        cell.img?.image = UIImage(named: "icon_pin")
        cell.detailsLabel?.text = mediaURL
        
        print("Row \(indexPath): nameLabel:\(cell.nameLabel)")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let app = UIApplication.shared
        guard let urlString = StudentArray.sharedInstance.studentArray[indexPath.row].mediaURL,
            let url =  URL(string: urlString) else {
                displayError("Invalid URL")
                return
        }
        
        if app.canOpenURL(url){
            app.open(url, options: [:], completionHandler: nil)
        }
        else{
            displayError("Invalid URL")
        }
        
    }
}



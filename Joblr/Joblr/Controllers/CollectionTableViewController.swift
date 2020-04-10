//
//  CollectionTableViewController.swift
//  Joblr
//
//  Created by 王锴文 on 11/5/19.
//  Copyright © 2019 Bear. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class CollectionTableViewController: UITableViewController {

    var likeds: [Liked] = []
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.likeds.removeAll()
        self.tableView.reloadData()
        self.updateLikedJobs()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.likeds.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobsInfo", for: indexPath) as! CollectionTableViewCell
        // Configure the cell...
        cell.Company.text = self.likeds[indexPath.row].company
        cell.Created_at.text = self.likeds[indexPath.row].created_at
        cell.JobType.text = self.likeds[indexPath.row].type
        cell.Location.text = self.likeds[indexPath.row].location
        cell.Title.text = self.likeds[indexPath.row].title

        if self.likeds[indexPath.row].company_logo != "NULL" {
            cell.Logo.image = self.getIcons(index: indexPath.row)
        }
        else {
            cell.Logo.image = UIImage(named: "Logo_Joblr")
        }
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
        self.db.collection("users").document(self.user!.uid).collection("Jobs").document("\(self.likeds[indexPath.row].company) + \(self.likeds[indexPath.row].title)").delete()
            self.likeds.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } 
    }
    

    override func viewWillAppear(_ animated: Bool) {
        self.likeds.removeAll()
        self.tableView.reloadData()
        self.updateLikedJobs()
    }
    
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func updateLikedJobs() {
        self.db.collection("users").document(user!.uid).collection("Jobs").getDocuments { (snapshot, error) in
            if (error != nil) {
                print(error!)
                // deal with error
                return
            }
            self.likeds.removeAll()
            for doc in snapshot!.documents {
                let title = doc.get("title")
                if title == nil {
                    continue
                }
                self.likeds.append(Liked(type: doc.get("type") as! String, created_at: doc.get("created at") as! String, company: doc.get("company") as! String, location: doc.get("location") as! String, title: doc.get("title") as! String, company_logo: doc.get("logo") as! StringLiteralType))
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
                self?.animateTable()
            }
        }
    }
    
    func getIcons(index: Int) -> UIImage?{
        let url = URL(string: self.likeds[index].company_logo)!
        do {
            let imageData = try Data(contentsOf: url)
            return UIImage(data: imageData)!
        }
        catch {
            print(error)
            return UIImage(named: "Logo_Joblr")
        }
    }
    
    func animateTable() {
        let cells = tableView.visibleCells
        let tableViewHeight = tableView.bounds.size.height
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        
        var delayCounter = 0
        for cell in cells {
            UIView.animate(withDuration: 1.75, delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                cell.transform = .identity
            }, completion: nil)
            delayCounter += 1
        }
    }
}

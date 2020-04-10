//
//  DetailViewController.swift
//  Joblr
//
//  Created by 王锴文 on 11/3/19.
//  Copyright © 2019 Bear. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var job: Job?
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var company: UILabel!
    @IBOutlet weak var jobtitle: UILabel!
    @IBOutlet weak var descript: UITextView!
    
    let literal = StringLiteralType("<br><b>How to Apply:</b><br><br>")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if self.job == nil {
            return
        }
        self.company.text = self.job?.company
        self.jobtitle.text = self.job?.title
        let str = self.job!.description + literal + self.job!.how_to_apply
        self.descript.attributedText = str.htmlToAttributedString
        self.descript.isEditable = false
        self.logo.image = self.getIcons()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func getIcons() -> UIImage?{
        if self.job!.company_logo == nil {
            return UIImage(named: "Logo_Joblr")
        }
        let url = URL(string: self.job!.company_logo!)!
        do {
            let imageData = try Data(contentsOf: url)
            return UIImage(data: imageData)!
        }
        catch {
            print(error)
            return UIImage(named: "Logo_Joblr")
        }
    }
}

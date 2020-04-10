//
//  MainPageViewController.swift
//  Joblr
//
//  Created by 王锴文 on 10/26/19.
//  Copyright © 2019 Bear. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import MapKit
import Poi

class MainPageViewController: UIViewController, UITextViewDelegate, CLLocationManagerDelegate, PoiViewDataSource, PoiViewDelegate, UITextFieldDelegate {
    
    let db = Firestore.firestore()
//    let locationmanager = CLLocationManager()
    var curLocation: CLLocation?
    var Jobs: [Job] = []
    var Icons: [UIImage?] = []
    var sampleCards = [UIView]()
    var url = URLHead(description: nil, location: nil)
    
    @IBOutlet weak var poiView: PoiView!
    
    @IBOutlet weak var Location: UITextField!
        
    @IBOutlet weak var Description: UITextField!
    
    @IBAction func CheckDetail(_ sender: Any) {
        print("current index of sampleCards = \(self.poiView.currentCount)")
    }
        
    @IBAction func dislike(_ sender: Any) {
        self.poiView.swipeCurrentCard(to: .left)
    }
        
    @IBAction func reload(_ sender: Any) {
        self.poiView.undo()
    }
    
    @IBAction func like(_ sender: Any) {
        self.poiView.swipeCurrentCard(to: .right)
        // store
    }
    
    @IBAction func Search(_ sender: UIButton) {
        
        url.description = stringParser(source: Description.text!)
        url.location = stringParser(source: Location.text!)
        
        getData(is_init: false)
        
        print("successful load data from Jobs")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Location.delegate = self
        Description.delegate = self
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true

        getData(is_init: true)
            
        print("load over")
    }
    
    @objc func dismissKeyboard() {
        Description.resignFirstResponder()
        Location.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
        
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        //self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
        
    // MARK: - PoiViewDataSource
    func poi(_ poi: PoiView, viewForCardAt index: Int) -> UIView {
        return sampleCards[index]
    }
        
    func numberOfCards(_ poi: PoiView) -> Int {
        return self.Jobs.count
    }
        
    func poi(_ poi: PoiView, viewForCardOverlayFor direction: SwipeDirection) -> UIImageView? {
        switch direction {
        case .right:
            return nil
//            return UIImageView(image: #imageLiteral(resourceName: "icons8-search-50.png"))
        case .left:
            return nil
        }
    }
        
    func poi(_ poi: PoiView, runOutOfCardAt: Int, in direction: SwipeDirection) {
        print("last")
    }
        
    func poi(_ poi: PoiView, didSwipeCardAt: Int, in direction: SwipeDirection) {
        switch direction {
        case .left:
            print("left")
        case .right:
            print("right")
            self.storeJobs(index: self.poiView.currentCount - 1)
        }
    }
        
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.curLocation = locations.last!
    }

    /*
    MARK: - Navigation

    In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        Get the new view controller using segue.destination.
        Pass the selected object to the new view controller.
    }
    */

    func getData(is_init: Bool) {
        let mySession = URLSession(configuration: URLSessionConfiguration.default)
        
        var str_url = self.url.head
            
//        str_url += "lat=\(curLocation!.coordinate.latitude)&long=\(curLocation!.coordinate.longitude)"
            
        if is_init {
            str_url += "lat=37.3229978&long=-122.0321823"
        }
        else {
            if self.url.description != nil {
                str_url += "description=\(self.url.description!)&"
            }
            if self.url.location != nil {
                str_url += "location=\(self.url.location!)"
            }
        }

        print(str_url)
        
        let url_to_send = URL(string: str_url)!
            
        let task = mySession.dataTask(with: url_to_send) { data, response, error in
                       
            guard error == nil else {
                print("error: \(error!)")
                return
            }
                       
            guard let content = data else {
                print("no data!")
                // alert user there's no job according to the settings
                self.showErrorPopUp("Can't find any job based on current settings.", "No Result!")
                return
            }
                       
            let decoder = JSONDecoder()
            do {
                self.Jobs.removeAll()
                self.Jobs = try decoder.decode([Job].self, from: content)
                print("Got all the data into allTodos!")
                self.getIcons()
//                DispatchQueue.main.async {
//                    self.updateJobsView()
//                }
            }
            catch {
                print("JSON Decode error")
            }
        }
        task.resume()
    }
        
    func getView(index: Int) -> UIView {
        let newView = UIView(frame: CGRect(x: 0, y: 0, width: 360, height: 480))
        newView.layer.borderColor = UIColor(red:222/255, green:225/255, blue:227/255, alpha: 1).cgColor
        newView.layer.borderWidth = 2
        let frame = newView.bounds
        
        let icon = UIImageView()
        icon.frame = CGRect(x: frame.width / 2 - 40, y: 10, width: 80, height: 80)
        if self.Icons[index] == nil {
            //icon
            icon.image = UIImage(named: "Logo_Joblr")
        }
        else {
            icon.image = self.Icons[index]!
        }
        
        let company = UILabel(frame: CGRect(x: frame.width / 2 - 100, y: 95, width: 200, height: 20))
        company.text = self.Jobs[index].company
        company.font = UIFont(name: "AmericanTypewriter-Bold", size: 18)
        company.textAlignment = .center
        
        let desc = UILabel(frame: CGRect(x: frame.width / 2 - 150, y: 150, width: 300, height: 20))
        desc.text = "Job Title"
        desc.textAlignment = .center
        desc.font = UIFont(name: "Arial-BoldItalicMT", size: 14)
        
        let title = UILabel(frame: CGRect(x: frame.width / 2 - 150, y: 160, width: 300, height: 60))
        title.text = self.Jobs[index].title
        title.textAlignment = .center
        title.font = UIFont(name: "BodoniSvtyTwoOSITCTT-Bold", size: 18)
        title.numberOfLines = 0
        
        let desc2 = UILabel(frame: CGRect(x: frame.width / 2 - 150, y: 255, width: 300, height: 20))
        desc2.text = "Location"
        desc2.textAlignment = .center
        desc2.font = UIFont(name: "Arial-BoldItalicMT", size: 14)
        
        let job_addr = UILabel(frame: CGRect(x: frame.width / 2 - 150, y: 265, width: 300, height: 60))
        job_addr.text = self.Jobs[index].location
        job_addr.textAlignment = .center
        job_addr.font = UIFont(name: "BodoniSvtyTwoOSITCTT-Bold", size: 18)
        job_addr.numberOfLines = 0
        
        let desc3 = UILabel(frame: CGRect(x: frame.width / 2 - 150, y: 360, width: 300, height: 20))
        desc3.text = "Created At"
        desc3.textAlignment = .center
        desc3.font = UIFont(name: "Arial-BoldItalicMT", size: 14)

        let created_at = UILabel(frame: CGRect(x: frame.width / 2 - 150, y: 370, width: 300, height: 60))
        created_at.text = self.Jobs[index].created_at
        created_at.textAlignment = .center
        created_at.font = UIFont(name: "Charter-Bold", size: 18)
        
        newView.addSubview(icon)
        newView.addSubview(company)
        newView.addSubview(desc)
        newView.addSubview(title)
        newView.addSubview(desc2)
        newView.addSubview(job_addr)
        newView.addSubview(desc3)
        newView.addSubview(created_at)

        newView.layer.cornerRadius = 30
        
        newView.backgroundColor = UIColor.init(red: 116/255, green: 185/255, blue: 255/255, alpha: 1)
        return newView
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
            if self.poiView.currentCount >= self.Jobs.count {
                return
            }
            let destVC = segue.destination as! DetailViewController
            destVC.job = self.Jobs[self.poiView.currentCount]
        }
    }
        
    func updateJobsView() {
        self.loadView()
        self.sampleCards.removeAll()
        for i in 0..<self.Jobs.count {
            self.sampleCards.append(getView(index: i))
        }
        self.poiView.layoutIfNeeded()
        self.poiView.dataSource = self
        self.poiView.delegate = self
    }
        
    func showErrorPopUp(_ message: String, _ title: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))

        self.present(alertController, animated: true, completion: nil)
    }
    
    func storeJobs(index: Int) {
        let liked = self.Jobs[index]
        let doc_id = String("\(liked.company) + \(liked.title)")
        db.collection("users").document(Auth.auth().currentUser!.uid).collection("Jobs").document(doc_id).setData(["title": liked.title, "company": liked.company, "location": liked.location, "created at": liked.created_at, "type": liked.type, "logo": liked.company_logo ?? "NULL"])
    }
    
    func getIcons() {
        self.Icons.removeAll()
        for job in self.Jobs {
            if job.company_logo == nil {
                self.Icons.append(nil)
                continue
            }
            let url = URL(string: job.company_logo!)!
            do {
                let imageData = try Data(contentsOf: url)
                self.Icons.append(UIImage(data: imageData))
            }
            catch {
                print(error)
            }
        }
        DispatchQueue.main.async {
            self.updateJobsView()
        }
    }
}

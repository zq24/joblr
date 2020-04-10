//
//  ViewController.swift
//  Joblr
//
//  Created by 王锴文 on 10/24/19.
//  Copyright © 2019 Bear. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    
    // var videoPlayer: AVPlayer?
    var videoPlayer: AVQueuePlayer?
    
    var videoPlayerLayer: AVPlayerLayer?
    
    var playerLooper: AVPlayerLooper?

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpUI()
    }
    
    func setUpUI() {
        UIDecorator.styleFilledButton(signUpButton)
        UIDecorator.styleHollowButton(loginButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpVideo()
    }
    
    func setUpVideo() {
        
        let bundlePath = Bundle.main.path(forResource: "handshake", ofType: "mp4")
        
        guard bundlePath != nil else {
            return
        }
        
        let url = URL(fileURLWithPath: bundlePath!)
        
        let duration = Int64( ( (Float64(CMTimeGetSeconds(AVAsset(url: url).duration)) *  10.0) - 1) / 10.0 )
        
        let item = AVPlayerItem(url: url)
        
        // videoPlayer = AVPlayer(playerItem: item)
        videoPlayer = AVQueuePlayer()
        
        videoPlayerLayer = AVPlayerLayer(player: videoPlayer!)
        
        playerLooper = AVPlayerLooper(player: videoPlayer!, templateItem: item, timeRange: CMTimeRange(start: CMTime.zero, end: CMTimeMake(value: duration, timescale: 1)))
        
        videoPlayerLayer?.frame = CGRect(x: -self.view.frame.size.width * 1.5, y: 0, width: self.view.frame.size.width * 4, height: self.view.frame.size.height)
        
        view.layer.insertSublayer(videoPlayerLayer!, at: 0)
        
        videoPlayer?.playImmediately(atRate: 1.0)
    }
    
}


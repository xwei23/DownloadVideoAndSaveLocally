//
//  ViewController.swift
//  downloadVideoSaveLocally
//
//  Created by Xuelun Wei on 6/28/18.
//  Copyright © 2018 sellen wei. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
import AVKit

class ViewController: UIViewController, URLSessionDownloadDelegate{
    
    @IBOutlet weak var statusLabel: UILabel!
    let urlPath = "https://www.robpapen.com/dmdocuments/RAW_HARDCORE_demo_DJ-Promo_Free-K.mp3"
    var myPath: String?
    var player: AVPlayer?
    
    @IBAction func startButton(_ sender: Any) {
        let url = URL(string:urlPath)
        let config = URLSessionConfiguration.default
        let mySession = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
        let task = mySession.downloadTask(with: url!)
        task.resume()
    }
    
    
    @IBAction func playVideoButton(_ sender: Any) {
        let item = AVPlayerItem(url: URL(fileURLWithPath: myPath!))
        player = AVPlayer(playerItem: item)
        player?.play()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func urlSession(_ session: URLSession,
                         downloadTask: URLSessionDownloadTask,
                         didWriteData bytesWritten: Int64,
                         totalBytesWritten: Int64,
                         totalBytesExpectedToWrite: Int64){
        
        let totalSize = Float((totalBytesExpectedToWrite/1024)/1024)
        let writtenSize = Float((totalBytesWritten/1024)/1024)
        self.statusLabel.text = "Downloading ...\(writtenSize) MB of \(totalSize) MB"
    }
    
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL){
        self.statusLabel.text = "Download Completed"
        let pathUserWantToSaveTo = urlPath.components(separatedBy: "/").last
        myPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first?.appending("/\(pathUserWantToSaveTo!)")
        let fileManager = FileManager.default
        do {
            try fileManager.moveItem(at: location, to: URL(fileURLWithPath: myPath!))
        }catch let error {
            print("move file failed, \(error)")
        }
    }
}


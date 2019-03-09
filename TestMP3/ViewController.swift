//
//  ViewController.swift
//  TestMP3
//
//  Created by user on 1/22/19.
//  ViewController1
//  Copyright © 2019 Home Work Student. All rights reserved.
//

import UIKit
import AVFoundation

var globalSelectedFileToPlay: String = "firstStart"
var globalCurrrentFolder: String = ""
var globalListMusicFilesInThisFolder : [String] = []

class ViewController: UIViewController, UINavigationControllerDelegate{/*, TableViewControllerDelegate{
    func didSelectColor( text: String) {
        print("Did Send Text: \(text)")
        labelText.text = text
     hiden function
    }
*/
    
    var player = AVAudioPlayer()
    var timer : Timer?
    var lastSelectedFileToPlay : String = ""
    
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var imageViewTitleAlbum: UIImageView!
    @IBOutlet weak var labelNameFiletoPlay: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(globalSelectedFileToPlay)
        print(globalCurrrentFolder)
        print(globalListMusicFilesInThisFolder)
        print(lastSelectedFileToPlay)
        
        if globalSelectedFileToPlay != "firstStart"{
            enableTimer()
            rotationTitleAlbum()
            if lastSelectedFileToPlay != globalSelectedFileToPlay{
                playFile()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progress.progress = 0
        
        imageViewTitleAlbum.layer.cornerRadius = imageViewTitleAlbum.frame.size.width / 2
        imageViewTitleAlbum.clipsToBounds = true
    }
    
    func rotationTitleAlbum(){
        let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = Double.pi * 2
        rotation.duration = 30 // or however long you want ...
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        imageViewTitleAlbum.layer.add(rotation, forKey: "rotationAnimation")
        return
    }
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goSegue"{
            let vc = segue.destination as! TableViewController
            vc.colorString = "redColor"
        }
    }
 */
    
    func playFile(){
        if globalSelectedFileToPlay != "firstStart"{
            guard let url = Bundle.main.url(forAuxiliaryExecutable: "\(globalCurrrentFolder)/\(globalSelectedFileToPlay)") else { return }
            
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)
                
                /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
                player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
                player.prepareToPlay()
                labelNameFiletoPlay.text = globalSelectedFileToPlay
                player.play()
                enableTimer()
                rotationTitleAlbum()
            } catch let error {
                print(error.localizedDescription)
            }  
        }
        return
    }
    
    func playNextTrack(){
        let numberCurrentTracks : Int = globalListMusicFilesInThisFolder.firstIndex(of: globalSelectedFileToPlay)!
        //print(numberCurrentTracks)
        let numberNextTrack : Int = numberCurrentTracks + 1
        print(numberNextTrack)
        if numberNextTrack < globalListMusicFilesInThisFolder.count{
            globalSelectedFileToPlay = globalListMusicFilesInThisFolder[numberNextTrack]
            print(globalSelectedFileToPlay)
            playFile()
        }else{
            imageViewTitleAlbum.layer.removeAllAnimations()
            progress.progress = 0
            //globalSelectedFileToPlay = globalListMusicFilesInThisFolder[0]
            player.stop()
            labelNameFiletoPlay.text = ""
            globalSelectedFileToPlay = "firstStart"
        }
        return
    }
    
    @IBAction func buttonPlay(_ sender: UIButton) {
        playFile()
    }
    
    @IBAction func forward(_ sender: UIButton) {
        if globalSelectedFileToPlay != "firstStart"{
            var time : TimeInterval = (player.currentTime)
            time += 5.0
            if time > (player.duration){
                // stop, track skip or whatever you want
            }else{
                player.currentTime = time
            }
        }
    }
    
    @IBOutlet weak var pauseBtn: UIButton!
    @IBAction func pauseResume(_ sender: UIButton) {
        if globalSelectedFileToPlay != "firstStart"{
            if(player.isPlaying == true){
                endTimer()
                player.pause()
                pauseBtn.setTitle("Resume", for: .normal)
                imageViewTitleAlbum.layer.removeAllAnimations()
            }else{
                player.play()
                enableTimer()
                pauseBtn.setTitle("Pause", for: .normal)
                rotationTitleAlbum()
            }
            
        }
    }
     
    @IBAction func listFiles(_ sender: UIButton) {
        lastSelectedFileToPlay = globalSelectedFileToPlay
    }
    
    func enableTimer(){
        if globalSelectedFileToPlay != "firstStart"{
            timer = Timer(timeInterval: 0.1, target: self, selector: (#selector(self.updateProgress)), userInfo: nil, repeats: true)
            RunLoop.main.add(timer!, forMode: RunLoop.Mode(rawValue: "NSDefaultRunLoopMode"))
        }
    }
    func endTimer(){
        if(timer != nil){
            timer!.invalidate()
        }
    }
    
    @objc func updateProgress(){
        if globalSelectedFileToPlay != "firstStart"{
            player.updateMeters() //refresh state
            progress.progress = Float(player.currentTime/player.duration)
            //print(Float(player.currentTime/player.duration))
            if Float(player.currentTime/player.duration) > 0.998{
                playNextTrack()
            }
        }
    }
}

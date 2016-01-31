//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Sydney Mercier on 1/9/16.
//  Copyright © 2016 Sydney Mercier. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        audioPlayer = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL)
        audioPlayer.enableRate = true

       // From stack overflow
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathURL)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func slowAudio(sender: UIButton) {
        // Play slow audio
        playAudioWithVariableRate(0.5)
    }
    
    @IBAction func fastAudio(sender: UIButton) {
        // Play fast audio
        playAudioWithVariableRate(1.5)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        // From stack overflow
        stopPlayersAndEngines()
        audioEngine.reset()
        
        let pitchPlayer = AVAudioPlayerNode()
        audioEngine.attachNode(pitchPlayer)
        
        let timePitch = AVAudioUnitTimePitch()
        timePitch.pitch = pitch
        audioEngine.attachNode(timePitch)
        
        audioEngine.connect(pitchPlayer, to: timePitch, format: nil)
        audioEngine.connect(timePitch, to: audioEngine.outputNode, format: nil)
        
        pitchPlayer.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        try! audioEngine.start()
        
        pitchPlayer.play()
    }
    
    func playAudioWithVariableRate(rate: Float) {
        stopPlayersAndEngines()
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    func stopPlayersAndEngines() {
        audioPlayer.stop()
        audioEngine.stop()
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        stopPlayersAndEngines() // stop all audio from playing
        audioPlayer.currentTime = 0 // resets audio to start
    }
    
    

}

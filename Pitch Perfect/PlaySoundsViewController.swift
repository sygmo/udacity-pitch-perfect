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
    var audioPlayerEcho:AVAudioPlayer! // for echo effect
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        audioPlayer = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL)
        audioPlayer.enableRate = true
        
        // For echo effect
        audioPlayerEcho = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL)

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
    
    @IBAction func playEchoAudio(sender: UIButton) {
        // Icon image from Ryan Collins: https://github.com/RyanCCollins/Pitch-Perfect
        //TODO: create new audioPlayer, play after first
        stopPlayersAndEngines()
        audioPlayer.play()
        
        let echoDelay = 0.5
        let playTime = audioPlayerEcho.deviceCurrentTime + echoDelay
        audioPlayerEcho.stop()
        audioPlayerEcho.volume = 0.4
        audioPlayerEcho.playAtTime(playTime)
        
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
        audioPlayer.play()
    }
    
    func stopPlayersAndEngines() {
        audioPlayer.stop()
        audioPlayerEcho.stop()
        audioPlayer.currentTime = 0.0
        audioPlayerEcho.currentTime = 0.0
        audioEngine.stop()
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        stopPlayersAndEngines() // stop all audio from playing
    }
    
    

}

//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Sydney Mercier on 12/3/15.
//  Copyright © 2015 Sydney Mercier. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        // Hide the stop button
        stopButton.hidden = true
        recordButton.enabled = true
        pauseButton.hidden = true
        resumeButton.hidden = true
        recordingInProgress.hidden = false
        recordingInProgress.text = "Tap to Record"
    }

    @IBAction func recordAudio(sender: UIButton) {
        recordingInProgress.text = "Recording in Progress..."
        stopButton.hidden = false
        recordButton.enabled = false
        pauseButton.hidden = false

        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        // Set up audio session
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        // Ensure sound comes from correct speaker (code from forum)
        try! session.setActive(true)
        try! session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self // self refers to RecordSoundsViewController
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    @IBAction func stopRecording(sender: UIButton) {
        recordingInProgress.hidden = true
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance();
        try! audioSession.setActive(false)
    }
    
    @IBAction func pauseRecording(sender: UIButton) {
        // Icon image from Ryan Collins: https://github.com/RyanCCollins/Pitch-Perfect
        pauseButton.hidden = true
        resumeButton.hidden = false
        audioRecorder.pause()
    }
    
    
    @IBAction func resumeRecording(sender: UIButton) {
        // Icon image from Ryan Collins: https://github.com/RyanCCollins/Pitch-Perfect
        pauseButton.hidden = false
        resumeButton.hidden = true
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag){
            // Step 1 - save the recorded audio
            recordedAudio = RecordedAudio(filePathURL: recorder.url, title: recorder.url.lastPathComponent)
            recordedAudio.filePathURL = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent // gives name of recorder file
        
            //Step 2 - move to the next scene - perform segue
            performSegueWithIdentifier("stopRecording", sender: recordedAudio) // recordedAudio initiates segue
        }else{
            print("Recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
            resumeButton.hidden = true
            pauseButton.hidden = true
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // sender is RecordedAudio
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    
}


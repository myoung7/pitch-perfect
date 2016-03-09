//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Matthew Young on 12/2/15.
//  Copyright © 2015 Matthew Young. All rights reserved.
//

import UIKit
import AVFoundation

final class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio?
    var currentlyRecordingAudio: Bool = false
    var recordingIsPaused: Bool = false
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        stopButton.hidden = true
        statusLabel.hidden = true
        statusLabel.text = "Recording..."
        instructionLabel.text = "Tap to Record"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if (flag) {
            recordedAudio = RecordedAudio(filePathURL: recorder.url, title: recorder.url.lastPathComponent!)
            statusLabel.text = "Saved!"
            performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            statusLabel.text = "Whoops...an error occurred. Let's try again."
            instructionLabel.text = "Tap to Record"
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }

    @IBAction func recordAudio(sender: UIButton) {
        if (currentlyRecordingAudio == false) {
            instructionLabel.text = "Tap to Pause"
            statusLabel.text = "Recording..."
            statusLabel.hidden = false
            currentlyRecordingAudio = true
            stopButton.hidden = false
            
            let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String

            let recordingName = "my_audio.wav"
            let pathArray = [dirPath, recordingName]
            let filePath = NSURL.fileURLWithPathComponents(pathArray)
            
            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            
            try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
        } else {
            if (recordingIsPaused == false) {
                audioRecorder.pause()
                instructionLabel.text = "Tap to Resume"
                statusLabel.text = "PAUSED"
                recordingIsPaused = true
            } else {
                audioRecorder.record()
                instructionLabel.text = "Tap to Pause"
                statusLabel.text = "Recording..."
                recordingIsPaused = false
            }
        }
    }

    @IBAction func stopButtonPressed(sender: UIButton) {
        instructionLabel.text = "Please Wait"
        statusLabel.text = "Saving your recording..."
        recordButton.enabled = true
        stopButton.hidden = true
        currentlyRecordingAudio = false
        recordingIsPaused = false
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
}


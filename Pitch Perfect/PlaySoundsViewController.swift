//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Matthew Young on 12/11/15.
//  Copyright © 2015 Matthew Young. All rights reserved.
//

import UIKit
import AVFoundation

final class PlaySoundsViewController: UIViewController {

    let session = AVAudioSession.sharedInstance()
    let audioFilePath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3")
    var audioPlayer = AVAudioPlayer()
    var receivedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine = AVAudioEngine()
    var audioFile: AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()

        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathURL)

        do {        //Makes sure that the audio outputs to the speaker on an iPhone, not the handset speaker.
            try session.overrideOutputAudioPort(.Speaker)
        } catch {
            print("ERROR: Could not override audio output to speaker.")
        }

        try! audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL)
        audioPlayer.enableRate = true
    }

    @IBAction func locationReverbButtonPressed(sender: UIButton) {
        var reverbPreset: AVAudioUnitReverbPreset?
        
        switch sender.tag {
        case 3: reverbPreset = .SmallRoom
        case 4: reverbPreset = .LargeRoom
        case 5: reverbPreset = .MediumHall
        case 6: reverbPreset = .LargeHall
        case 7: reverbPreset = .Cathedral
        default: print("ERROR: Sender tag not found.")
        }
        
        guard let preset = reverbPreset else {
            print("ERROR: Could not load Reverb Effect.")
            return
        }
        
        playAudioWithReverb(preset)
    }

    @IBAction func audioButtonPressed(sender: UIButton) {
        stopAllAudio()
        
        switch sender.tag {
        case 0:     //Plays audio slowly
            audioPlayer.currentTime = 0
            audioPlayer.rate = 0.5
            audioPlayer.play()
        case 1:     //Plays audio quickly
            audioPlayer.currentTime = 0
            audioPlayer.rate = 2.0
            audioPlayer.play()
        default:
            print("ERROR: Button tag not found.")
        }
    }

    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1200)
    }

    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }

    @IBAction func stopAudioButtonPressed(sender: UIButton) {
        stopAllAudio()
    }

    func playAudioWithReverb(reverbPreset: AVAudioUnitReverbPreset) {
        stopAllAudio()

        let playerNode = AVAudioPlayerNode()
        let reverbEffect = AVAudioUnitReverb()

        reverbEffect.loadFactoryPreset(reverbPreset)
        reverbEffect.wetDryMix = 50

        audioEngine.attachNode(playerNode)
        audioEngine.attachNode(reverbEffect)

        audioEngine.connect(playerNode, to: reverbEffect, format: nil)
        audioEngine.connect(reverbEffect, to: audioEngine.outputNode, format: nil)

        playerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)

        try! audioEngine.start()

        playerNode.play()
    }

    func playAudioWithVariablePitch(pitch: Float) {
        stopAllAudio()

        let playerNode = AVAudioPlayerNode()
        let pitchEffect = AVAudioUnitTimePitch()
        pitchEffect.pitch = pitch

        audioEngine.attachNode(playerNode)
        audioEngine.attachNode(pitchEffect)

        audioEngine.connect(playerNode, to: pitchEffect, format: nil)
        audioEngine.connect(pitchEffect, to: audioEngine.outputNode, format: nil)

        playerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)

        try! audioEngine.start()

        playerNode.play()

    }

    func stopAllAudio() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.currentTime = 0
    }

}

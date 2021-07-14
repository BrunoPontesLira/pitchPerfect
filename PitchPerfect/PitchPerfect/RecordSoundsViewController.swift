//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Bruno Pontes Lira on 01/07/21.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI(recording: false)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(recording: false)
    }
    

    @IBAction func recordAudio(_ sender: AnyObject) {
        configureUI(recording: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/") )
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, options: .defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: AnyObject) {
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        configureUI(recording: false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        // Chama a PlaySoundsViewController
        if flag{
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("Recording was not successful")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {                     //verifica se é a transição que queremos
            let playSoundsVC = segue.destination as! PlaySoundsViewController //Usa a ViewController que queremos
            let recordeAudioURL = sender as! URL // GET a URL/Path do audio
            playSoundsVC.recordedAudioURL = recordeAudioURL //Passa a URL/Path para a ViewController
        }

    }
    
    private func configureUI(recording: Bool) {
        recordButton.isEnabled = !recording
        stopRecordingButton.isEnabled = recording
        recordingLabel.text = recording ? "Recording in progress" : "Tap to record"
    }
    
    
}


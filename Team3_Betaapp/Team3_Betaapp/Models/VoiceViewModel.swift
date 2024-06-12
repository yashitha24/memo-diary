//
//  VoiceViewModel.swift
//  Team3_Betaapp
//
//  Created by Yashitha Vilasagarapu on 11/1/23.
//

import Foundation
import AVFoundation

class VoiceViewModel : NSObject, ObservableObject , AVAudioPlayerDelegate{
    var calendarVM: CalendarViewModel // Reference to the CalendarViewModel.
    var audioRecorder : AVAudioRecorder! // AVAudioRecorder for recording audio.
    var audioPlayer : AVAudioPlayer! // AVAudioPlayer for playing audio recordings.
    
    var indexOfPlayer = 0
    @Published var isRecording : Bool = false // Flag to indicate whether recording is in progress.
    @Published var recordingsList = [Recording]() // List of recorded audio files.
    
    @Published var countSec = 0 // Count of seconds for recording.
    @Published var timerCount : Timer? // Timer for updating the recording timer.
    @Published var blinkingCount : Timer? // Timer for blinking effect.
    @Published var timer : String = "0:00" // Formatted recording timer.
    @Published var toggleColor : Bool = false // Flag for blinking color effect.
    
    var playingURL : URL?
    
    init(calendarViewModel: CalendarViewModel){
        self.calendarVM = calendarViewModel
        super.init()
        fetchAllRecording() // Fetch all existing audio recordings.
    }
    
    // AVAudioPlayerDelegate method called when audio playback finishes.
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        for i in 0..<recordingsList.count {
            if recordingsList[i].fileURL == playingURL {
                recordingsList[i].isPlaying = false
            }
        }
    }
    
    
    // Function to start recording audio.
    func startRecording() {
        // Configure audio recording session.
        let recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Cannot setup the Recording")
        }
        let dateToUse = calendarVM.selectedDate ?? Date()
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileName = path.appendingPathComponent("Moment : \(dateToUse.toString(dateFormat: "dd-MM-YY 'at' HH:mm:ss")).m4a")
        
        
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        
        do {
            audioRecorder = try AVAudioRecorder(url: fileName, settings: settings)
            audioRecorder.prepareToRecord()
            audioRecorder.record()
            isRecording = true
            // Start the timer for recording duration.
            timerCount = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (value) in
                self.countSec += 1
                self.timer = self.covertSecToMinAndHour(seconds: self.countSec)
            })
            blinkColor()             // Start the blinking effect.
            
        } catch {
            print("Failed to Setup the Recording")
        }
    }
    
    // Function to stop recording audio.
    func stopRecording(){
        
        audioRecorder.stop()
        
        isRecording = false
        
        self.countSec = 0
        
        timerCount!.invalidate()
        blinkingCount!.invalidate()
        
    }
    
    
    // Function to fetch all existing audio recordings.
    func fetchAllRecording(){
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryContents = try! FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: nil)
        for i in directoryContents {
            recordingsList.append(Recording(fileURL : i, createdAt:getFileDate(for: i), isPlaying: false))
        }
        // Sort the recordings by creation date in descending order.
        recordingsList.sort(by: { $0.createdAt.compare($1.createdAt) == .orderedDescending})
    }
    
    
    // Function to start playing audio from a specific URL.
    func startPlaying(url : URL) {
        playingURL = url
        let playSession = AVAudioSession.sharedInstance()
        do {
            try playSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch {
            print("Playing failed in Device")
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            
            for i in 0..<recordingsList.count {
                if recordingsList[i].fileURL == url {
                    recordingsList[i].isPlaying = true
                }
            }
            
        } catch {
            print("Playing Failed")
        }
        
        
    }
    
    // Function to stop playing audio from a specific URL.
    func stopPlaying(url : URL) {
        audioPlayer.stop()
        for i in 0..<recordingsList.count {
            if recordingsList[i].fileURL == url {
                recordingsList[i].isPlaying = false
            }
        }
    }
    
    
    // Function to delete a recorded audio file at a specific URL.
    func deleteRecording(url : URL) {
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print("Can't delete")
        }
        
        for i in 0..<recordingsList.count {
            
            if recordingsList[i].fileURL == url {
                if recordingsList[i].isPlaying == true{
                    stopPlaying(url: recordingsList[i].fileURL)
                }
                recordingsList.remove(at: i)
                
                break
            }
        }
    }
    
    func blinkColor() {
        // Function to create a blinking color effect.
        blinkingCount = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true, block: { (value) in
            self.toggleColor.toggle()
        })
        
    }
    
    // Function to get the creation date of a file.
    func getFileDate(for file: URL) -> Date {
        if let attributes = try? FileManager.default.attributesOfItem(atPath: file.path) as [FileAttributeKey: Any],
           let creationDate = attributes[FileAttributeKey.creationDate] as? Date {
            return creationDate
        } else {
            return Date()
        }
    }
    
    
    
}





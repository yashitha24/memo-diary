//
//  NoteEditorView.swift
//  Team3_Betaapp
//
//  Created by Yashitha Vilasagarapu on 10/29/23.
//
import SwiftUI
import Speech
import PhotosUI

/*
 Represents a view for editing notes, including features like emotion detection, speech recognition, and image handling.
 */
struct NoteEditorView: View {
    // ViewModel for managing calendar-related data.
    @ObservedObject var viewModel: CalendarViewModel
    // Location manager for accessing the user's location.
    @ObservedObject private var locationManager1 = LocationManager1()
    // The date for which the note is being edited or created.
    
    var date: Date
    // Binding to manage the selected tab in the parent view.
    
    // Various state variables to handle text input, UI changes, and multimedia features.
    @Binding var selectedTab: Int
    @State private var text: String = ""
    @Environment(\.presentationMode) var presentationMode
    @State private var emotion: String = "Neutral"
    @State private var backgroundColorEmotion: String = "Neutral"
    @State private var showEmotionAlert = false
    @State private var previousTranscription: String = ""
    @State private var processedSegments = Set<SFTranscriptionSegment>()
    @State private var itemProviders: [NSItemProvider] = []
    @State private var isImagePickerPresented = false
    @State private var isCameraPresented = false
    @State private var isAudioRecordingViewPresented = false
    @State private var images: [UIImage] = []
    @State private var existingImages: [UIImage] = []
    @State private var newImages: [UIImage] = []
    @State private var isRecording = false
    
    // Speech recognition properties
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    @State private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    @State private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    @State private var finalEmotion: String?
    var body: some View {
        VStack {
            // Custom text editor and other UI components
            CustomTextEditor(backgroundColor: UIColor.from(color: colorForEmotion(backgroundColorEmotion)), text: $text)
                .onChange(of: text) { newValue in
                    emotion = classifyEmotion(from: newValue)
                }
            
            Spacer()
            // ScrollView for displaying selected images
            HStack{
                
                Button(action: {
                    isImagePickerPresented = true
                }) {
                    Image(systemName: "photo")
                        .foregroundColor(.blue)
                        .padding()
                        .background(Circle().fill(Color.white))
                        .shadow(radius: 10)
                }
                
                Spacer()
                Button(action: {
                    isAudioRecordingViewPresented = true
                }) {
                    Image(systemName: "speaker.circle.fill")
                        .foregroundColor(.blue)
                        .padding()
                        .background(Circle().fill(Color.white))
                        .shadow(radius: 10)
                }
                
                Spacer()
                Button(action: {
                    isCameraPresented = true
                }) {
                    Image(systemName: "camera")
                        .foregroundColor(.blue)
                        .padding()
                        .background(Circle().fill(Color.white))
                        .shadow(radius: 10)
                }
                Spacer()
                Button(action: {
                    if isRecording {
                        stopRecording()
                    } else {
                        startRecording()
                    }
                    isRecording.toggle()
                }, label: {
                    Image(systemName: isRecording ? "mic.fill" : "mic")
                        .foregroundColor(isRecording ? .red : .blue)
                        .padding()
                        .background(Circle().fill(Color.white))
                        .shadow(radius: 10)
                })
            }
            ScrollView(.horizontal) {
                HStack {
                    ForEach(existingImages, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                            .padding(5)
                    }
                    ForEach(newImages, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                            .padding(5)
                    }
                }
            }
            .padding()
            
            HStack{
                // Buttons for 'Done' and 'Cancel' actions
                Button(action: {
                    showEmotionAlert = true
                }, label: {
                    Text("Done")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(CustomColor.blue)
                        .cornerRadius(10)
                        .padding()
                })
                Button(action: {
                    
                    selectedTab = 0
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Cancel")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(CustomColor.blue)
                        .cornerRadius(10)
                        .padding()
                })
            }
        }
        .alert("Confirm Emotion", isPresented: $showEmotionAlert, presenting: emotion) { detail in
            Button("Save as \(detail)") {
                finalEmotion = detail
                saveNote()
            }
            
            ForEach(["Happy", "Sad", "Angry", "Suprised", "Disgusted", "Fearful", "Neutral"], id: \.self) { emotion in
                if emotion != detail {
                    Button(emotion) {
                        finalEmotion = emotion
                        saveNote()
                    }
                }
            }
        } message: { detail in
            Text("The detected emotion is \(detail). Is this correct or would you like to select a different emotion?")
        }
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(isPresented: $isImagePickerPresented, selectedImages: $newImages)
        }
        .sheet(isPresented: $isAudioRecordingViewPresented) {
            NavigationView {
                AudioRecordingView()
            }
        }
        .sheet(isPresented: $isCameraPresented) {
            CameraView(isPresented: $isCameraPresented, selectedImages: $newImages)
        }
        //        .navigationTitle("Note")
        .onAppear {
            loadData()
            
        }
        
    }
    // Loads existing note data or initializes defaults.
    func loadData() {
        if let existingNote = viewModel.loadNote(for: date) {
            text = existingNote
            emotion = classifyEmotion(from: existingNote)
        } else {
            text = ""
            emotion = "Neutral"
            backgroundColorEmotion = "Neutral"
        }
        backgroundColorEmotion = viewModel.loadEmotion(for: date) ?? "Neutral"
        existingImages = viewModel.loadImages(for: date)
        newImages = []
        requestPermissions()
    }
    // Saves the current note with the selected emotion and other details.
    func saveNote(){
        let defaultLocation = CLLocation(latitude: 0, longitude: 0)
        
        let userLocation = locationManager1.lastLocation1
        print("Save , \(String(describing: userLocation))")
        
        
        
        viewModel.saveNote(for: date, text: text, emotion: finalEmotion ?? emotion, bgcolor:UIColor.from(color: colorForEmotion(finalEmotion ?? emotion)), location:userLocation ??  defaultLocation )
        viewModel.saveImages(for: date, images: newImages)
        selectedTab = 0
        backgroundColorEmotion = finalEmotion ?? ""
        print(backgroundColorEmotion)
        print(colorForEmotion(backgroundColorEmotion))
        print("Selected Emotion By User \(String(describing: finalEmotion))")
        print("All Locations")
        print("All Colors for daye \(viewModel.loadBg(for: date))")
        print(viewModel.locationForDates)
        //        print("Saved Location \(currentLocation)")
        presentationMode.wrappedValue.dismiss()
    }
    
    // Classifies the emotion based on the text input.
    func classifyEmotion(from text: String) -> String {
        let lowercasedText = text.lowercased()
        
        let happyKeywords = ["happy", "joy", "excited", "glad"]
        let sadKeywords = ["sad", "unhappy", "miserable", "depressed"]
        let angryKeywords = ["angry", "mad", "furious", "irritated"]
        let confusedKeywords = ["confused", "bewildered", "lost", "uncertain","suprised"]
        let disgustedKeywords = ["disgusted", "repulsed", "sickened", "nauseated"]
        let fearfulKeywords = ["fearful", "scared", "afraid", "terrified"]
        
        let emotionsKeywords = [
            "Happy": happyKeywords,
            "Sad": sadKeywords,
            "Angry": angryKeywords,
            "Suprised": confusedKeywords,
            "Disgusted": disgustedKeywords,
            "Fearful": fearfulKeywords
        ]
        
        var emotionCounts = [
            "Happy": 0,
            "Sad": 0,
            "Angry": 0,
            "Suprised": 0,
            "Disgusted": 0,
            "Fearful": 0,
            "Neutral": 0
        ]
        
        for (emotion, keywords) in emotionsKeywords {
            for keyword in keywords {
                if lowercasedText.contains(keyword) {
                    emotionCounts[emotion, default: 0] += 1
                }
            }
        }
        
        if emotionCounts.values.allSatisfy({ $0 == 0 }) {
            return "Neutral"
        } else {
            return emotionCounts.max(by: { a, b in a.value < b.value })!.key
        }
    }
    
    // Requests necessary permissions for speech recognition and microphone access.
    private func requestPermissions() {
        SFSpeechRecognizer.requestAuthorization { status in
            switch status {
            case .authorized:
                print("Speech recognition authorization granted")
            default:
                print("Speech recognition authorization denied or restricted")
            }
        }
        
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            if granted {
                print("Microphone access granted")
            } else {
                print("Microphone access denied")
            }
        }
    }
    
    // Starts audio recording and processes speech for text conversion.
    func startRecording() {
        self.processedSegments.removeAll()
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            if let result = result {
                let unprocessedSegments = result.bestTranscription.segments.filter { !self.processedSegments.contains($0) }
                
                for segment in unprocessedSegments {
                    DispatchQueue.main.async {
                        self.text += " " + segment.substring
                    }
                    self.processedSegments.insert(segment)
                }
                
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                DispatchQueue.main.async {
                    self.recognitionTask = nil
                    self.isRecording = false
                }
            }
        }
        
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
    }
    
    // Stops the audio recording and ends the speech recognition task.
    func stopRecording() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        self.processedSegments.removeAll()
        
    }
}


// Returns a color representation for a given emotion.
func colorForEmotion(_ emotion: String) -> Color {
    switch emotion {
    case "Happy":
        return Color(red: 98/255, green: 219/255, blue: 45/255)
    case "Angry":
        return Color.red
    case "Sad":
        return Color.cyan
    case "Suprised":
        return Color.yellow
    case "Disgusted":
        return Color.purple
    case "Fearful":
        return Color.orange
    default:
        return Color.clear
    }
    
}

//
//  AudioRecordingView.swift
//  Team3_Betaapp
//
//  Created by Yashitha Vilasagarapu on 11/1/23.
//


// AudioRecordingView is a view for recording and managing audio recordings.
import Foundation
import SwiftUI
struct AudioRecordingView: View {
    @Environment(\.presentationMode) var presentationMode
    
    // ObservedObject for managing audio recording functionality.
    @ObservedObject var calendarVM = CalendarViewModel()
    @ObservedObject var vm: VoiceViewModel
    
    // Initialize the VoiceViewModel.
    init() {
        let voiceVM = VoiceViewModel(calendarViewModel: CalendarViewModel())
        self.vm = voiceVM
    }
    
    // State variables to control various aspects of the view.
    @State private var showingList = false
    @State private var showingAlert = false
    @State private var effect1 = false
    @State private var effect2 = false
    
    
    var body: some View {
        
        ZStack{
            // Display recording status if recording is in progress.
            VStack{
                Spacer()
                if vm.isRecording {
                    VStack(alignment : .leading , spacing : -5){
                        HStack (spacing : 3) {
                            Image(systemName: vm.isRecording && vm.toggleColor ? "circle.fill" : "circle")
                                .font(.system(size:10))
                                .foregroundColor(.red)
                            Text("Rec")
                        }
                        Text(vm.timer)
                            .font(.system(size:60))
                            .foregroundColor(.blue)
                    }
                    
                } else {
                    // Display instructions when recording is not in progress.
                    VStack{
                        Text("Press the Recording Button below")
                            .foregroundColor(.red)
                            .fontWeight(.bold)
                        Text("and Stop when its done")
                            .foregroundColor(.red)
                            .fontWeight(.bold)
                    }.frame(width: 300, height: 100, alignment: .center)
                }
                Spacer()
                ZStack {
                    Image(systemName: vm.isRecording ? "stop.circle.fill" : "mic.circle.fill")
                        .foregroundColor(.blue)
                        .font(.system(size: 45))
                        .onTapGesture {
                            if vm.isRecording == true {
                                vm.stopRecording()
                            } else {
                                vm.startRecording()
                                
                            }
                        }
                    
                }
                Spacer()
                // Display a list of recorded audio recordings.
                ScrollView{
                    ForEach(vm.recordingsList, id: \.createdAt) { recording in
                        VStack{
                            HStack{
                                Image(systemName:"headphones.circle.fill")
                                    .font(.system(size:50))
                                VStack(alignment:.leading) {
                                    Text("\(recording.fileURL.lastPathComponent)")
                                }
                                VStack{
                                    Button(action: {
                                        vm.deleteRecording(url:recording.fileURL)
                                    }) {
                                        Image(systemName:"xmark.circle.fill")
                                            .foregroundColor(.red)
                                            .font(.system(size:15))
                                    }
                                    Spacer()
                                    Button(action: {
                                        if recording.isPlaying == true {
                                            vm.stopPlaying(url: recording.fileURL)
                                        }else{
                                            vm.startPlaying(url: recording.fileURL)
                                        }
                                    }) {
                                        Image(systemName: recording.isPlaying ? "stop.fill" : "play.fill")
                                            .foregroundColor(.red)
                                            .font(.system(size:30))
                                    }
                                }
                                
                            }.padding()
                        }.padding(.horizontal,10)
                            .frame(width: 370, height: 85)
                            .background(Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)))
                            .cornerRadius(30)
                            .shadow(color: Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)).opacity(0.3), radius: 10, x: 0, y: 10)
                        
                    }
                }
                
            }
            .navigationBarItems(trailing: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("X")
                    .font(.headline)
                    .foregroundColor(CustomColor.blue)
            })
            .padding(.leading,25)
            .padding(.trailing,25)
            .padding(.top , 70)
            
            
            
            
            
            
        }
        
    }
}

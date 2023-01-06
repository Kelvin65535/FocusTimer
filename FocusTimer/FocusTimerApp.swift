//
//  FocusTimerApp.swift
//  FocusTimer
//
//  Created by 叶嘉永 on 2023/1/6.
//

import SwiftUI
import Combine

@main
struct FocusTimerApp: App {
    @State private var timeRemaining = 25 * 60 // 25min
    @State var currentTime: String = "kwls's timer"
    @State var timerStart: Bool = false
    @State var startBtnLabel: String = "start"
    @State var cancellable: Cancellable?
    @State var timer = Timer.publish(every: 1, on: .main, in: .common)
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onReceive(timer) { time in
                    if self.timeRemaining > 0 {
                        self.timeRemaining -= 1
                    }
                    currentTime = Double(timeRemaining).secondsAsString()
                    NSLog("count down... current time: \(currentTime)")
                }
        }
        
        // add a macOS menubar icon
        #if os(macOS)
        MenuBarExtra(currentTime) {
            Button(startBtnLabel) {
                if (!timerStart) {
                    currentTime = Double(timeRemaining).secondsAsString()
                    cancellable = timer.connect()
                    NSLog("start timer! init time: \(currentTime)")
                    startBtnLabel = "stop"
                    timerStart = true
                } else {
                    cancellable?.cancel()
                    timer = Timer.publish(every: 1, on: .main, in: .common)
                    NSLog("stop timer! current time: \(currentTime)")
                    startBtnLabel = "start"
                    currentTime = "kwls's timer"
                    timeRemaining = 25 * 60 // 25min
                    timerStart = false
                }
            }
            Divider()
            
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }.keyboardShortcut("q")
        }
        #endif
        
    }
}

extension Double {
    /**
     Double seconds to readable string "mm:ss"
     */
    func secondsAsString() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: self) ?? ""
    }
}

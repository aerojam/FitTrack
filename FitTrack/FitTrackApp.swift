//
//  FitTrackApp.swift
//  FitTrack
//
//  Created by Martin on 01.04.2023.
//

import SwiftUI

@main
struct FitTrackApp: App {
    var body: some Scene {
        Window("FitTrack", id: "mainWindow") {
            ContentView()
        }
        .commands {
            CommandGroup(before: .saveItem) {
                Menu("Export") {
                    
                    Button("JSON…") {
                        NSApp.sendAction(#selector(AppCommands.exportJSONAction), to: nil, from: nil)
                    }
                    
                    Button("CSV…") {
                        NSApp.sendAction(#selector(AppCommands.exportCSVAction), to: nil, from: nil)
                    }
                }
            }
        }
    }
}

@objc protocol AppCommands {
    func exportJSONAction()
    func exportCSVAction()
}

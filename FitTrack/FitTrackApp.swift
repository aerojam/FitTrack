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
                Button("Import CSV…") {
                    NSApp.sendAction(#selector(AppCommands.importCSVAction), to: nil, from: nil)
                }
                
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
    func importCSVAction()
    func exportJSONAction()
    func exportCSVAction()
}

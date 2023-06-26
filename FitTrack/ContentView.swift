//
//  ContentView.swift
//  FitTrack
//
//  Created by Martin on 01.04.2023.
//

import SwiftUI
import Charts
import AppKit
import UniformTypeIdentifiers

@MainActor struct ContentView: View {
    @StateObject var dataModel = MeasurementsModel()
    @State private var selectedMeasurement: Measurement?
    @State private var isShowingAddMeasurement = false
    @State private var isConfirmingDelete = false
    @State private var isExporting = false
    
    func exportData(in fileType: UTType) {
        let panel = NSSavePanel()
        panel.title = "Export data"
        panel.allowedContentTypes = [fileType]
        
        if panel.runModal() == .OK {
            guard let url = panel.url else { return }
            
            switch fileType {
            case .json:
                dataModel.saveJSON(url)
            case UTType.commaSeparatedText:
                dataModel.exportCSV(url)
            default:
                print("Unsupported content file")
            }
        }
    }
    
    var body: some View {
        NavigationSplitView {
            List(dataModel.measurements.sorted(by: >), id: \.id, selection: $selectedMeasurement) { measurement in
                NavigationLink("\(Formatter.mediumDate.string(from: measurement.date))", value: measurement)
            }
            .listStyle(.sidebar)
        } detail: {
            VStack {
                if let measurement = selectedMeasurement {
                    MeasurementView(measurement: measurement).id(selectedMeasurement)
                        .padding()
                    Spacer()
                    Chart {
                        ForEach(dataModel.measurements, id: \.date) { item in
                            LineMark(
                                x: .value("Date", item.date),
                                y: .value("Weight", item.weight))
                            .foregroundStyle(.blue)
                        }
                    }
                    .chartYScale(domain: 80...110)
                    .padding([.leading, .trailing, .bottom])
                } else {
                    if !dataModel.measurements.isEmpty {
                        Label("Select a measurement", systemImage: "filemenu.and.cursorarrow")
                            .foregroundColor(.secondary)
                    } else {
                        Label("No measurements", systemImage: "archivebox")
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .sheet(isPresented: $isShowingAddMeasurement) {
            AddMeasurementView()
                .environmentObject(dataModel)
        }
        .toolbar {
            ToolbarItemGroup {
                Button() {
                    isShowingAddMeasurement = true
                } label: {
                    Label("New measurement", systemImage: "plus")
                }
                .help("New measurement")
                .keyboardShortcut("n")
                
                Button() {
                    isConfirmingDelete = true
                } label: {
                    Label("Remove measurement", systemImage: "trash")
                }
                .help("Remove measurement")
                .disabled(selectedMeasurement == nil)
                .keyboardShortcut(.delete)
                .confirmationDialog("Delete selected measurement?", isPresented: $isConfirmingDelete) {
                    Button("Delete", role: .destructive) {
                        dataModel.removeMeasurement(selectedMeasurement)
                        selectedMeasurement = nil
                    }
                    Button("Cancel", role: .cancel) { }
                }
            }
        }
        .onCommand(#selector(AppCommands.exportCSVAction)) { exportData(in: .commaSeparatedText) }
        .onCommand(#selector(AppCommands.exportJSONAction)) { exportData(in: .json) }
        .onAppear {
            selectedMeasurement = dataModel.measurements.last
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

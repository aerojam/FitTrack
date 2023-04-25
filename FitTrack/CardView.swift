//
//  CardView.swift
//  FitTrack
//
//  Created by Martin on 17.04.2023.
//

import SwiftUI

struct CardView: View {
    @State var title: String
    @State var value: String
    @State var units: String
    @State var background: Color
    @State var foreground: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
            Spacer()
            HStack(alignment: .firstTextBaseline) {
                Text(value)
                    .font(.largeTitle)
                Text(units)
                    .font(.title2)
                Spacer()
            }
        }
        .padding(10)
        .background(background)
        .foregroundColor(foreground)
        .frame(maxHeight: 64)
        .cornerRadius(8)
    }
        
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(title: "Hmotnost", value: "87,6", units: "kg", background: .green, foreground: .black)
    }
}

//
//  ContentView.swift
//  LLDB_debugging
//
//  Created by 정정욱 on 5/26/24.
//

import SwiftUI

struct ContentView: View {
    @State var data = [0, 1, 2, 3]
    @State var selectedNumber = 0
    
    var body: some View {
        List {
            ForEach(data, id: \.self){ item in
                Button {
                    // Action
                    selectedNumber = item
                    data.remove(at: item)
                    printValue()
                } label: {
                    Text("\(item)")
                }
            }
        }
        .padding()
    }
    
    private func printValue() {
        print(data)
    }
}

#Preview {
    ContentView()
}

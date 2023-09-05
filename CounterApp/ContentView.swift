//
//  ContentView.swift
//  CounterApp
//
//  Created by Jethro Djan on 03/09/2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var mvumanager: CounterMVUManager
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    mvumanager.update(.decrement)
                }, label: {
                    Image(systemName: "minus.circle")
                })
                Text("\(mvumanager.state.count)")
                    .font(.title)
                Button(action: {
                    mvumanager.update(.increment)
                }, label: {
                    Image(systemName: "plus.circle")
                })
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let mvumanager = CounterMVUManager(
          initial: Model(),
          updater: update
        )
        
        ContentView()
            .environmentObject(mvumanager)
    }
}

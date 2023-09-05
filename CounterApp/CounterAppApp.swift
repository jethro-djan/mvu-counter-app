//
//  CounterAppApp.swift
//  CounterApp
//
//  Created by Jethro Djan on 03/09/2023.
//

import SwiftUI
import Combine

struct Model {
    var count: Int = 0
}

enum Msg {
    case increment
    case decrement
}

typealias Update<Model, Msg> = (Model, Msg) -> Model
let update: Update<Model, Msg> = {
    model, msg in
    var mutatingModel = model
    
    switch msg {
    case .increment:
        mutatingModel.count = mutatingModel.count + 1
    case .decrement:
        mutatingModel.count = mutatingModel.count - 1
    }
    
    return mutatingModel
}

typealias CounterMVUManager = MVUManager<Model, Msg>
class MVUManager<State, Action>: ObservableObject {
    @Published private(set) var state: State
    private let updater: Update<State, Action>
    private let queue = DispatchQueue(label: "com.nhoma.counterapp.mvumanager", qos: .userInitiated )
    
    init(
        initial: State,
        updater: @escaping Update<State, Action>
    ) {
        self.state = initial
        self.updater = updater
    }
    
    func update(_ action: Action) {
        queue.sync {
            self.update(self.state, action)
        }
    }
    
    private func update(_ currentState: State, _ action: Action) {
        let newState = updater(currentState, action)
        state = newState
    }
    
}

@main
struct CounterAppApp: App {
    let mvumanager = CounterMVUManager(
      initial: Model(),
      updater: update
    )
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(mvumanager)
        }
    }
}

//
//  MainAppView.swift
//  Shared
//
//  Created by Alexander Skorulis on 28/8/21.
//

import SwiftUI
import CoreData

struct MainAppView: View {
    
    @EnvironmentObject var factory: GenericFactory

    var body: some View {
        NavigationView {
            ProjectListView(viewModel: factory.resolve())
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainAppView()
    }
}

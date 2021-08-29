//
//  MagicApp.swift
//  Shared
//
//  Created by Alexander Skorulis on 28/8/21.
//

import SwiftUI

@main
struct MagicApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(IOC.shared.container.resolve(GenericFactory.self)!)
                .handlesExternalEvents(preferring: ["*"], allowing: ["*"])
                .onOpenURL { url in
                    IOC.shared.container.resolve(DeeplinkService.self)?.onDeeplink(url: url)
                }
        }
    }
}

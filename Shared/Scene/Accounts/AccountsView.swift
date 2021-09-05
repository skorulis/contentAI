//
//  AccountsView.swift
//  Magic
//
//  Created by Alexander Skorulis on 5/9/21.
//

import Foundation
import SwiftUI

// MARK: - Memory footprint

struct AccountsView {
    
    @StateObject var viewModel: AccountsViewModel
    
}

// MARK: - Rendering

extension AccountsView: View {
    
    var body: some View {
        ScrollView {
            redditSection
        }
        .sheet(isPresented: $viewModel.showingRedditAuth) {
            VStack {
                NavigationBar(
                    trailing: .imageButton("x.circle.fill") { viewModel.showingRedditAuth = false }
                )
                WebView(urlString: viewModel.redditAuthURL)
            }
            .frame(width: 500, height: 500)
        }
    }
    
    private var redditSection: some View {
        VStack {
            Text("Reddit")
            if let auth = viewModel.access.redditAuth {
                Text(auth.refresh_token ?? "")
            } else {
                Button {
                    viewModel.showingRedditAuth = true
                } label: {
                    Text("Auth reddit")
                }

            }
        }
    }
}
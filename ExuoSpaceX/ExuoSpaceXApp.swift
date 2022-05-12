//
//  ExuoSpaceXApp.swift
//  ExuoSpaceX
//
//  Created by Dumitru Paraschiv on 12.05.2022.
//

import SwiftUI

@main
struct ExuoSpaceXApp: App {
	@StateObject private var vm = LaunchesViewModel()
	
	var body: some Scene {
		WindowGroup {
			NavigationView {
				LaunchesView()
			}
			.navigationViewStyle(StackNavigationViewStyle())
			.environmentObject(vm)
		}
	}
}

//
//  LaunchesView.swift
//  ExuoSpaceX
//
//  Created by Dumitru Paraschiv on 12.05.2022.
//

import SwiftUI

struct LaunchesView: View {
	@EnvironmentObject var vm: LaunchesViewModel
	@State var searchText = String()
	
	var body: some View {
		ZStack {
			if vm.isLoaded {
				List {
					ForEach(vm.launches.filter({ searchText.isEmpty ? true : $0.name.contains(searchText) })) { launch in
						Text(launch.name)
							.listRowSeparator(.hidden)
					}
				}
				.listStyle(PlainListStyle())
				.searchable(text: $searchText)
				.refreshable { vm.getLaunches() }
			}
		}
		.navigationBarTitle("Launches")
	}
}

#if DEBUG
struct LaunchesView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView {
			LaunchesView()
		}
		.environmentObject(LaunchesViewModel())
	}
}
#endif


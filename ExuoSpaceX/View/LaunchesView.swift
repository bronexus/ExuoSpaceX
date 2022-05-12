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
				launchesList
			} else {
				if vm.loadingError {
					loadingError
				} else {
					loading
				}
			}
		}
		.navigationBarTitle("Launches")
		.sheet(item: $vm.sheetLaunch, onDismiss: nil) { launch in
			LaunchDetailsView(launch: launch)
		}
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

extension LaunchesView {
	private var launchesList: some View {
		List {
			ForEach(
				vm.launches
					.filter({ searchText.isEmpty ? true : $0.name.localizedCaseInsensitiveContains(searchText) })) { launch in
						LaunchListTileCard(launch: launch)
							.listRowSeparator(.hidden)
					}
		}
		.listStyle(PlainListStyle())
		.searchable(text: $searchText)
		.refreshable { vm.getLaunches() }
	}
	
	private var loading: some View {
		HStack(spacing: 12.0) {
			ProgressView()
			Text("Loading")
				.font(.callout)
				.fontWeight(.light)
				.foregroundColor(Color.secondary)
		}
	}
	
	private var loadingError: some View {
		VStack(spacing: 16) {
			Text("Loading error 😵‍💫")
				.font(.title)
			Text("Please check your connection and try again.")
				.foregroundColor(Color.secondary)
				.font(.subheadline)
			Button {
				vm.getLaunches()
			} label: {
				Text("Retry")
			}
			.buttonStyle(CapsuleButtonStyle())
			.padding(.top)
		}
		.padding()
	}
}


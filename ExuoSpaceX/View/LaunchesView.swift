//
//  LaunchesView.swift
//  ExuoSpaceX
//
//  Created by Dumitru Paraschiv on 12.05.2022.
//

import SwiftUI

struct LaunchesView: View {
	@EnvironmentObject var vm: LaunchesViewModel
	
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
		.navigationBarTitle("SpaceX Launches", displayMode: .inline)
		.navigationBarItems(
			leading: upcomingToggleButton,
			trailing: favouritesToggleButton)
//		.sheet(item: $vm.sheetLaunch, onDismiss: nil) { launch in
//			LaunchDetailsView(launch: launch)
//		}
		.sheet(item: $vm.sheetLaunch) {
			vm.rocket = nil
		} content: { launch in
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
		.previewDevice("iPhone X")
		.environmentObject(LaunchesViewModel())
	}
}
#endif

extension LaunchesView {
	private var launchesList: some View {
		List {
			ForEach(
				vm.launches
					.filter({ vm.showUpcoming ? true : !$0.upcoming })
					.filter({ vm.showFavourites ? vm.favouriteLaunches.contains($0.id) : true })
					.filter({ vm.searchText.isEmpty ? true : $0.name.localizedCaseInsensitiveContains(vm.searchText) })) { launch in
						LaunchListTileCard(launch: launch)
							.listRowSeparator(.hidden)
					}
		}
		.listStyle(PlainListStyle())
		.searchable(text: $vm.searchText)
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
			Text("Please check your connection and try again")
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
	
	private var favouritesToggleButton: some View {
		Button {
			vm.showFavourites.toggle()
		} label: {
			Image(systemName: vm.showFavourites ? "heart.fill" : "heart")
		}
	}
	
	private var upcomingToggleButton: some View {
		Button {
			vm.showUpcoming.toggle()
		} label: {
			Image(systemName: vm.showUpcoming ? "clock.fill" : "clock")
		}
	}
}


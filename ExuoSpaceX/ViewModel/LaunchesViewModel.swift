//
//  LaunchesViewModel.swift
//  ExuoSpaceX
//
//  Created by Dumitru Paraschiv on 12.05.2022.
//

import Foundation
import Combine

class LaunchesViewModel: ObservableObject {
	@Published var launches = [Launch]()
	
	var launchSubscription: AnyCancellable?
	
	var isLoaded: Bool {
		!launches.isEmpty
	}
	
	init() {
		getLaunches()
	}
	
	func getLaunches() {
		guard let url = URL(string: "https://api.spacexdata.com/v4/launches") else { return }
		
		launchSubscription = NetworkingManager.download(url: url)
			.decode(type: [Launch].self, decoder: JSONDecoder())
			.sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] returnedLaunches in
				self?.launches = returnedLaunches.reversed().filter({ !$0.upcoming })
				self?.launchSubscription?.cancel()
			})
	}
}

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
	@Published var loadingError = Bool()
	@Published var sheetLaunch: Launch? = nil
	@Published var rocket: Rocket?
	@Published var favouriteLaunches = [String]() { didSet { saveFavouriteLaunches() } }
	@Published var showFavourites = Bool()
	
	var launchSubscription: AnyCancellable?
	
	var isLoaded: Bool {
		!launches.isEmpty && !loadingError
	}
	
	init() {
		getLaunches()
		getFavouriteLaunches()
	}
	
	func getLaunches() {
		guard let url = URL(string: "https://api.spacexdata.com/v4/launches") else { return }
		
		launchSubscription = NetworkingManager.download(url: url)
			.decode(type: [Launch].self, decoder: JSONDecoder())
//			.sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] returnedLaunches in
//				self?.launches = returnedLaunches.reversed().filter({ !$0.upcoming })
//				self?.launchSubscription?.cancel()
//			})
			.sink(receiveCompletion: { completion in
				switch completion {
				case .finished: break
				case .failure(let error):
					self.loadingError = true
					print(error.localizedDescription)
				}
			}, receiveValue: {
				[ weak self] returnedLaunches in
				self?.launches = returnedLaunches.reversed().filter({ !$0.upcoming })
				self?.launchSubscription?.cancel()
				self?.loadingError = false
			})
	}
	
	func getRocket(rocketId: String) {
		guard let url = URL(string: "https://api.spacexdata.com/v4/rockets/\(rocketId)") else { return }
		
		launchSubscription = NetworkingManager.download(url: url)
			.decode(type: Rocket.self, decoder: JSONDecoder())
			.sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] returnedRocket in
				self?.rocket = returnedRocket
			})
	}
}

extension LaunchesViewModel {
	func getFavouriteLaunches() {
		guard
			let data = UserDefaults.standard.data(forKey: UserDefaults.Keys.favouriteLaunches),
			let savedLaunches = try? JSONDecoder().decode([String].self, from: data)
		else { return }
		self.favouriteLaunches = savedLaunches
	}
	
	func addFavouriteLaunch(id: String) {
		favouriteLaunches.append(id)
	}
	
	func removeFavouriteLaunch(id: String) {
		favouriteLaunches.removeAll { $0 == id }
	}
	
	func saveFavouriteLaunches() {
		if let encodedData = try? JSONEncoder().encode(favouriteLaunches) {
			UserDefaults.standard.set(encodedData, forKey: UserDefaults.Keys.favouriteLaunches)
		}
	}
}

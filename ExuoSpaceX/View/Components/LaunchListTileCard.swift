//
//  LaunchListTileCard.swift
//  ExuoSpaceX
//
//  Created by Dumitru Paraschiv on 12.05.2022.
//

import SwiftUI
import Telescope

struct LaunchListTileCard: View {
	@EnvironmentObject var vm: LaunchesViewModel
	var launch: Launch
	var imageStringURL: String?
	var usePatch = Bool()
	
	init(launch: Launch) {
		self.launch = launch
		
		guard let flickrLink = launch.links?.flickr?.original?.first else {
			guard let patchLink = launch.links?.patch?.small else {
				self.imageStringURL = nil
				return
			}
			usePatch = true
			self.imageStringURL = patchLink
			return
		}
		self.imageStringURL = flickrLink
	}
	
	var body: some View {
		ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
			launchImage
			
			launchInfo
		}
		.background(
			RoundedRectangle(cornerRadius: 10)
				.fill(.ultraThinMaterial)
		)
		.cornerRadius(10)
		.clipped()
		.onTapGesture {
			vm.sheetLaunch = launch
		}
		.overlay(tileFavButton, alignment: .topTrailing)
	}
}

extension LaunchListTileCard {
	private var launchImage: some View {
		ZStack {
			if let imageStringURL = imageStringURL {
				if !usePatch {
					TImage(try? RemoteImage(stringURL: imageStringURL))
						.resizable()
				} else {
					TImage(try? RemoteImage(stringURL: imageStringURL))
						.resizable()
						.scaledToFit()
						.padding(.vertical, 12)
						.padding(.bottom, 64)
				}
			} else {
				Image("spaceXDefaultImage")
					.resizable()
			}
		}
		.frame(height: (UIDevice.isIPhone ? 220 : 480) / (vm.showFavourites ? 2 : 1))
		.frame(minWidth: 0, maxWidth: .infinity)
		.clipped()
	}
	
	private var launchInfo: some View {
		HStack {
			Text("\(launch.name)")
				.fontWeight(.semibold)
				.foregroundColor(Color.accentColor)
				.lineLimit(1)
				.minimumScaleFactor(0.75)
			Spacer()
			Text("\(launch.date_utc.spaceXTime)")
				.padding(6)
				.background(Color.accentColor)
				.clipShape(Capsule())
		}
		.padding()
		.background(RoundedRectangle(cornerRadius: 10).fill(.ultraThinMaterial))
	}
	
	private var tileFavButton: some View {
		Image(systemName: vm.isFav(launchId: launch.id) ? "heart.fill" : "heart")
			.foregroundColor(Color.accentColor)
			.padding(12)
			.background(Circle().fill(.ultraThinMaterial))
			.padding(18)
			.onTapGesture {
				vm.favTapped(launchId: launch.id)
			}
	}
}

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
		VStack {
			ZStack {
				if let imageStringURL = imageStringURL {
					if !usePatch {
						TImage(try? RemoteImage(stringURL: imageStringURL))
							.resizable()
					} else {
						TImage(try? RemoteImage(stringURL: imageStringURL))
							.resizable()
							.scaledToFit()
							.padding(.top)
					}
				} else {
					Image("spaceXDefaultImage")
						.resizable()
				}
			}
			.frame(height: 220)
			.frame(minWidth: 0, maxWidth: .infinity)
			.clipped()
			
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
	}
}

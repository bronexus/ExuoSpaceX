//
//  LaunchDetailsView.swift
//  ExuoSpaceX
//
//  Created by Dumitru Paraschiv on 12.05.2022.
//

import SwiftUI
import YouTubePlayerKit

struct LaunchDetailsView: View {
	@EnvironmentObject var vm: LaunchesViewModel
	let launch: Launch
	var youtubePlayer: YouTubePlayer?
	
	init(launch: Launch) {
		self.launch = launch
		
		if let youtubeId = launch.links?.youtube_id {
			youtubePlayer = YouTubePlayer(
				source: .video(id: youtubeId),
				configuration: .init(autoPlay: false)
			)
		}
	}
	
	var body: some View {
		VStack(spacing: 18) {
			youtube
			
			VStack(spacing: 12) {
				Text("\(launch.name)")
					.fontWeight(.semibold)
					.foregroundColor(Color.accentColor)
				
				Text("\(launch.date_utc.spaceXTime)")
				
				fancyLaunchDetails
				
				Text("Rocket Name: \(vm.rocket?.name ?? "unknown")")
				
				Text("Rocket Mass: \(vm.rocket?.payload_weights?.first?.kg ?? 00) kg")
				
				wikipediaLink
			}
			
			Spacer()
		}
		.onAppear {
			vm.getRocket(rocketId: launch.rocket)
		}
	}
}

extension LaunchDetailsView {
	private var youtube: some View {
		ZStack {
			if youtubePlayer != nil {
				YouTubePlayerView(youtubePlayer!)
					.scaledToFit()
					.frame(maxWidth: .infinity)
					.background(Color.black)
			} else {
				Spacer()
			}
		}
	}
	
	private var fancyLaunchDetails: some View {
		ZStack {
			if let details = launch.details {
				ScrollView {
					Text(details)
						.font(.footnote)
						.fontWeight(.light)
						.lineLimit(nil)
						.multilineTextAlignment(.center)
						.padding(.trailing, 16)
				}
			} else {
				Text("🚀 Details not available 🫣")
					.font(.footnote)
					.fontWeight(.light)
			}
		}
		.padding()
		.padding(.trailing, -16)
		.frame(maxWidth: .infinity, minHeight: 92)
		.background(
			RoundedRectangle(cornerRadius: 10)
				.fill(.ultraThinMaterial)
		)
		.padding(.horizontal)
	}
	
	private var wikipediaLink: some View {
		ZStack {
			if let wikipediaLink = launch.links?.wikipedia {
				Link("Wikipedia", destination: URL(string: wikipediaLink)!)
					.foregroundColor(Color.blue)
			}
		}
	}
}


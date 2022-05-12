//
//  LaunchDetailsView.swift
//  ExuoSpaceX
//
//  Created by Dumitru Paraschiv on 12.05.2022.
//

import SwiftUI
import YouTubePlayerKit

struct LaunchDetailsView: View {
	var launch: Launch
	var youtubePlayer: YouTubePlayer?
	@State var rocketName = String()
	@State var rocketPayloadMass = String()
	
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
			if youtubePlayer != nil {
				YouTubePlayerView(youtubePlayer!)
					.scaledToFit()
					.frame(maxWidth: .infinity)
					.background(Color.black)
			} else {
				Spacer()
			}
			
			VStack(spacing: 12) {
				Text("\(launch.name)")
					.fontWeight(.semibold)
					.foregroundColor(Color.accentColor)
				
				Text("\(launch.date_utc.spaceXTime)")
				
				Text("\(launch.details ?? "🚀 Details not available 🫣")")
					.font(.footnote)
					.fontWeight(.light)
					.lineLimit(nil)
					.minimumScaleFactor(0.5)
					.multilineTextAlignment(.center)
					.padding()
					.frame(maxWidth: .infinity, minHeight: 92)
					.background(
						RoundedRectangle(cornerRadius: 10)
							.fill(.ultraThinMaterial)
					)
					.padding(.horizontal)
				
				Group {
					Text("Rocket Name:")
					
					Text("Rocket Mass:")
				}
				.foregroundColor(Color.accentColor)
				
				if let wikipediaLink = launch.links?.wikipedia {
					Link("Wikipedia", destination: URL(string: wikipediaLink)!)
						.foregroundColor(Color.blue)
				}
			}
			
			Spacer()
		}
	}
}

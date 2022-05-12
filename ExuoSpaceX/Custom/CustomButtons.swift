//
//  CustomButtons.swift
//  ExuoSpaceX
//
//  Created by Dumitru Paraschiv on 12.05.2022.
//

import Foundation
import SwiftUI

struct CapsuleButtonStyle: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		configuration.label.foregroundColor(.white)
			.padding(.horizontal, 16)
			.padding(.vertical, 8)
			.background(Color.accentColor)
			.clipShape(Capsule())
			.scaleEffect(configuration.isPressed ? 0.9 : 1)
	}
}

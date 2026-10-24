import SwiftUI

@main
struct RideBackApp: App {
    @StateObject private var motionManager = FallDetectorManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(motionManager)
                .preferredColorScheme(.dark)
        }
    }
}

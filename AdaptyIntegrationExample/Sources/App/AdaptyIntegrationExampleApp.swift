import SwiftUI

@main
struct AdaptyIntegrationExampleApp: App {
  @State var adaptyIntegrationContentViewModel = AdaptyIntegrationContentViewModel()

  var body: some Scene {
    WindowGroup {
      AdaptyIntegrationContentView(
        viewModel: adaptyIntegrationContentViewModel
      )
    }
  }
}

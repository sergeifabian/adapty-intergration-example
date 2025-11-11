import SwiftUI
import AdaptyUI

struct AdaptyIntegrationContentView: View {
  @Bindable var viewModel: AdaptyIntegrationContentViewModel

  var body: some View {
    Form {
      if viewModel.shouldLoadSDK {
        Text("Idle state, ready to start")
      } else if viewModel.loading {
        LabeledContent {
          ProgressView()
        } label: {
          Text("Data loading...")
        }
      } else if let error = viewModel.loadingError {
        Text("Data loading failed. Error: \(error.localizedDescription)")
      } else {
        Text("Data loaded")
      }

      Section {
        Button("Setup SDK") {
          viewModel.setupSDK()
        }

        Button("Toggle paywall presentation") {
          viewModel.togglePaywallPresentation()
        }

        Toggle("Full screen", isOn: $viewModel.paywallFullScreen)
      }
    }
    .paywall(
      isPresented: $viewModel.paywallPresented,
      fullScreen: viewModel.paywallFullScreen,
      paywallConfiguration: viewModel.paywallConfiguration,
      didAppear: {
        print("didAppear")
      },
      didDisappear: {
        print("didDisappear")
      },
      didPerformAction: { action in
        switch action {
        case .close:
          viewModel.paywallPresented = false
        case .custom(id: let id):
          print("didPerformAction.custom", id)
        case .openURL(url: let url):
          // Terms link configured in Adapty Account
          UIApplication.shared.open(url)
        }
      },
      didSelectProduct: { product in
        print("didSelectProduct", product)
      },
      didStartPurchase: { product in
        print("didStartPurchase", product)
      },
      didFinishPurchase: { product, result in
        print("didFinishPurchase", product, result)
      },
      didFailPurchase: { product, error in
        print("didFailPurchase", product, error)
      },
      didFinishWebPaymentNavigation: { product, error in
        print("didFinishWebPaymentNavigation", String(describing: product), String(describing: error))
      },
      didStartRestore: {
        print("didStartRestore")
      },
      didFinishRestore: { profile in
        print("didFinishRestore", profile)
      },
      didFailRestore: { error in
        print("didFailRestore", error)
      },
      didFailRendering: { error in
        print("didFailRendering", error)
      },
      didFailLoadingProducts: { error in
        print("didFailLoadingProducts", error)
        return true
      },
      didPartiallyLoadProducts: { products in
        print("didPartiallyLoadProducts", products)
      },
      // showAlertItem: Binding<AlertItem?> = Binding<AdaptyIdentifiablePlaceholder?>.constant(nil),
      // showAlertBuilder: ((AlertItem) -> Alert)? = nil,
      placeholderBuilder: {
        ProgressView("Custom paywall loading placeholder")
      }
    )
  }
}

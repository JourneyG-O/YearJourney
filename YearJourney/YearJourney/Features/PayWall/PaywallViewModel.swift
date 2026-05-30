//
//  PaywallViewModel.swift
//  YearJourney
//

import Foundation
import Combine

@MainActor
final class PaywallViewModel: ObservableObject {

    @Published private(set) var showCelebration = false
    @Published private(set) var isAnimating = false
    @Published private(set) var shouldDismiss = false

    private let storeManager: StoreManager
    private var cancellables = Set<AnyCancellable>()

    init(storeManager: StoreManager = .shared) {
        self.storeManager = storeManager
        observePurchaseState()
    }

    // MARK: - Intent

    func onAppear() {
        isAnimating = true
        Task { await storeManager.loadProducts() }
    }

    func purchase() {
        Task { try? await storeManager.purchase() }
    }

    func restorePurchases() {
        Task { await storeManager.updateCustomerProductStatus() }
    }

    // MARK: - Private

    private func observePurchaseState() {
        storeManager.$isPurchased
            .dropFirst()
            .filter { $0 }
            .sink { [weak self] _ in
                guard let self else { return }
                withAnimation { self.showCelebration = true }
                Task {
                    try? await Task.sleep(for: .seconds(2))
                    self.shouldDismiss = true
                }
            }
            .store(in: &cancellables)
    }
}

//
//  StoreManager.swift
//  YearJourney
//
//  Created by KoJeongseok on 1/17/26.
//

import Foundation
import StoreKit
import Combine

@MainActor
final class StoreManager: ObservableObject {
    static let shared = StoreManager()

    private let productID = "app.stannum.YearJourney.pro.lifetime"

    @Published var journeyPass: Product?
    @Published var isPurchased: Bool = false
    @Published var isLoading: Bool = false

    private var updates: Task<Void, Never>?

    private init() {
        updates = newTransactionListenerTask()
        Task { await updateCustomerProductStatus() }
    }

    deinit {
        updates?.cancel()
    }

    // MARK: - Public

    func loadProducts() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let products = try await Product.products(for: [productID])
            self.journeyPass = products.first
            await updateCustomerProductStatus()
        } catch {
            // Product load failure is non-fatal; user can retry via paywall
        }
    }

    func purchase() async throws {
        guard let product = journeyPass else { return }
        let result = try await product.purchase()
        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await updateCustomerProductStatus()
            await transaction.finish()
        case .userCancelled, .pending:
            break
        @unknown default:
            break
        }
    }

    func updateCustomerProductStatus() async {
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)
                if transaction.productID == productID {
                    setIsPurchased(true)
                    return
                }
            } catch {}
        }
        setIsPurchased(false)
    }

    #if DEBUG
    /// 디버그 전용 — StoreKit 트랜잭션과 무관하게 구매 상태를 강제 설정한다.
    /// 앱 UI와 위젯(AppGroupStore) 양쪽의 프리미엄 게이팅을 테스트하기 위한 용도.
    func debugSetPurchased(_ value: Bool) {
        setIsPurchased(value)
    }
    #endif

    // MARK: - Private

    // Syncs isPurchased to AppGroupStore so the widget can read it
    private func setIsPurchased(_ value: Bool) {
        isPurchased = value
        AppGroupStore.defaults.set(value, forKey: WidgetKeys.isPurchased)
    }

    nonisolated private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified: throw StoreError.failedVerification
        case .verified(let safe): return safe
        }
    }

    private func newTransactionListenerTask() -> Task<Void, Never> {
        Task.detached {
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)
                    await self.updateCustomerProductStatus()
                    await transaction.finish()
                } catch {}
            }
        }
    }
}

enum StoreError: Error {
    case failedVerification
}

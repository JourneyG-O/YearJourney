//
//  StoreManager.swift
//  YearJourney
//
//  Created by KoJeongseok on 1/17/26.
//

import Foundation
import StoreKit
import Combine

// 🎫 결제 기능을 담당하는 매니저 (Singleton)
@MainActor
final class StoreManager: ObservableObject {
    static let shared = StoreManager()

    // 📦 우리가 판매할 상품 ID
    private let productID = "app.stannum.YearJourney.pro.lifetime"

    // 📡 상태 변수들
    @Published var journeyPass: Product? // 불러온 상품 정보
    @Published var isPurchased: Bool = false // 구매 완료 여부 (True면 Pro)
    @Published var isLoading: Bool = false // 로딩 중인지

    private var updates: Task<Void, Never>? = nil

    private init() {
        // 앱이 켜지자마자 구매 내역 변동 사항을 감시 시작
        updates = newTransactionListenerTask()
    }

    deinit {
        updates?.cancel()
    }

    // 1️⃣ 상품 정보 가져오기
    func loadProducts() async {
        do {
            isLoading = true
            let products = try await Product.products(for: [productID])
            self.journeyPass = products.first

            await updateCustomerProductStatus()

            isLoading = false
            if let pass = journeyPass {
                print("🎫 상품 로드 완료: \(pass.displayName) - \(pass.displayPrice)")
            } else {
                print("⚠️ 상품을 찾을 수 없음. ID 확인 필요: \(productID)")
            }
        } catch {
            print("❌ 상품 로드 실패: \(error)")
            isLoading = false
        }
    }

    // 2️⃣ 구매 요청하기
    func purchase() async throws {
        guard let product = journeyPass else { return }

        let result = try await product.purchase()

        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await updateCustomerProductStatus()
            await transaction.finish()
            print("✅ 구매 성공! Journey Pass 획득")

        case .userCancelled, .pending:
            print("⚠️ 취소됨/보류됨")
        @unknown default:
            break
        }
    }

    // 3️⃣ 구매 내역 확인
    func updateCustomerProductStatus() async {
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)

                if transaction.productID == productID {
                    self.isPurchased = true
                    print("✅ Pro 권한 활성화됨")
                    return
                }
            } catch {
                print("❌ 영수증 검증 실패")
            }
        }
        self.isPurchased = false
    }

    // 4️⃣ 영수증 검증 (nonisolated 추가됨!)
    // 이 함수는 'newTransactionListenerTask' 안이 아니라, 이렇게 클래스 내부에 따로 있어야 합니다.
    nonisolated private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }

    // 5️⃣ 백그라운드 트랜잭션 감시자
    private func newTransactionListenerTask() -> Task<Void, Never> {
        Task.detached {
            for await result in Transaction.updates {
                do {
                    // 여기서 checkVerified 함수를 '호출'합니다.
                    let transaction = try self.checkVerified(result)

                    await self.updateCustomerProductStatus()
                    await transaction.finish()
                } catch {
                    print("❌ 트랜잭션 업데이트 오류")
                }
            }
        }
    }
}

enum StoreError: Error {
    case failedVerification
}

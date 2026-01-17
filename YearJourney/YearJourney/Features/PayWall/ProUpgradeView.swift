//
//  ProUpgradeView.swift
//  YearJourney
//
//  Created by KoJeongseok on 1/17/26.
//

import SwiftUI
import StoreKit

struct ProUpgradeView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var storeManager = StoreManager.shared

    var body: some View {
        ZStack {
            // 배경색 (살짝 따뜻한 느낌)
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                // 1. 상단 닫기 버튼
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 16)

                ScrollView {
                    VStack(spacing: 30) {
                        // 2. 히어로 이미지 (모카 포니가 영업 뜁니다 🐴)
                        VStack(spacing: 16) {
                            Image("pony_mocha_main") // ✅ 모카 이미지 사용
                                .resizable()
                                .scaledToFit()
                                .frame(height: 120)
                                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)

                            Text("Journey Pass")
                                .font(.custom("ComicRelief-Bold", size: 32)) // 폰트 없으면 .systemFont 사용
                                .foregroundStyle(.primary)

                            Text("Make your year more special\nwith adorable companions.")
                                .font(.custom("ComicRelief-Regular", size: 16))
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.secondary)
                                .padding(.horizontal)
                        }

                        // 3. 혜택 리스트
                        VStack(alignment: .leading, spacing: 16) {
                            FeatureRow(icon: "pawprint.fill", text: "Unlock All Companions (Pony, Cats...)")
                            FeatureRow(icon: "infinity", text: "Lifetime Access, No Subscription")
                            FeatureRow(icon: "heart.fill", text: "Support Indie Developer")
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 20)
                        .cornerRadius(16)
                        .padding(.horizontal)

                        // 4. 구매 버튼 구역
                        VStack(spacing: 12) {
                            if storeManager.isPurchased {
                                // 이미 구매한 경우
                                Text("You are already a Pro user! 🎉")
                                    .font(.headline)
                                    .foregroundStyle(.green)
                                    .padding()
                            } else {
                                // 구매 버튼
                                Button {
                                    Task {
                                        try? await storeManager.purchase()
                                    }
                                } label: {
                                    HStack {
                                        if storeManager.isLoading {
                                            ProgressView()
                                                .tint(.white)
                                        } else {
                                            Text("Get Lifetime Pass")
                                                .fontWeight(.bold)
                                            // 가격 표시 (로딩 중엔 빈칸)
                                            if let product = storeManager.journeyPass {
                                                Text("• \(product.displayPrice)")
                                            }
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.accentColor) // 앱의 포인트 컬러
                                    .foregroundStyle(.white)
                                    .cornerRadius(14)
                                    .shadow(color: .accentColor.opacity(0.3), radius: 5, y: 3)
                                }
                                .disabled(storeManager.isLoading)
                            }

                            // 5. 구매 복원 버튼 (필수!)
                            Button("Restore Purchases") {
                                Task {
                                    // 복원 시도 (사실상 상태 업데이트와 동일)
                                    await storeManager.updateCustomerProductStatus()

                                    // (옵션) 명시적으로 AppStore 동기화가 필요하다면:
                                    // try? await AppStore.sync()
                                }
                            }
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .padding(.top, 4)
                        }
                        .padding(.horizontal, 24)
                    }
                    .padding(.bottom, 40)
                }
            }
        }
        .onAppear {
            // 뷰가 뜰 때 상품 정보를 불러옵니다.
            Task {
                await storeManager.loadProducts()
            }
        }
    }
}

// 혜택 리스트 한 줄 컴포넌트
struct FeatureRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title3)
                .frame(width: 30)
                .foregroundStyle(Color.accentColor)

            Text(text)
                .font(.custom("ComicRelief-Regular", size: 16))
                .foregroundStyle(.primary)

            Spacer()
        }
    }
}

#Preview {
    ProUpgradeView()
}

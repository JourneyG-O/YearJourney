//
//  ProUpgradeView.swift
//  YearJourney
//
//  Created by KoJeongseok on 1/17/26.
//

import SwiftUI
import StoreKit

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var storeManager = StoreManager.shared
    @State private var isAnimating = false

    // 5명의 동반자 리스트
    let companions = [
        "ghost_roo_paywall",    // index 0: 중앙 상단 (가장 높음)
        "cat_cheese_paywall",   // index 1: 좌측 상단
        "cat_journey_paywall",  // index 2: 우측 상단
        "pony_mocha_paywall",   // index 3: 좌측 하단
        "slime_jelly_paywall"   // index 4: 우측 하단
    ]

    var body: some View {
        ZStack {
            // 1. 배경 색상
            Color(red: 0.11, green: 0.11, blue: 0.12)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // [핵심 수정] 상단 여백을 확실하게 줍니다 (80pt)
                // 유령이 위로 둥둥 떠도 잘리지 않게 확보하는 안전 공간입니다.
                Spacer().frame(height: 80)

                // 2. 메인 콘텐츠 (티켓 + 동반자들)
                ZStack {
                    // 동반자들 (구매 안 했을 때만 보임)
                    if !storeManager.isPurchased {
                        ForEach(0..<companions.count, id: \.self) { index in
                            Image(companions[index])
                                .resizable()
                                .scaledToFit()
                                .frame(height: 70) // 캐릭터 크기
                                .offset(
                                    x: companionOffset(index: index).x,
                                    y: companionOffset(index: index).y
                                )
                                .zIndex(-1) // 티켓 뒤로 배치
                                .rotationEffect(.degrees(isAnimating ? 3 : -3)) // 살랑살랑 흔들기
                                .animation(
                                    .easeInOut(duration: 2.0)
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(index) * 0.2),
                                    value: isAnimating
                                )
                        }
                    }

                    // 메인 티켓 이미지
                    Image("ticket_main")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180, height: 160)
                        .shadow(color: Color(red: 1.0, green: 0.84, blue: 0.0).opacity(0.4), radius: 25, x: 0, y: 0)
                        .offset(y: isAnimating ? -10 : 10) // 둥둥 뜨는 효과
                        .animation(
                            .easeInOut(duration: 2.5).repeatForever(autoreverses: true),
                            value: isAnimating
                        )
                }
                // 티켓 아래 여백
                .padding(.bottom, 40)

                // 3. 혜택 리스트 (타이틀 제거됨)
                VStack(alignment: .leading, spacing: 16) {
                    BenefitRow(text: "한 번 결제로 평생 소장")
                    BenefitRow(text: "모든 동반자 잠금 해제")
                    BenefitRow(text: "앞으로 추가될 친구들도 무료")
                }
                .frame(maxWidth: .infinity) // 중앙 정렬을 위해 너비 확장

                // 4. 유동적 여백 (화면이 길수록 이 부분이 늘어남)
                Spacer()

                // 5. 하단 버튼 그룹
                VStack(spacing: 20) {
                    // 구매 버튼
                    Button {
                        Task { try? await storeManager.purchase() }
                    } label: {
                        HStack {
                            if storeManager.isLoading {
                                ProgressView().tint(.black)
                            } else {
                                Text("Journey Pass 시작하기")
                                    .font(.custom("ComicRelief-Bold", size: 18))

                                if let product = storeManager.journeyPass {
                                    Text("• \(product.displayPrice)")
                                        .font(.custom("ComicRelief-Regular", size: 16))
                                }
                            }
                        }
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: .white.opacity(0.1), radius: 10, x: 0, y: 0)
                    }
                    .padding(.horizontal, 30)
                    .disabled(storeManager.isLoading || storeManager.isPurchased)

                    // 복원 버튼 (구매 안 했을 때만 표시)
                    if !storeManager.isPurchased {
                        Button("구매 기록 복원") {
                            Task { await storeManager.updateCustomerProductStatus() }
                        }
                        .font(.custom("ComicRelief-Regular", size: 13))
                        .foregroundStyle(.white.opacity(0.5))
                    }
                }
                .padding(.bottom, 20) // 바닥에서 살짝 띄움
            }
        }
        .onAppear {
            isAnimating = true
            Task { await storeManager.loadProducts() }
        }
    }

    // 캐릭터 위치 잡는 함수 (티켓 중심 기준)
    private func companionOffset(index: Int) -> (x: CGFloat, y: CGFloat) {
        switch index {
        case 0: return (0, -110)    // 중앙 상단 (가장 높음, 여백 80pt로 커버 가능)
        case 1: return (-130, -60)  // 좌측 상단
        case 2: return (130, -70)   // 우측 상단
        case 3: return (-120, 60)   // 좌측 하단
        case 4: return (120, 50)    // 우측 하단
        default: return (0, 0)
        }
    }

    // 혜택 리스트 한 줄 디자인 (발바닥 + 텍스트)
    @ViewBuilder
    private func BenefitRow(text: String) -> some View {
        HStack(spacing: 12) {
            Text("🐾")
                .font(.system(size: 18))

            Text(text)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.white.opacity(0.9))
        }
    }
}

#Preview {
    PaywallView()
        .background(Color.black)
}

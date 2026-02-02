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

    // ✅ [추가] 축하 효과 상태 관리
    @State private var showCelebration = false

    // 5명의 동반자 리스트
    let companions = [
        "ghost_roo_paywall",    // index 0: 중앙 상단
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

            // ✅ [추가] 축하 효과가 켜지면 배경에 팡파레! (가장 위에 표시)
            if showCelebration {
                ConfettiView()
                    .zIndex(10)
            }

            VStack(spacing: 0) {
                // 상단 안전 여백 (80pt)
                Spacer().frame(height: 80)

                // 2. 메인 콘텐츠 (티켓 + 동반자들)
                ZStack {
                    // ✅ [수정] 결제가 완료되어도 '축하 중'이면 캐릭터가 사라지지 않음
                    if !storeManager.isPurchased || showCelebration {
                        ForEach(0..<companions.count, id: \.self) { index in
                            Image(companions[index])
                                .resizable()
                                .scaledToFit()
                                .frame(height: 70)
                                .offset(
                                    x: companionOffset(index: index).x,
                                    y: companionOffset(index: index).y
                                )
                                .zIndex(-1)
                                // ✅ [수정] 축하 중일 때는 더 신나게 흔들기 (각도 3 -> 10)
                                .rotationEffect(.degrees(showCelebration ? (isAnimating ? 10 : -10) : (isAnimating ? 3 : -3)))
                                .animation(
                                    .easeInOut(duration: showCelebration ? 0.5 : 2.0) // 축하 땐 더 빠르게 흔듦
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
                        .offset(y: isAnimating ? -10 : 10)
                        .animation(
                            .easeInOut(duration: 2.5).repeatForever(autoreverses: true),
                            value: isAnimating
                        )
                }
                .padding(.bottom, 40)

                // 3. 혜택 리스트
                VStack(alignment: .leading, spacing: 16) {
                    BenefitRow(text: "Pay once, keep forever")
                    BenefitRow(text: "Unlock all companions")
                    BenefitRow(text: "Future companions are free")
                }
                .frame(maxWidth: .infinity)

                // 4. 유동적 여백
                Spacer()

                // 5. 하단 버튼 그룹
                VStack(spacing: 20) {
                    Button {
                        Task { try? await storeManager.purchase() }
                    } label: {
                        HStack {
                            if storeManager.isLoading {
                                ProgressView().tint(.black)
                            } else {
                                // ✅ [수정] 축하 상태에 따라 텍스트 변경
                                Text(showCelebration ? "Welcome Aboard! 🎉" : "Get Journey Pass")
                                    .font(.custom("ComicRelief-Bold", size: 18))

                                // 가격은 축하 중이 아닐 때만 표시
                                if !showCelebration, let product = storeManager.journeyPass {
                                    Text("• \(product.displayPrice)")
                                        .font(.custom("ComicRelief-Regular", size: 16))
                                }
                            }
                        }
                        // ✅ [수정] 축하 상태에 따라 버튼 스타일 변경 (흰색 -> 초록색)
                        .foregroundStyle(showCelebration ? .white : .black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(showCelebration ? Color(red: 0.2, green: 0.8, blue: 0.2) : Color.white)
                        .cornerRadius(16)
                        .shadow(color: .white.opacity(0.1), radius: 10, x: 0, y: 0)
                        .scaleEffect(showCelebration ? 1.05 : 1.0) // 축하 시 살짝 커짐
                        .animation(.spring(), value: showCelebration)
                    }
                    .padding(.horizontal, 30)
                    .disabled(storeManager.isLoading || (storeManager.isPurchased && !showCelebration))

                    // 복원 버튼
                    if !storeManager.isPurchased && !showCelebration {
                        Button("Restore Purchase") {
                            Task { await storeManager.updateCustomerProductStatus() }
                        }
                        .font(.custom("ComicRelief-Regular", size: 13))
                        .foregroundStyle(.white.opacity(0.5))
                    }
                }
                .padding(.bottom, 20)
            }
        }
        .onAppear {
            isAnimating = true
            Task { await storeManager.loadProducts() }
        }
        // ✅ [핵심] 결제 성공 감지 로직 추가
        .onChange(of: storeManager.isPurchased) { oldValue, newValue in
            if newValue {
                // 1. 축하 모드 ON
                withAnimation {
                    showCelebration = true
                }

                // 2. 2초 뒤 자동 닫기
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    dismiss()
                }
            }
        }
    }

    private func companionOffset(index: Int) -> (x: CGFloat, y: CGFloat) {
        switch index {
        case 0: return (0, -110)
        case 1: return (-130, -60)
        case 2: return (130, -70)
        case 3: return (-120, 60)
        case 4: return (120, 50)
        default: return (0, 0)
        }
    }

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

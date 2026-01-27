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

    let companions = ["pony_carrot", "ghost_pumpkin", "cat_fish", "slime_potion"]

    var body: some View {
        ZStack {
            // 배경: 완전한 블랙
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                // 상단 여백 (X 버튼 제거됨)
                Spacer().frame(height: 40)

                // [핵심 변경 구역] 메인 콘텐츠 (티켓 + 동반자들)
                ZStack {
                    // 1. 동반자들 (티켓 주변 배치)
                    // 구매 전 상태일 때만 보여줌
                    if !storeManager.isPurchased {
                        ForEach(0..<companions.count, id: \.self) { index in
                            Image(companions[index])
                                .resizable()
                                .scaledToFit()
                                .frame(height: 70) // 전신 이미지라 크기를 조금 키움
                                .offset(
                                    x: companionOffset(index: index).x,
                                    y: companionOffset(index: index).y
                                )
                                // 티켓 뒤로 보냄 (깊이감 연출)
                                .zIndex(-1)
                                // 둥둥 떠다니는 애니메이션 (각자 조금씩 다르게)
                                .rotationEffect(.degrees(isAnimating ? 3 : -3))
                                .animation(
                                    .easeInOut(duration: 2.0)
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(index) * 0.2),
                                    value: isAnimating
                                )
                        }
                    }

                    // 2. 티켓 이미지 (주인공)
                    Image("img_ticket") // TicketView()를 쓰고 계시다면 그걸로 교체
                        .resizable()
                        .scaledToFit()
                        .frame(width: 280)
                        .shadow(color: Color(red: 1.0, green: 0.84, blue: 0.0).opacity(0.4), radius: 25, x: 0, y: 0)
                        .offset(y: isAnimating ? -10 : 10)
                        .animation(
                            .easeInOut(duration: 2.5).repeatForever(autoreverses: true),
                            value: isAnimating
                        )
                }
                .padding(.top, 20) // 전체 덩어리 위치 조정

                // 문구 섹션 (티켓 아래)
                VStack(spacing: 10) {
                    Text("Make Your Year Special")
                        .font(.custom("ComicRelief-Bold", size: 24))
                        .foregroundStyle(.white)
                        .padding(.top, 30) // 티켓/동반자와의 간격

                    Text("Journey Pass로 모든 동반자와\n함께 여정을 떠나보세요.")
                        .font(.custom("ComicRelief-Regular", size: 15))
                        .foregroundStyle(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }

                Spacer()

                // [수정] 하단 액션 구역 (이제 버튼만 깔끔하게 남음)
                Button {
                    Task { try? await storeManager.purchase() }
                } label: {
                    HStack {
                        if storeManager.isLoading {
                            ProgressView().tint(.black)
                        } else {
                            // [임시] 구매 안 된 상태로 표시
                             Text("Journey Pass 시작하기")
                            // Text(storeManager.isPurchased ? "이미 구매함" : "Journey Pass 시작하기")
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
                .padding(.bottom, 20)

                // 복원 버튼
                if !storeManager.isPurchased {
                    Button("구매 기록 복원") {
                        Task { await storeManager.updateCustomerProductStatus() }
                    }
                    .font(.custom("ComicRelief-Regular", size: 12))
                    .foregroundStyle(.white.opacity(0.4))
                    .padding(.bottom, 15)
                }
            }
        }
        .glassEffect()
        .onAppear {
            isAnimating = true
            Task { await storeManager.loadProducts() }
        }
    }

    // [좌표 수정] 티켓(중심점 0,0)을 기준으로 배치
    private func companionOffset(index: Int) -> (x: CGFloat, y: CGFloat) {
        // 티켓 너비가 280이므로, x가 +/- 140 정도면 티켓 양 끝입니다.
        // y가 마이너스면 위쪽, 플러스면 아래쪽입니다.
        switch index {
        case 0: return (-130, -50) // 왼쪽 상단 (티켓 뒤에서 뺴꼼)
        case 1: return (130, -60)  // 오른쪽 상단
        case 2: return (-120, 60)  // 왼쪽 하단
        case 3: return (120, 50)   // 오른쪽 하단
        default: return (0, 0)
        }
    }
}

#Preview {
    PaywallView()
        .background(Color.black)
}

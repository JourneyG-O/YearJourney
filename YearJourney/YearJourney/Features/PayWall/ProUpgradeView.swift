//
//  ProUpgradeView.swift
//  YearJourney
//
//  Created by KoJeongseok on 1/17/26.
//

import SwiftUI
import StoreKit

struct PaywallView: View { // 이름 변경: ProUpgradeView -> PaywallView
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var storeManager = StoreManager.shared

    // 애니메이션 상태 변수
    @State private var isAnimating = false

    // 화면에 띄울 동반자 이미지 이름들 (Assets 이름을 여기에 맞춰주세요)
    let companions = ["cat_cheese_01", "cat_journey_01", "ghost_roo_01", "pony_mocha_01"]

    var body: some View {
        ZStack {
            // 1. 배경색 (어두운 배경 추천 - 티켓이 돋보임)
            Color.black.opacity(0.85).ignoresSafeArea()
            // 또는 기존 배경을 원하시면 아래 주석 해제
            // Color(.systemGroupedBackground).ignoresSafeArea()

            VStack(spacing: 0) {
                // 2. 상단 닫기 버튼
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundStyle(.white.opacity(0.5))
                    }
                }
                .padding(.horizontal)
                .padding(.top, 16)

                Spacer()

                // 3. 메인 콘텐츠 (티켓 + 문구)
                VStack(spacing: 30) {
                    // (A) 티켓 이미지 (둥둥 떠다니는 애니메이션)
                    Image("img_ticket") // [체크] 티켓 이미지 에셋 이름 확인
                        .resizable()
                        .scaledToFit()
                        .frame(width: 280) // 사이즈 조절
                        .shadow(color: .white.opacity(0.1), radius: 20, x: 0, y: 0)
                        .offset(y: isAnimating ? -10 : 10)
                        .animation(
                            .easeInOut(duration: 2.5).repeatForever(autoreverses: true),
                            value: isAnimating
                        )

                    // (B) 문구 섹션
                    VStack(spacing: 12) {
                        Text("당신의 1년을 더 특별하게")
                            .font(.custom("ComicRelief-Bold", size: 24))
                            .foregroundStyle(.white)

                        Text("Journey Pass로\n모든 동반자와 함께 여정을 떠나보세요.")
                            .font(.custom("ComicRelief-Regular", size: 16))
                            .foregroundStyle(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .lineSpacing(6)
                    }
                }

                Spacer()

                // 4. 하단 액션 구역 (동반자 얼굴 + 구매 버튼)
                ZStack {
                    // (A) 구매 완료 상태 체크
                    if storeManager.isPurchased {
                        VStack(spacing: 10) {
                            Text("이미 Journey Pass 회원입니다! 🎉")
                                .font(.custom("ComicRelief-Bold", size: 18))
                                .foregroundStyle(.green)

                            Button("닫기") { dismiss() }
                                .font(.custom("ComicRelief-Bold", size: 16))
                                .foregroundStyle(.white.opacity(0.7))
                        }
                        .padding(.bottom, 40)
                    } else {
                        // (B) 구매 전 상태
                        ZStack {
                            // 배경에 떠다니는 동반자 얼굴들
                            ForEach(0..<companions.count, id: \.self) { index in
                                Image(companions[index])
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .offset(
                                        x: faceOffset(index: index).x,
                                        y: faceOffset(index: index).y
                                    )
                                    .rotationEffect(.degrees(isAnimating ? 5 : -5))
                                    .animation(
                                        .easeInOut(duration: 2.0)
                                        .repeatForever(autoreverses: true)
                                        .delay(Double(index) * 0.3),
                                        value: isAnimating
                                    )
                            }

                            // 실제 구매 버튼
                            Button {
                                Task {
                                    try? await storeManager.purchase()
                                }
                            } label: {
                                HStack {
                                    if storeManager.isLoading {
                                        ProgressView().tint(.black)
                                    } else {
                                        Text("Journey Pass 시작하기")
                                            .font(.custom("ComicRelief-Bold", size: 18))

                                        // 가격 표시
                                        if let product = storeManager.journeyPass {
                                            Text("• \(product.displayPrice)")
                                                .font(.custom("ComicRelief-Regular", size: 16))
                                        }
                                    }
                                }
                                .foregroundStyle(.black) // 버튼 글자색
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(Color.white) // 버튼 배경색
                                .cornerRadius(16)
                                .shadow(color: .white.opacity(0.2), radius: 10, x: 0, y: 0)
                            }
                            .padding(.horizontal, 40)
                            .disabled(storeManager.isLoading)
                        }

                        // 복원 버튼 (버튼 아래 배치)
                        Button("구매 기록 복원") {
                            Task {
                                await storeManager.updateCustomerProductStatus()
                            }
                        }
                        .font(.custom("ComicRelief-Regular", size: 12))
                        .foregroundStyle(.white.opacity(0.4))
                        .padding(.top, 70) // 버튼과 겹치지 않게 아래로 내림
                    }
                }
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            isAnimating = true
            Task {
                await storeManager.loadProducts()
            }
        }
    }

    // 동반자 얼굴 위치 좌표 (버튼 주변)
    private func faceOffset(index: Int) -> (x: CGFloat, y: CGFloat) {
        switch index {
        case 0: return (-100, -40) // 왼쪽 위 (고양이)
        case 1: return (100, -50)  // 오른쪽 위 (유령)
        case 2: return (-90, 45)   // 왼쪽 아래 (슬라임)
        case 3: return (90, 35)    // 오른쪽 아래 (모카)
        default: return (0, 0)
        }
    }
}

#Preview {
    PaywallView()
}

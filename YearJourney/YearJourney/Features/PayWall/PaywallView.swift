//
//  PaywallView.swift
//  YearJourney
//

import SwiftUI
import StoreKit

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var storeManager: StoreManager
    @StateObject private var viewModel = PaywallViewModel()

    private let companions = [
        "ghost_roo_paywall",
        "cat_cheese_paywall",
        "cat_journey_paywall",
        "pony_mocha_paywall",
        "slime_jelly_paywall"
    ]

    // MARK: - Body

    var body: some View {
        ZStack {
            Color(red: 0.11, green: 0.11, blue: 0.12)
                .ignoresSafeArea()

            if viewModel.showCelebration {
                ConfettiView()
                    .zIndex(10)
            }

            VStack(spacing: 0) {
                Spacer()

                companionsStage
                    .padding(.bottom, 48)

                benefitsList
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 40)

                Spacer()

                actionButtons
                    .padding(.bottom, 36)
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
        .onChange(of: viewModel.shouldDismiss) { _, newValue in
            if newValue { dismiss() }
        }
    }

    // MARK: - Sections

    private var companionsStage: some View {
        ZStack {
            if !storeManager.isPurchased || viewModel.showCelebration {
                ForEach(0..<companions.count, id: \.self) { index in
                    Image(companions[index])
                        .resizable()
                        .scaledToFit()
                        .frame(height: 70)
                        .offset(x: companionOffset(index: index).x, y: companionOffset(index: index).y)
                        .zIndex(-1)
                        .rotationEffect(.degrees(viewModel.showCelebration
                            ? (viewModel.isAnimating ? 10 : -10)
                            : (viewModel.isAnimating ? 3 : -3)))
                        .animation(
                            .easeInOut(duration: viewModel.showCelebration ? 0.5 : 2.0)
                                .repeatForever(autoreverses: true)
                                .delay(Double(index) * 0.2),
                            value: viewModel.isAnimating
                        )
                }
            }

            Image("ticket_main")
                .resizable()
                .scaledToFit()
                .frame(width: 180, height: 160)
                .shadow(color: Color(red: 1.0, green: 0.84, blue: 0.0).opacity(0.4), radius: 25)
                .offset(y: viewModel.isAnimating ? -10 : 10)
                .animation(
                    .easeInOut(duration: 2.5).repeatForever(autoreverses: true),
                    value: viewModel.isAnimating
                )
        }
    }

    private var benefitsList: some View {
        VStack(alignment: .leading, spacing: 20) {
            BenefitRow(text: "paywall.benefit.once")
            VStack(alignment: .leading, spacing: 8) {
                BenefitRow(text: "paywall.benefit.companions")
                HStack(spacing: 8) {
                    Spacer().frame(width: 30)
                    Text("NEW!")
                        .font(.custom("ComicRelief-Bold", size: 8))
                        .foregroundStyle(.black.opacity(0.7))
                        .padding(.horizontal, 5)
                        .padding(.vertical, 2)
                        .background(Color(red: 0.85, green: 0.72, blue: 0.2))
                        .clipShape(Capsule())
                    Text("Underwater Journey")
                        .font(.custom("ComicRelief-Bold", size: 13))
                        .foregroundStyle(.white.opacity(0.65))
                }
            }
            BenefitRow(text: "paywall.benefit.dday")
            BenefitRow(text: "paywall.benefit.future")
        }
    }

    private var actionButtons: some View {
        VStack(spacing: 20) {
            Button {
                viewModel.purchase()
            } label: {
                HStack {
                    if storeManager.isLoading {
                        ProgressView().tint(.black)
                    } else {
                        Text(viewModel.showCelebration ? "Welcome Aboard! 🎉" : "Get Journey Pass")
                            .font(.custom("ComicRelief-Bold", size: 18))

                        if !viewModel.showCelebration, let product = storeManager.journeyPass {
                            Text("• \(product.displayPrice)")
                                .font(.custom("ComicRelief-Regular", size: 16))
                        }
                    }
                }
                .foregroundStyle(viewModel.showCelebration ? .white : .black)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(viewModel.showCelebration ? Color(red: 0.2, green: 0.8, blue: 0.2) : .white)
                .cornerRadius(16)
                .shadow(color: .white.opacity(0.1), radius: 10)
                .scaleEffect(viewModel.showCelebration ? 1.05 : 1.0)
                .animation(.spring(), value: viewModel.showCelebration)
            }
            .padding(.horizontal, 30)
            .disabled(storeManager.isLoading || (storeManager.isPurchased && !viewModel.showCelebration))

            if !storeManager.isPurchased && !viewModel.showCelebration {
                Button("Restore Purchase") {
                    viewModel.restorePurchases()
                }
                .font(.custom("ComicRelief-Regular", size: 13))
                .foregroundStyle(.white.opacity(0.5))
            }
        }
    }

    // MARK: - Layout

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
}

// MARK: - Sub-views

private struct BenefitRow: View {
    let text: LocalizedStringKey

    var body: some View {
        HStack(spacing: 12) {
            Text("🐾")
                .font(.system(size: 18))
            Text(text)
                .font(.custom("ComicRelief-Bold", size: 16))
                .foregroundStyle(.white.opacity(0.9))
        }
    }
}

#Preview {
    PaywallView()
        .environmentObject(StoreManager.shared)
}

//
//  BoxEventOnboardingView.swift
//  YearJourney
//

import SwiftUI

struct BoxEventOnboardingView: View {
    @EnvironmentObject private var storeManager: StoreManager
    @EnvironmentObject private var themeManager: ThemeManager
    @Environment(\.dismiss) private var dismiss

    @State private var currentPage = 0
    @State private var showPaywall = false

    private var totalPages: Int { storeManager.isPurchased ? 3 : 4 }

    // MARK: - Body

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $currentPage) {
                page1.tag(0)
                page2.tag(1)
                page3.tag(2)
                if !storeManager.isPurchased {
                    page4.tag(3)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            bottomControls
        }
        .background(Color(.systemGroupedBackground))
        .interactiveDismissDisabled()
        .sheet(isPresented: $showPaywall) {
            PaywallView()
                .presentationDetents([.fraction(0.65), .large])
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(24)
                .onChange(of: storeManager.isPurchased) { _, purchased in
                    if purchased { complete() }
                }
        }
    }

    // MARK: - Pages

    private var page1: some View {
        OnboardingPageView(
            imageName: "onboarding_box_peek",
            title: "Something New is Here!",
            subtitle: "Journey's been hiding something special.\nSee what's waiting for you."
        )
    }

    private var page2: some View {
        OnboardingPageView(
            imageName: "onboarding_dday",
            title: "Never Miss a Moment",
            subtitle: "Count down to birthdays, trips, and more.\nYour companion will remind you right on your widget."
        )
    }

    private var page3: some View {
        OnboardingPageView(
            imageName: "onboarding_underwater",
            title: "New Companion Arrived",
            subtitle: "Journey found a new adventure underwater.\nUnlock new companions with Journey Pass."
        )
    }

    private var page4: some View {
        VStack(spacing: 0) {
            Spacer()

            Image("ticket_main")
                .resizable()
                .scaledToFit()
                .frame(width: 160, height: 140)
                .shadow(color: Color(red: 1.0, green: 0.84, blue: 0.0).opacity(0.4), radius: 20)

            Spacer(minLength: 36)

            VStack(spacing: 12) {
                Text("Enjoy the Full Journey")
                    .font(.custom("ComicRelief-Bold", size: 24))
                    .multilineTextAlignment(.center)

                Text("Widget D-Day bubbles, new companions,\nand future updates — all with Journey Pass.")
                    .font(.system(size: 15))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 32)

            Spacer()
            Spacer()
        }
    }

    // MARK: - Bottom Controls

    private var bottomControls: some View {
        VStack(spacing: 16) {
            // Page dots
            HStack(spacing: 8) {
                ForEach(0..<totalPages, id: \.self) { i in
                    Capsule()
                        .fill(i == currentPage ? Color.primary : Color.primary.opacity(0.2))
                        .frame(width: i == currentPage ? 16 : 6, height: 6)
                        .animation(.easeInOut(duration: 0.2), value: currentPage)
                }
            }

            // Buttons
            if currentPage == totalPages - 1 && !storeManager.isPurchased {
                // Journey Pass page
                VStack(spacing: 10) {
                    Button {
                        showPaywall = true
                    } label: {
                        Text("Get Journey Pass")
                            .font(.custom("ComicRelief-Bold", size: 17))
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(Color.primary)
                            .foregroundStyle(Color(UIColor.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .padding(.horizontal, 24)

                    Button {
                        complete()
                    } label: {
                        Text("Maybe Later")
                            .font(.custom("ComicRelief-Regular", size: 14))
                            .foregroundStyle(.secondary)
                    }
                }
            } else {
                Button {
                    handleNext()
                } label: {
                    Text(isLastPage ? "Get Started" : "Next")
                        .font(.custom("ComicRelief-Bold", size: 17))
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color.primary)
                        .foregroundStyle(Color(UIColor.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding(.horizontal, 24)
            }
        }
        .padding(.bottom, 48)
    }

    // MARK: - Helpers

    private var isLastPage: Bool {
        currentPage == totalPages - 1
    }

    private func handleNext() {
        if isLastPage {
            complete()
        } else {
            withAnimation { currentPage += 1 }
        }
    }

    private func complete() {
        BoxEventManager.complete(themeManager: themeManager)
        dismiss()
    }
}

// MARK: - Page Component

struct OnboardingPageView: View {
    let imageName: String
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 280)
                .padding(.horizontal, 40)

            Spacer(minLength: 40)

            VStack(spacing: 12) {
                Text(title)
                    .font(.custom("ComicRelief-Bold", size: 24))
                    .multilineTextAlignment(.center)

                Text(subtitle)
                    .font(.system(size: 15))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 32)

            Spacer()
            Spacer()
        }
    }
}

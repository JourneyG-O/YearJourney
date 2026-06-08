//
//  BoxEventOnboardingView.swift
//  YearJourney
//

import SwiftUI

struct BoxEventOnboardingView: View {
    @EnvironmentObject private var storeManager: StoreManager
    @EnvironmentObject private var themeManager: ThemeManager
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme

    @State private var currentPage = 0
    @State private var showPaywall = false
    @State private var showOceanBackground = false

    private var totalPages: Int { 4 }

    private var backgroundColor: Color {
        colorScheme == .dark
            ? Color(red: 0.12, green: 0.12, blue: 0.13)
            : Color(.systemGroupedBackground)
    }

    private let oceanGradient = LinearGradient(
        colors: [Color(red: 0.0, green: 0.15, blue: 0.38), Color(red: 0.0, green: 0.30, blue: 0.55)],
        startPoint: .bottom,
        endPoint: .top
    )

    // MARK: - Body

    var body: some View {
        ZStack(alignment: .bottom) {
            // 배경 레이어 — page3에서 페이드인
            backgroundColor
                .ignoresSafeArea()
            oceanGradient
                .ignoresSafeArea()
                .opacity(showOceanBackground ? 1 : 0)

            TabView(selection: $currentPage) {
                page1.tag(0)
                page2.tag(1)
                page3.tag(2)
                page4.tag(3)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            bottomControls
        }
        .ignoresSafeArea()
        .interactiveDismissDisabled()
        .onChange(of: currentPage) { _, page in
            if page == 2 {
                // 슬라이드 완료 후 배경 페이드인
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    withAnimation(.easeIn(duration: 0.5)) { showOceanBackground = true }
                }
            } else {
                withAnimation(.easeOut(duration: 0.25)) { showOceanBackground = false }
            }
        }
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
            title: "Peek-a-boo!\nSomething New is Here!",
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
            subtitle: "Journey found a new adventure underwater.\nUnlock new companions with Journey Pass.",
            floatingAnimation: true,
            lightText: true
        )
    }

    private var page4: some View {
        VStack(spacing: 0) {
            Spacer()

            ZStack(alignment: .top) {
                Image("ticket_main")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 160, height: 140)
                    .shadow(color: Color(red: 1.0, green: 0.84, blue: 0.0).opacity(0.4), radius: 20)

                Image("ticket_cat_reach")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300)
            }

            Spacer(minLength: 36)

            VStack(spacing: 12) {
                Text(storeManager.isPurchased ? "Thank You!" : "Enjoy the Full Journey")
                    .font(.custom("ComicRelief-Bold", size: 24))
                    .multilineTextAlignment(.center)

                if storeManager.isPurchased {
                    // 저는 1인 개발자로서 Year Journey를 열심히 만들고 있어요. 여러분의 한 해가 조금 더 빛나길 바라며요.
                    // 이미 저니 패스를 이용 중이시네요. 정말 큰 힘이 돼요. 앞으로도 더 좋은 앱을 만들기 위해 최선을 다할게요.
                    Text("I'm working hard on Year Journey as a solo developer, and I hope it makes your year a little brighter.\n\nYou already have Journey Pass. It's a huge help, and I'll keep doing my best to make Year Journey even better for you.")
                        .font(.system(size: 15))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                } else {
                    // 저는 1인 개발자로서 Year Journey를 열심히 만들고 있어요. 여러분의 한 해가 조금 더 빛나길 바라며요.
                    // 커피 한 잔 값으로 저니 패스를 구매하시면 매년 더 풍성한 여정을 즐기실 수 있어요. 약속해요! 그리고 개발을 계속할 수 있는 큰 힘이 돼요. 제 앱을 사용해 주셔서, 함께해 주셔서 감사합니다.
                    Text("I'm working hard on Year Journey as a solo developer, and I hope it makes your year a little brighter.\n\nFor the price of a single coffee, Journey Pass will make every year even better. I promise! Plus, it really helps me keep going. Thanks for using my app, and thanks for being part of it.")
                        .font(.system(size: 15))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
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
    var floatingAnimation: Bool = false
    var lightText: Bool = false

    @State private var isFloating = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 300)
                .padding(.horizontal, 40)
                .offset(y: floatingAnimation ? (isFloating ? -10 : 10) : 0)
                .animation(
                    floatingAnimation
                        ? .easeInOut(duration: 2.0).repeatForever(autoreverses: true)
                        : .default,
                    value: isFloating
                )
                .onAppear {
                    if floatingAnimation { isFloating = true }
                }

            Spacer(minLength: 40)

            VStack(spacing: 12) {
                Text(title)
                    .font(.custom("ComicRelief-Bold", size: 24))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(lightText ? .white : .primary)

                Text(subtitle)
                    .font(.system(size: 15))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .foregroundStyle(lightText ? .white.opacity(0.8) : .secondary)
            }
            .padding(.horizontal, 32)

            Spacer()
            Spacer()
        }
    }
}

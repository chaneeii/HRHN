//
//  ReviewView.swift
//  HRHN
//
//  Created by 민채호 on 2022/12/26.
//

import SwiftUI

struct ReviewView: View {
    @ObservedObject private var viewModel: ReviewViewModel
    
    init(viewModel: ReviewViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text("오늘을 시작하기 전,\n저번 챌린지를 평가하세요")
                .font(.system(size: 25, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer(minLength: 20)
            Text(viewModel.previousChallenge?.content ?? "")
                .foregroundColor(.cellLabel)
                .padding(20.adjusted)
                .frame(maxWidth: .infinity)
                .frame(minHeight: 100.adjusted)
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundColor(.cellFill)
                }
                .padding(.horizontal, 15)
            Spacer(minLength: 20)
            Grid(horizontalSpacing: 10.adjusted, verticalSpacing: 10.adjusted) {
                GridRow {
                    emojiButton(.red)
                    emojiButton(.yellow)
                    emojiButton(.green)
                }
                GridRow {
                    emojiButton(.skyblue)
                    emojiButton(.blue)
                    emojiButton(.purple)
                }
            }
            .padding(.horizontal, 15)
            Spacer(minLength: 20)
        }
        .padding([.horizontal, .top], 20)
        .setBackgroundColor(.background)
    }
}

// MARK: ViewBuilder

private extension ReviewView {
    
    @ViewBuilder
    func emojiImage(_ emoji: Emoji) -> some View {
        Image(emoji.rawValue)
            .resizable()
            .frame(width: 100.adjusted, height: 100.adjusted)
    }
    
    @ViewBuilder
    func emojiButton(_ emoji: Emoji) -> some View {
        Button {
            viewModel.selectedEmoji = emoji
        } label: {
            if viewModel.selectedEmoji == emoji {
                emojiImage(emoji)
                    .overlay {
                        ZStack {
                            Rectangle()
                                .foregroundColor(.black)
                                .opacity(0.3)
                                .mask(emojiImage(emoji))
                            Image(systemName: "checkmark")
                                .font(.system(size: 30, weight: .medium))
                                .foregroundColor(.white)
                        }
                    }
                    
            } else {
                emojiImage(emoji)
            }
        }
    }
}

// MARK: - Preview

#if DEBUG
struct ReviewView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewView(viewModel: ReviewViewModel())
    }
}
#endif

//
//  LoginBtnStyle.swift
//  LMessenger
//
//  Created by 정정욱 on 4/4/24.
//
import SwiftUI

struct LoginBtnStyle: ButtonStyle {
    let textColor: Color
    let borderColor: Color

    init(
        textColor: Color,
        borderColor: Color? = nil
    ) {
        self.textColor = textColor
        self.borderColor = borderColor ?? textColor //nil 일 경우 textColor
    }

    
    // 라벨에 대한 속성을 만들어 줄 수 있음
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 14))
            .foregroundColor(self.textColor)
            .frame(maxWidth: .infinity, maxHeight: 40)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(self.borderColor, lineWidth: 0.8)
            }
            .padding(.horizontal,15)
            .opacity(configuration.isPressed ? 0.5 : 1) // configuration.isPressed 눌렀을 경우 0.5 : 1
    }
}

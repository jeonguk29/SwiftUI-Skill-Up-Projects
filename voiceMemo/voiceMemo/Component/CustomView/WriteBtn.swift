//
//  WriteBtn.swift
//  voiceMemo
//
//

import SwiftUI

// MARK: - 1️⃣ 수정자를 구현하기

// public 추후에 언제 어디서든 호출 될 수 있도록, 디자인 시스템 같은 경우는 public으로 만드는걸 권장
public struct WriteBtnViewModifier: ViewModifier {
    let action: () -> Void
    
    public init(action: @escaping () -> Void) {
        self.action = action
    }
    
    // ViewModifier 채택시 body구현 해줘야함
    public func body(content: Content) -> some View {
        ZStack {
            content
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button(
                        action: action,
                        label: { Image("writeBtn") }
                    )
                }
            }
            .padding(.trailing, 20)
            .padding(.bottom, 50)
        }
    }
}

// MARK: - 2️⃣ 확장해서 호출하기 
extension View {
    public func writeBtn(perform action: @escaping () -> Void) -> some View {
        ZStack {
            self
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button(
                        action: action,
                        label: { Image("writeBtn") }
                    )
                }
            }
            .padding(.trailing, 20)
            .padding(.bottom, 50)
        }
    }
}

// MARK: - 3️⃣ (아에 새로운 View를 만들기)
public struct WriteBtnView<Content: View>: View {
    let content: Content
    let action: () -> Void
    
    public init(
        @ViewBuilder content: () -> Content,
        action: @escaping () -> Void
    ) {
        self.content = content()
        self.action = action
    }
    
    public var body: some View {
        ZStack {
            content
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button(
                        action: action,
                        label: { Image("writeBtn") }
                    )
                }
            }
            .padding(.trailing, 20)
            .padding(.bottom, 50)
        }
    }
}

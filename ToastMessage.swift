//
//  ToastMessage.swift
//  StockSearch2
//
//  Created by Manish on 4/21/22.
//

import Foundation
import SwiftUI

struct Toast<Presenting>: View where Presenting: View {

    // The binding that decides the appropriate drawing in the body.
    @Binding var isShowing: Bool
    // The view that will be "presenting" this toast
    let presenting: () -> Presenting
    /// The text to show
    let text: Text
    let delay: TimeInterval = 2

    var body: some View {
        
        if self.isShowing {
            DispatchQueue.main.asyncAfter(deadline:.now() + self.delay){
                withAnimation {
                    self.isShowing = false
                }
            }
        }

        return GeometryReader { geometry in

            ZStack(alignment: .bottom) {

                self.presenting()

                VStack {
                    self.text
                        .font(.system(size: 14))
                }
                .frame(width: 350,
                       height: 50)
                .background(Color.gray)
                .foregroundColor(Color.white)
                .cornerRadius(20)
                .transition(.slide)
                .opacity(self.isShowing ? 1 : 0)

            }

        }

    }

}
extension View {

    func toast(isShowing: Binding<Bool>, text: Text) -> some View {
        Toast(isShowing: isShowing,
              presenting: { self },
              text: text)
    }

}

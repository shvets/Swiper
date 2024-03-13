import SwiftUI
import swiper

public extension View {
  func onSwipe(_ action: @escaping (SwipeModifier.Directions) -> ()) -> some View {
    modifier(SwipeModifier(handler: { direction in
      action(direction)
    }))
  }
}
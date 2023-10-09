import SwiftUI

public struct SwipeModifier: ViewModifier {
  public enum Directions: Int {
    case up, down, left, right
  }

  public class Direction: ObservableObject {
    @Published var multi: [Directions] = []
    @Published var single: String!
    static var shared = Direction()
  }

  @GestureState private var dragDirection:[Directions] = []
#if os(iOS)
  @State private var lastDragPosition: DragGesture.Value?
#endif
  @ObservedObject var direct = Direction.shared

  public var handler: ((Directions) -> Void)?

  public init(handler: ((Directions) -> Void)?) {
    self.handler = handler
  }

  public func body(content: Content) -> some View {
    content
#if os(iOS)
      .gesture(DragGesture()
        .onChanged { value in
          lastDragPosition = value
        }
        .updating($dragDirection, body: { (value, state, transaction) in
          if lastDragPosition != nil {
            if (lastDragPosition?.location.x)! > value.location.x {
              state += [.left]
            }

            if (lastDragPosition?.location.x)! < value.location.x {
              state += [.right]
            }

            if (lastDragPosition?.location.y)! < value.location.y {
              state += [.down]
            }

            if (lastDragPosition?.location.y)! > value.location.y {
              state += [.up]
            }
          }

          direct.multi = state
//          print("\(direct.multi)")
        })
        .onEnded { ( value ) in
          let summary = direct.multi.reduce(into: [:]) { counts, word in counts[word, default: 0] += 1 }

            if let foo = summary.max(by: { $0.value < $1.value }) {
            direct.single = "\(foo.key)!"

            if let handler = handler {
              handler(foo.key)
            }
          }
        }
      )
#endif
  }
}

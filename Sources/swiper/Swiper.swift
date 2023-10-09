public class Swiper<T: Comparable, Item: Identifiable> where Item.ID == T {
  private var navigator = ItemsNavigator<T>()

  public var currentItem: Item? = nil

  public var items: [Item]

  private var ids: [T] {
    items.map { item in item.id }
  }

  public init(items: [Item]) {
    self.items = items
  }

  public func handleSwipe(_ direction: SwipeModifier.Directions, reload: (Item) -> Void) {
    if let currentItem = currentItem {
      let item = swipe(direction, item: currentItem)

      if let item = item {
        self.currentItem = item

        reload(item)
      }
    }
  }

  private func swipe(_ direction: SwipeModifier.Directions, item: Item) -> Item? {
    var nextId: T?

    switch direction {
      case .up, .right:
        nextId = navigator.getNextId(item.id, ids: ids)
        break

      case .down, .left:
        nextId = navigator.getPreviousId(item.id, ids: ids)
        break
    }

    var nextItem: Item? = nil

    if nextId != item.id {
      nextItem = items.first { item in
        item.id == nextId
      }
    }

    return nextItem
  }
}

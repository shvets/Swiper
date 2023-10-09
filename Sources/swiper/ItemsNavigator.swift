import Foundation
import SwiftUI

public class ItemsNavigator<T: Comparable> {
  public func getNextId(_ id: T, ids: [T]) -> T {
    let current = ids.firstIndex(where: { item in item == id })

    if let current = current {
      let next = (current < (ids.count)-1) ? current + 1 : 0

      return ids[next]
    }

    return ids[0]
  }

  public func getPreviousId(_ id: T, ids: [T]) -> T {
    let current = ids.firstIndex(where: { item in item == id })

    if let current = current {
      let previous = (current > 0) ? current - 1 : ids.count - 1

      return ids[previous]
    }

    return ids[0]
  }
}

/*
 This source file is part of the Swift.org open source project

 Copyright (c) 2021 Apple Inc. and the Swift project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See https://swift.org/LICENSE.txt for license information
 See https://swift.org/CONTRIBUTORS.txt for Swift project authors
*/

/// A block quote.
public struct BlockQuote: BlockMarkup, BasicBlockContainer {
  public var _data: _MarkupData
  init(_ raw: RawMarkup) throws {
    guard case .blockQuote = raw.data else {
      throw RawMarkup.Error.concreteConversionError(from: raw, to: BlockQuote.self)
    }
    let absoluteRaw = AbsoluteRawMarkup(
      markup: raw, metadata: MarkupMetadata(id: .newRoot(), indexInParent: 0))
    self.init(_MarkupData(absoluteRaw))
  }

  init(_ data: _MarkupData) {
    self._data = data
  }
}

// MARK: - Public API

extension BlockQuote {
  // MARK: BasicBlockContainer

  public init<Children: Sequence>(_ children: Children) where Children.Element == BlockMarkup {
    try! self.init(.blockQuote(parsedRange: nil, children.map { $0.raw.markup }))
  }

  // MARK: Visitation

  public func accept<V: MarkupVisitor>(_ visitor: inout V) -> V.Result {
    return visitor.visitBlockQuote(self)
  }
}

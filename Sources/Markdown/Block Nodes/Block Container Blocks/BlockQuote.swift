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

  public init(_ children: some Sequence<BlockMarkup>) {
    self.init(children, inheritSourceRange: false)
  }

  public init(_ children: some Sequence<BlockMarkup>, inheritSourceRange: Bool) {
    let rawChildren = children.map { $0.raw.markup }
    let parsedRange = inheritSourceRange ? rawChildren.parsedRange : nil
    try! self.init(.blockQuote(parsedRange: parsedRange, rawChildren))
  }

  // MARK: Visitation

  public func accept<V: MarkupVisitor>(_ visitor: inout V) -> V.Result {
    return visitor.visitBlockQuote(self)
  }
}

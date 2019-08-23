//
//  ContentObject.swift
//  DownloadExample
//
//  Created by Leo Dion on 8/23/19.
//  Copyright © 2019 BrightDigit. All rights reserved.
//

import Foundation
import Combine

struct InvalidTextError : Error {
  
}

class ContentObject: ObservableObject {
  let publisher : AnyPublisher<String, Never>
  var cancellable : AnyCancellable!
  @Published var name : String = "" {
    willSet {
      objectWillChange.send()
    }
  }
  init () {
    let url = URL(string: "https://jaspervdj.be/lorem-markdownum/markdown.txt")!
    
   
    self.publisher = URLSession.shared.dataTaskPublisher(for: url).map { (arg: URLSession.DataTaskPublisher.Output) -> Result<String, Error>  in
      let (data, _) = arg
      let text = String(data: data, encoding: .utf8)
      guard let value = text?.components(separatedBy: .newlines).first else {
        return Result<String, Error>.failure(InvalidTextError())
      }
      return Result<String, Error>.success(value)
    }.catch({ (error) in
      return Just<Result<String, Error>>(.failure(error))
    }).compactMap { (result) -> String? in
      guard case .success(let value) = result else {
        return nil
      }
      return value
      }.eraseToAnyPublisher()
    
    self.cancellable = self.publisher.receive(on: DispatchQueue.main).assign(to: \ContentObject.name, on: self)
    
  }
}

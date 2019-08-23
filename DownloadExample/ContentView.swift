//
//  ContentView.swift
//  DownloadExample
//
//  Created by Leo Dion on 8/23/19.
//  Copyright © 2019 BrightDigit. All rights reserved.
//

import SwiftUI

struct ContentView: View {
  @ObservedObject var nameObject: ContentObject
  
  var body: some View {
    Text(nameObject.name)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(nameObject: ContentObject())
  }
}

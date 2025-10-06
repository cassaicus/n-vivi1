//
//  n_vivi1App.swift
//  n-vivi1
//
//  Created by ibis on 2025/10/06.
//

// SwiftUIフレームワークをインポートします。アプリケーションの構造を定義するために必要です。
import SwiftUI

// `@main`属性は、この構造体がアプリケーションのエントリーポイント（開始点）であることを示します。
@main
// アプリケーションの全体構造を定義する`n_vivi1App`という名前の構造体を宣言します。
// `App`プロトコルに準拠させることで、アプリケーションとして認識されます。
struct n_vivi1App: App {
    // `App`プロトコルで必須のプロパティ`body`を定義します。
    // `some Scene`は、アプリケーションのシーン（画面のコンテナ）を返すことを示します。
    var body: some Scene {
        // `WindowGroup`は、アプリケーションのメインウィンドウを管理するシーンです。
        // この中に、最初に表示されるビューを指定します。
        WindowGroup {
            // アプリケーションが起動したときに、最初に表示するビューとして`ContentView`を指定します。
            ContentView()
        }
    }
}
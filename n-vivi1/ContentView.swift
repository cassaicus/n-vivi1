//
//  ContentView.swift
//  n-vivi1
//
//  Created by ibis on 2025/10/06.
//

// SwiftUIフレームワークをインポートします。これにより、UIコンポーネントやレイアウト機能が利用可能になります。
import SwiftUI

// アプリケーションのメイン画面を定義する`ContentView`という名前のView（ビュー）を構造体として宣言します。
struct ContentView: View {
    // 選択された画像を格納するための状態変数（State）を宣言します。`@State`を付けることで、この変数の値が変更されるとViewが自動的に再描画されます。
    // 初期値は空の配列 `[]` とし、`UIImage`の配列として型定義します。
    @State private var selectedImages: [UIImage] = []
    // 画像ピッカー（ImagePicker）の表示状態を管理するための状態変数を宣言します。`true`になるとピッカーが表示されます。
    @State private var isPickerPresented = false

    // Viewの本体部分を定義します。ここに画面に表示されるUI要素を記述します。
    var body: some View {
        // ナビゲーション機能を提供する`NavigationView`を配置します。これにより、タイトル表示や画面遷移が可能になります。
        NavigationView {
            // UI要素を垂直方向に並べるための`VStack`（Vertical Stack）を配置します。
            VStack {
                // `selectedImages`配列が空でない場合（つまり、画像が1枚以上選択されている場合）の処理を記述します。
                if !selectedImages.isEmpty {
                    // 複数のビューをページのようにスワイプで切り替えられる`TabView`を配置します。
                    TabView {
                        // `selectedImages`配列内の各画像をループ処理で取り出し、画面に表示します。
                        // `id: \.self`は、各画像が一意であることを示します（UIImageがHashableに準拠しているため可能）。
                        ForEach(selectedImages, id: \.self) { img in
                            // `UIImage`を表示するための`Image`ビューを作成します。
                            Image(uiImage: img)
                                // 画像を親ビューのサイズに合わせてリサイズ可能にします。
                                .resizable()
                                // 画像のアスペクト比を維持しながら、親ビューに収まるように調整します。
                                .scaledToFit()
                                // 画像の周囲に余白（パディング）を追加します。
                                .padding()
                        }
                    }
                    // `TabView`のスタイルを、ページをめくるようなスワイプ形式に設定します。
                    .tabViewStyle(PageTabViewStyle())
                } else {
                    // `selectedImages`配列が空の場合（画像が選択されていない場合）に表示するテキストです。
                    Text("No Images Selected")
                        // テキストのフォントを見出し（headline）スタイルに設定します。
                        .font(.headline)
                }
            }
            // ナビゲーションバーに表示されるタイトルを "Image Gallery" に設定します。
            .navigationTitle("Image Gallery")
            // ツールバー領域にアイテムを追加します。
            .toolbar {
                // ツールバーアイテムの配置場所を画面下部（`.bottomBar`）に指定します。
                ToolbarItem(placement: .bottomBar) {
                    // "Select Images" というラベルを持つボタンを配置します。
                    Button("Select Images") {
                        // このボタンがタップされたときのアクションを記述します。
                        // `isPickerPresented`を`true`に設定し、画像ピッカーをモーダル表示させます。
                        isPickerPresented = true
                    }
                }
            }
            // `isPickerPresented`の状態に基づいてモーダルシートを表示します。
            // `$isPickerPresented`のように`$`を付けることで、`isPickerPresented`へのBinding（双方向の接続）を渡します。
            .sheet(isPresented: $isPickerPresented) {
                // モーダル表示するビューとして`ImagePicker`を指定します。
                // `selectedImages`へのBindingを渡すことで、`ImagePicker`内で選択された画像が`ContentView`の`selectedImages`に反映されます。
                ImagePicker(selectedImages: $selectedImages)
            }
        }
    }
}

// Xcodeのプレビュー機能で`ContentView`を表示するためのコードです。
#Preview {
    // `ContentView`のインスタンスを生成してプレビューに表示します。
    ContentView()
}
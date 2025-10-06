// SwiftUIフレームワークをインポートします。Viewの構造や状態管理に必要です。
import SwiftUI
// UIKitフレームワークをインポートします。UIViewControllerなど、UIKitのクラスを利用するために必要です。
import UIKit
// UniformTypeIdentifiersフレームワークをインポートします。UTType.imageなど、ファイルの種別を扱うために必要です。
import UniformTypeIdentifiers

// UIKitの`UIViewController`をSwiftUIで利用するためのラッパーとなる構造体`ImagePicker`を定義します。
// `UIViewControllerRepresentable`プロトコルに準拠させることで、SwiftUIのViewとして扱えるようになります。
struct ImagePicker: UIViewControllerRepresentable {
    // `@Binding`は、親ビュー（この場合は`ContentView`）の状態と双方向でデータを同期させるためのプロパティラッパーです。
    // `ContentView`の`selectedImages`とこの変数が接続され、ここで変更した値が`ContentView`に反映されます。
    @Binding var selectedImages: [UIImage]
    // `@Environment`は、ビューの環境値（システムが提供する情報）にアクセスするためのプロパティラッパーです。
    // `.presentationMode`は、現在のビュー（この場合はモーダルシート）の表示状態を管理するオブジェクトです。これを使ってシートを閉じることができます。
    @Environment(\.presentationMode) private var presentationMode

    // `UIViewControllerRepresentable`プロトコルで必須のメソッドです。
    // SwiftUIがこのViewを表示する際に、ラップ対象の`UIViewController`（この場合は`UIDocumentPickerViewController`）のインスタンスを生成します。
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        // ファイルピッカーを作成します。`forOpeningContentTypes`で選択可能なファイルの種類を指定します。
        // `[.image]`は、画像ファイル全般（JPEG, PNGなど）を示します。
        // `asCopy: true`は、選択されたファイルをアプリのサンドボックス内にコピーしてアクセスすることを意味します。
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.image], asCopy: true)
        // ユーザーが複数のファイルを同時に選択できるように設定します。
        picker.allowsMultipleSelection = true
        // `picker`のデリゲート（処理を委譲する先）を`context.coordinator`に設定します。
        // `Coordinator`は、ファイルが選択された時などのイベントを処理します。
        picker.delegate = context.coordinator
        // 設定済みの`picker`インスタンスを返します。
        return picker
    }

    // `UIViewControllerRepresentable`プロトコルで必須のメソッドです。
    // SwiftUI側の状態が変化し、Viewが更新される際に呼び出されます。
    // 今回は特に更新処理は不要なため、中身は空です。
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    // `UIViewControllerRepresentable`プロトコルで必須のメソッドです。
    // `makeUIViewController`で設定したデリゲートなどの役割を担う`Coordinator`のインスタンスを生成します。
    func makeCoordinator() -> Coordinator {
        // `Coordinator`のインスタンスを生成し、`self`（`ImagePicker`自身）への参照を渡します。
        // これにより、`Coordinator`は親である`ImagePicker`のプロパティ（`selectedImages`など）にアクセスできます。
        Coordinator(self)
    }

    // `UIDocumentPickerViewController`からのイベントを処理するための内部クラス`Coordinator`を定義します。
    // `NSObject`を継承し、`UIDocumentPickerDelegate`プロトコルに準拠します。
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        // 親である`ImagePicker`への参照を保持するためのプロパティです。
        let parent: ImagePicker

        // `Coordinator`のイニシャライザ（初期化メソッド）です。
        // `ImagePicker`からインスタンスを渡され、`parent`プロパティに保持します。
        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        // `UIDocumentPickerDelegate`のメソッドで、ユーザーがファイルを選択し終えたときに呼び出されます。
        // `urls`には、選択されたファイルのURLが配列として渡されます。
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            // 親ビューの`selectedImages`配列を一度空にします。
            parent.selectedImages = []
            // 選択されたすべてのURLに対してループ処理を行います。
            for url in urls {
                // iCloudなど、アプリのサンドボックス外にあるファイルにアクセスするために、セキュリティスコープ付きリソースへのアクセスを開始します。
                // アクセスが必要な処理が終わった後、必ずアクセスを停止する必要があるため、`defer`文で後始末を予約します。
                let shouldStopAccessing = url.startAccessingSecurityScopedResource()
                defer {
                    // `startAccessingSecurityScopedResource`が`true`を返した場合（アクセスを開始した場合）のみ、アクセスを停止します。
                    if shouldStopAccessing {
                        url.stopAccessingSecurityScopedResource()
                    }
                }
                // `url`からファイルデータを読み込み、そのデータから`UIImage`を生成しようと試みます。
                // `try?`を使っているため、処理が失敗した場合は`nil`が返され、クラッシュしません。
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    // `UIImage`の生成に成功した場合、その画像を親の`selectedImages`配列に追加します。
                    parent.selectedImages.append(image)
                }
            }
            // すべての画像の処理が終わったら、`presentationMode`を使ってピッカーのモーダルシートを閉じます。
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
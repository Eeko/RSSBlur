import QtQuick 2.0
import Sailfish.Silica 1.0
import QtWebKit 3.0

Page {
    id: webviewpage
    WebView {
        id: webview
        url: "https://www.newsblur.com/"
        z: 10
        anchors.fill: parent
    }
}

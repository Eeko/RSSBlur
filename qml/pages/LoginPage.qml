/*
RSSBlur Newsblur.com client
2013, Eetu "Eeko" Korhonen
*/

import QtQuick 2.0
import Sailfish.Silica 1.0
import QtWebKit 3.0



Page {
    id: loginPage

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                id: registerLink
                text: "Newsblur.com"
                onClicked: pageStack.push(Qt.resolvedUrl("WebView.qml"))
            }
        }

        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column

            width: loginPage.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: "Login to Newsblur"
            }

            TextField {
                id: usernameField
                focus: true
                inputMethodHints: Qt.ImhNoPredictiveText
                x: Theme.paddingLarge
                width: parent.width
                label: "Username:"
                placeholderText: "Enter username"
            }

            TextField {
                id: passwordField
                focus: false
                inputMethodHints: Qt.ImhNoPredictiveText
                x: Theme.paddingLarge
                width: parent.width
                label: "Password:"
                placeholderText: "Enter password"
                echoMode: TextInput.Password
            }
            TextSwitch {
                text: "Remember login"
                id: rememberUsernamePassword
                checked: true
            }
            Button {
                id: sendLogin
                text: "Login"
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    debugLog.text = "Connecting to API..."
                    var doc = new XMLHttpRequest();
                    doc.onreadystatechange = function () {
                        if (doc.readyState === XMLHttpRequest.DONE) {
                            var response_json = JSON.parse(doc.responseText)
                            console.log("Response_json: " + response_json)
                            console.log("Authenticated: " + response_json.authenticated)
                            if (response_json.authenticated) {
                                if (rememberUsernamePassword.checked) {

                                }
                                //move to feed-list page
                                pageStack.replace(Qt.resolvedUrl("FeedsPage.qml"))


                            }

                            debugLog.text = doc.responseText;

                        }
                    }
                    var password = ""
                    if (passwordField.text != ""){
                        var password = "&password=" + passwordField.text
                    }
                    var request = ("https://www.newsblur.com/api/login")
                    console.log("Posting request: " + request)

                    doc.open("POST", request, true)
                    doc.setRequestHeader("Content-type","application/x-www-form-urlencoded")
                    doc.send("username=" + usernameField.text + password)
                }
            }

            TextArea {
                id: debugLog
                width: parent.width
                height: 350
                text: "Messages come here"
                label: "Text area"
            }

        }
    }
}



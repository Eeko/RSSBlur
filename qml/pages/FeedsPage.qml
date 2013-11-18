import QtQuick 2.0
import Sailfish.Silica 1.0
import QtWebKit 3.0


Page {
    id: feedsPage

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaListView {
        id: listView
        anchors.fill: parent
        model: feedListModel
        header: PageHeader { title: "Feeds" }

        PullDownMenu {
            MenuItem {
                text: "Refresh"

            }
            MenuItem {
                text: "Logout"
                onClicked: pageStack.replace(Qt.resolvedUrl("LoginPage.qml"))
            }
        }
        ViewPlaceholder {
            enabled: listView.count == 0
            text: "Fetching feeds..."
            hintText: "Pull down to refresh"
        }
        VerticalScrollDecorator {}


        delegate: ListItem {
            id: listItem
            menu: contextMenuComponent
            function remove() {
                remorseAction("Deleting", function() { feedListModel.remove(index) })
            }
            ListView.onRemove: animateRemoval()
            onClicked: {
                if (pageStack.depth == 2) {
                    pageStack.push(Qt.resolvedUrl("MenuPage.qml"))
                }
            }
            Label {
                x: Theme.paddingLarge
                text: (model.index+1) + ". " + model.text
                anchors.verticalCenter: parent.verticalCenter
                font.capitalization: Font.Capitalize
                color: listItem.highlighted ? Theme.highlightColor : Theme.primaryColor
            }

            Component {
                id: contextMenuComponent
                ContextMenu {
                    MenuItem {
                        text: "Delete"
                        onClicked: remove()
                    }
                    MenuItem {
                        text: "Second option"
                    }
                }
            }
        }




    }
    ListModel {
        id: feedListModel
    }
    //onPageContainerChanged: populateFeeds()
    onPageContainerChanged: callNewsBlurApi("reader/feeds", populateFeeds)

    /**
        The JavaScript functions
    */
    // a function for calling Newsblur API
    function callNewsBlurApi(apiCommand, callBack, apiParameters) {
        console.log("Calling API...")
        var doc = new XMLHttpRequest();
        doc.onreadystatechange = function () {
            if (doc.readyState === XMLHttpRequest.DONE) {
                var response_json = JSON.parse(doc.responseText)
                console.log("Response_json: " + response_json)
                console.log("> " + doc.responseText)
                callBack(response_json)
            }
        }
        var request = ("https://www.newsblur.com/" + apiCommand)
        console.log("Posting request: " + request)
        var apiMethod = "GET"
        if (apiParameters) {
            apiMethod = "POST"
            doc.setRequestHeader("Content-type","application/x-www-form-urlencoded")
        }
        console.log(apiMethod + " request to " + request + " with parameters " + apiParameters)
        doc.open(apiMethod, request)
        doc.send(apiParameters)
    }
    function populateFeeds(data) {
        console.log("Caught callback from API. Populating feeds list")

        for (var index = 0; index < data.folders.length; index++) {
            if (typeof data.folders[index] === "object") {
                feedListModel.append({"text": "Folder"})
            } else {
                //feedListModel.append({"text": data.folders[index]})
                feedListModel.append({"text": data.feeds[data.folders[index]].feed_title})

            }

        }
        return data
    }
}

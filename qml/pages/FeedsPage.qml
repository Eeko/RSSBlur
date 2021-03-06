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
        header: PageHeader { title: "News-feeds" }

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

        // defining how individual listItems behave
        delegate: ListItem {
            //property string imagesource
            //imagesource: "../resources/oval.png"
            id: listItem
            menu: contextMenuComponent
            height: Theme.itemSizeSmall

            function remove() {
                remorseAction("Deleting", function() { feedListModel.remove(index) })
            }
            ListView.onRemove: animateRemoval()
            onClicked: {
                if (pageStack.depth == 2) {
                    pageStack.push(Qt.resolvedUrl("MenuPage.qml"))
                }
            }
            // Defining how individual list-items have labels
            Row {
                Column {
                    Image {
                        id: feedIcon
                        source: model.imagesource
                    }
                }
                Column {
                    Label {
                        x: Theme.paddingLarge
                        text: model.text
                        anchors.verticalCenter: parent.verticalCenter
                        font.capitalization: Font.Capitalize
                        color: listItem.highlighted ? Theme.highlightColor : Theme.primaryColor
                    }
                }
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

    Component {
        id: feedItemDelegate
        Row {
            spacing: 10
            Text { text: feedname }
        }
    }
    //onPageContainerChanged: populateFeeds()
    onPageContainerChanged: callNewsBlurApi("reader/feeds", readFolders)

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
    // a wrapper function to pass the data.folders json sub-variable to allow recursive parsing of feed-tree
    function readFolders(data) {
        populateFeeds(data.folders, data.feeds)
    }
    function populateFeeds(data, feeds, subfolder) {
        console.log("Caught callback from API. Populating feeds list")
        subfolder = typeof subfolder !== 'undefined' ? subfolder : false;

        for (var item in data) {
            if (typeof(data[item]) === "object"){
                if (subfolder) {
                    console.log("Appending foldername: " + item)
                    feedListModel.append({"text": "- " +item, "imagesource": "../resources/folder.png" })
                }
                console.log("Parsing recursively: \'" + item+ "\'")

                populateFeeds(data[item], feeds, true)
            } else {
                feedListModel.append({"text": feeds[data[item]].feed_title})
            }
        }

    }
}

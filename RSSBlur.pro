# The name of your app.
# NOTICE: name defined in TARGET has a corresponding QML filename.
#         If name defined in TARGET is changed, following needs to be
#         done to match new name:
#         - corresponding QML filename must be changed
#         - desktop icon filename must be changed
#         - desktop filename must be changed
#         - icon definition filename in desktop file must be changed
TARGET = RSSBlur

CONFIG += sailfishapp

SOURCES += src/RSSBlur.cpp

OTHER_FILES += qml/RSSBlur.qml \
    qml/cover/CoverPage.qml \
    qml/pages/FirstPage.qml \
    qml/pages/SecondPage.qml \
    qml/pages/LoginPage.qml \
    qml/pages/WebView.qml \
    qml/pages/FeedsPage.qml \
    rpm/RSSBlur.spec \
    rpm/RSSBlur.yaml \
    RSSBlur.desktop \
    qml/resources/folder.png \
    qml/resources/oval.png


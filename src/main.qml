import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1
import Qt.labs.settings 1.0

import ExpipeBrowser 1.0

import "md5.js" as MD5

ApplicationWindow {
    id: root

    visible: true
    width: 1440
    height: 1024
    title: qsTr("CINPLA Browser")

    Settings {
        property alias width: root.width
        property alias height: root.height
    }

    LeftMenu {
        id: leftMenu
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
        }

        width: 240
    }

    Item {
        id: viewArea
        anchors {
            left: leftMenu.right
            top: parent.top
            bottom: parent.bottom
            right: parent.right
        }
    }

    ExperimentsView {
        id: experimentsView
        anchors.fill: viewArea
        visible: leftMenu.selectedState === "experiments"
    }

    ProjectsView {
        id: projectsView
        anchors.fill: viewArea
        visible: leftMenu.selectedState === "projects"
    }
}

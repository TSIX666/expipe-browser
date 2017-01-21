import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1

import ExpipeBrowser 1.0

import "md5.js" as MD5
import "firebase.js" as Firebase

Item {
    id: root
    property string text
    property string property
    property var experimentData
    property color readyColor: "#121212"
    property color waitingColor: "#979797"
    property var experimentItem
    readonly property string backendText: experimentData ? experimentData[root.property] : ""
    property bool hasChanges: textInput.text != backendText

    width: 400
    height: 24

    function putChanges(callback) {
        if(!hasChanges) {
            console.log("No change, returning")
            if(callback) {
                callback()
            }
            return
        }
        var name = "experiments/" + experimentData.id
        var targetProperty = root.property
        var data = {}
        data[root.property] = textInput.text
        Firebase.patch(name, data, function(req) {
            console.log("Patch result:", req.status, req.responseText)
            textInput.text = Qt.binding(function() {return backendText})
            textInput.readOnly = false
            textInput.color = root.readyColor
            if(callback) {
                callback()
            }
        })
        textInput.readOnly = true
        textInput.color = root.waitingColor
    }

    onBackendTextChanged: {
        backgroundAnimation.restart()
    }

    Row {
        spacing: 8
        Text {
            id: label
            width: 200
            horizontalAlignment: Label.AlignRight
            color: "#434343"
            text: root.text + ":"
        }
        TextInput {
            id: textInput
            text: backendText
            width: 200
            horizontalAlignment: Label.AlignLeft
            color: "#121212"

            onEditingFinished: {
                putChanges()
            }

            Rectangle {
                id: background
                anchors.fill: parent
                color: "green"
                opacity: 0

                NumberAnimation {
                    id: backgroundAnimation
                    target: background
                    property: "opacity"
                    duration: 1000
                    easing.type: Easing.InOutQuad
                    from: 0.2
                    to: 0
                }
            }
        }
    }
}
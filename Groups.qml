import QtQuick 2.6
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.1
import QtQuick.LocalStorage 2.0

Page {
    property var groups:[]
    property var token
    property var username

    Component.onCompleted: {
        readStuff();
        listView.model=0;
        listView.model=groups;
    }

    id: root
    anchors.fill: parent
    header: ToolBar {
                Label{
                    padding: 10
                    text: qsTr("Groups")
                    font.pixelSize: 20
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                ToolButton {
                            text: qsTr("Back")
                            anchors.right: parent.right
                            anchors.rightMargin: 10
                            anchors.verticalCenter: parent.verticalCenter
                            onClicked: {
                                root.StackView.view.pop();
                            }
               }
    }

    ListView {


       id: listView
       anchors.fill: parent
       topMargin: 48
       leftMargin: 48
       bottomMargin: 48
       rightMargin: 48
       spacing: 20
       model:groups
       delegate: ItemDelegate {
          text: modelData
          width: listView.width - listView.leftMargin - listView.rightMargin
          height: avatar.implicitHeight
          leftPadding: avatar.implicitWidth + 32

          Image {

             id: avatar
             source: "qrc:/Groups.png"
          }
          onClicked: {

                root.StackView.view.push("qrc:/Conversation.qml", {
                                             token : token,
                                             inConversationWith:modelData ,
                                             username:username,
                                             sendCommand:"sendmessagegroup",
                                             getCommand:"getgroupchats"}
                                        );
          }
       }
    }

    function readStuff() {
        console.log(" save ")

        var db = LocalStorage.openDatabaseSync("QDeclarativeExampleDB", "1.0", "asyncStorage", 1000000);


        db.transaction(
                    function(tx) {
                        var rs = tx.executeSql('SELECT * FROM Groups');

                        for (var i = 0; i < rs.rows.length; i++) {
                            groups.push(JSON.parse(rs.rows.item(i).name))
                            console.log("test : " + groups[i]);
                        }

                    }
                )

    }

}

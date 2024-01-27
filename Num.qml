import QtQuick 2.0
import QtQuick.Controls 2.0
import ZoolControlsTime 1.0

Rectangle{
    id: r
    width: app.width
    height: colFecha.height+app.fs*0.2
    color: 'transparent'
    visible: lm.get(lv.currentIndex).txt==='Num'
    property alias controlTimeFecha: controlTimeFecha
    Column{
        id: colFecha
        spacing: app.fs*0.2
        anchors.centerIn: parent
        ZoolControlsTime{
            id: controlTimeFecha
            fs: showTime?app.width*0.07:app.width*0.14
        }
        ButtonGroup {
            buttons: columnRbs.children
        }
        Column{
            id: columnRbs
            RadioButton {
                id: rb1
                checked: true
                Text{
                    text: 'En °3 persona del singular'
                    font.pixelSize: app.fs*0.5
                    color: apps.fontColor
                    anchors.left: parent.right
                    anchors.leftMargin: app.fs*0.5
                }
            }
            RadioButton {
                id: rb2
                Text{
                    text: 'En °3 persona del plural'
                    font.pixelSize: app.fs*0.5
                    color: apps.fontColor
                    anchors.left: parent.right
                    anchors.leftMargin: app.fs*0.5
                }
            }
        }
        Button{
            text: 'Calcular Numero'
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: app.fs
            onClicked: {
                lv.currentIndex=0
                let tipo=0
                if(rb2.checked)tipo=1
                let resCalc=getNumNac()
                clear()
                log(getJsonDataNumPit(resCalc[0], resCalc[1], tipo))

            }
        }
    }
}

import QtQuick 2.0
import QtQuick.Controls 2.0
import ZoolControlsTime 1.0

Rectangle{
    id: r
    width: app.width
    height: colFecha.height+app.fs*0.2
    color: 'transparent'
    visible: lm.get(lv.currentIndex).txt==='Astro'
    Column{
        id: colFecha
        spacing: app.fs*0.2
        anchors.centerIn: parent
        ComboBox{
            id: cb1
            width: r.width-app.fs
            height: app.fs*1.5
            model: app.aBodies
            font.pixelSize: app.fs
            anchors.horizontalCenter: parent.horizontalCenter
        }
        ComboBox{
            id: cb2
            width: r.width-app.fs
            height: app.fs*1.5
            //model: ['Ninguno', ]
            font.pixelSize: app.fs
            anchors.horizontalCenter: parent.horizontalCenter
            Component.onCompleted: {
                let a=['Elegir Signo']
                for(var i=0;i < app.signos.length; i++){
                    a.push(app.signos[i])
                }
                model=a
            }
        }
        ComboBox{
            id: cb3
            width: r.width-app.fs
            height: app.fs*1.5
            model: ['Elegir Casa', 'Casa 1', 'Casa 2', 'Casa 3', 'Casa 4', 'Casa 5', 'Casa 6', 'Casa 7', 'Casa 8', 'Casa 9', 'Casa 10', 'Casa 11', 'Casa 12']
            font.pixelSize: app.fs
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Button{
            text: 'Buscar'
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: app.fs
            visible: cb2.currentIndex>0 || cb3.currentIndex>0
            onClicked: {
                lv.currentIndex=0
                let tipo=0
                //if(rb2.checked)tipo=1
                let resCalc=getNumNac()
                clear()
                let bodie=app.aBodiesFiles[cb1.currentIndex]
                let sign=cb2.currentIndex>0?app.aSignsLowerStyle[cb2.currentIndex - 1]:'Elegir Signo'
                let house=cb3.currentIndex
                log(getJsonData(bodie, sign, house))

            }
        }
    }
}

import QtQuick 2.0

Rectangle{
    id: r
    width: w
    height: w*1.5

    border.width: 0
    border.color: 'red'
    color: 'transparent'
    property int w: app.fs
    property int ci: -1
    signal pressed(int ci)

    MouseArea{
        anchors.fill: parent
        onClicked: {
            r.pressed(r.ci)
        }
    }
    Canvas {
        width: parent.height*0.8
        height: width
        anchors.centerIn: parent
        opacity: 0.5
        //visible: index!==4
        //anchors.verticalCenter: parent.verticalCenter
        onPaint: {
            var ctx = getContext("2d")
            ctx.fillStyle = "red"
            ctx.beginPath();
            ctx.moveTo(width*0.5, 0);
            ctx.lineTo(width, height);
            ctx.lineTo(0, height);
            ctx.closePath();

            context.fillStyle = "gray";
            context.fill();
            //ctx.fillRect(0, 0, width, height)

        }
    }

    //               Text {
    //                   id: txt1
    //                   text: index
    //                   font.pixelSize: app.fs
    //                   color: 'yellow'
    //                   anchors.centerIn: parent
    //               }

    Component.onCompleted: {
        //        if(index===3){
        //            rotation=-90
        //        }
        //        if(index===5){
        //            rotation=90
        //        }
        //        if(index===7){
        //            rotation=180
        //        }
    }
}

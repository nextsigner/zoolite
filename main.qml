import QtQuick 2.12
import QtQuick.Window 2.2
import QtQuick.Controls 2.5
import QtMultimedia 5.12
import QtGraphicalEffects 1.12
import QtQuick.Dialogs 1.2
import unik.Unik 1.0
import Qt.labs.settings 1.1
import QtQuick.Shapes 1.12
import QtWebChannel 1.0
import QtWebSockets 1.1

//import ZoolMapData 1.0


import "qrc:Funcs.js" as JS
import "qrc:"

ApplicationWindow {
    id: app
    visible: true
    width: Qt.platform.os==='android'?640:Screen.width*0.3
    height: Qt.platform.os==='android'?400:Screen.height
    title: "Zoolite"
    color: 'black'
    property bool dev: false
    property int fs: app.width*0.1
    property string uZoolandVersion: ''
    property var aUrlsReps: []
    property int currentUrlRepIndex: 0

    property int uZipCount: 0
    property int uZipNumberDes: 0

    property var signos: ['Aries', 'Tauro', 'Géminis', 'Cáncer', 'Leo', 'Virgo', 'Libra', 'Escorpio', 'Sagitario', 'Capricornio', 'Acuario', 'Piscis']
    property var aSignsLowerStyle: ['aries', 'tauro', 'geminis', 'cancer', 'leo', 'virgo', 'libra', 'escorpio', 'sagitario', 'capricornio', 'acuario', 'piscis']
    property var aBodies: ['Sol', 'Luna', 'Mercurio', 'Venus', 'Marte', 'Júpiter', 'Saturno', 'Urano', 'Neptuno', 'Plutón', 'N.Norte', 'N.Sur', 'Quirón', 'Selena', 'Lilith', 'Pholus', 'Ceres', 'Pallas', 'Juno', 'Vesta']
    property var aBodiesFiles: ['sol', 'luna', 'mercurio', 'venus', 'marte', 'jupiter', 'saturno', 'urano', 'neptuno', 'pluton', 'nodo_norte', 'nodo_sur', 'quiron', 'selena', 'lilith', 'pholus', 'ceres', 'pallas', 'juno', 'vesta']


    onDevChanged: {
        updateMenu()
    }
    Settings{
        id: apps
        fileName: unik.getPath(4)+'/zooliteMain.cfg'
        property string fontColor: 'white'
        property string backgroundColor: 'black'
    }
    Unik{
        id: unik
        onUkStdChanged: {
            let std=ukStd
            std=std.replace(/&quot;/g, '"')
        }
        Component.onCompleted: {
            unik.setEngine(engine)
        }
    }
    Column{
        spacing: app.fs*0.5
        //anchors.bottom: parent.bottom
        anchors.top: parent.top
        ListView{
            id: lv
            width: app.width
            height: app.fs
            spacing: app.fs*0.1
            anchors.horizontalCenter: parent.horizontalCenter
            //clip: true
            orientation: ListView.Horizontal
            model: lm
            delegate: compItemLv
            ListModel{
                id: lm
                function addItem(t,d){
                    return{
                        txt:t,
                        des: d
                    }
                }
            }
        }
        Num{id: num}
        Astro{id: astro}
        Rectangle{
            width: app.width
            height:app.height-lv.height-app.fs*4
            color: 'black'
            border.width: 1
            border.color: 'white'
            visible: lm.get(lv.currentIndex).txt==='Inicio'
            Flickable{
                id: flk
                anchors.fill: parent
                contentWidth: parent.width
                contentHeight: ta.contentHeight+app.fs*3
                clip: true
                ScrollBar.vertical: ScrollBar {
                    //parent: flk.parent
                    width: app.fs*0.5
                    anchors.top: flk.top
                    anchors.left: flk.right
                    anchors.leftMargin: 0-app.fs*0.5
                    anchors.bottom: flk.bottom
                    policy: ScrollBar.AlwaysOn
                }
                //TextArea{
                Text{
                    id: ta
                    width: parent.width-app.fs*0.751001
                    wrapMode: TextArea.WordWrap
                    color: 'white'
                    font.pixelSize: app.fs*0.5
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.horizontalCenterOffset: 0-app.fs*0.25
                }
            }
            //HostEditor{id: hostEditor; visible: false}
        }

    }
    Mando{
        id: mando
        anchors.bottom: parent.bottom
        anchors.bottomMargin: app.fs*0.1
        anchors.horizontalCenter: parent.horizontalCenter
    }
    Component{
        id: compItemLv
        Item{
            id: xItem
            width: txtItem.contentWidth+app.fs*0.5
            height: app.fs*0.8
            anchors.verticalCenter: parent.verticalCenter
            property bool selected: index===lv.currentIndex
            onSelectedChanged: {
                //tLogTip.restart()
                //tLogTip.text='\n'+des
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    lv.currentIndex=index
                    runEnter()
                }
            }
            Rectangle{
                anchors.fill: parent
                radius: app.fs*0.25
                opacity: xItem.selected?1.0:0.5
            }
            Text{
                id: txtItem
                text: txt
                font.pixelSize: app.fs*0.65
                anchors.centerIn: parent
            }
        }

    }
    //Splash{id: splash; visible: apps.autoLoad}
    Shortcut{
        sequence: 'Down'
        onActivated: {
            runToDown()
        }
    }
    Shortcut{
        sequence: 'Up'
        onActivated: {
            runToUp()
        }
    }
    Shortcut{
        sequence: 'Left'
        onActivated: {
            runToLeft()
        }
    }
    Shortcut{
        sequence: 'Right'
        onActivated: {
            runToRight()
        }
    }
    Shortcut{
        sequence: 'Enter'
        onActivated: {
            runEnter()
        }
    }
    Shortcut{
        sequence: 'Return'
        onActivated: {
            runEnter()
        }
    }

    Component.onCompleted: {
        updateMenu()
        app.requestActivate()
        //let s=''
        //s+=unik.getFile('./android/assets/modules/ZoolMapData/jupiter.json')
        //ta.text=s
        //ta.text=getJsonData('jupiter')
        let s=getJsonData('sol', 'aries', 1)
        ta.text=s
    }
    function getJsonData(bodie, sign, house){
        let path='assets:/modules/ZoolMapData/'
        if(Qt.platform.os==='linux')path='./android/assets/modules/ZoolMapData/'
        let s=''

        //ta.text=s
        let r=''
        let tit=(''+bodie+' en '+sign+'').toUpperCase()
        let json
        s+=unik.getFile(path+bodie+'.json')
        json=JSON.parse(s)
        //return sign
        if(sign!=='Elegir Signo'){
            r+='<h2>'+tit+'</h2><br>'
            for(var i=0;i<Object.keys(json[bodie+'_en_'+sign].manifestaciones).length; i++){
                var keys = Object.keys(json[bodie+'_en_'+sign].manifestaciones);
                //ta.text+=keys[i]+'\n'
                let titItem='<h3>'+(''+keys[i]).toUpperCase().replace(/_/g, ' ')+'</h3>'
                r+=titItem
                let contItem=json[bodie+'_en_'+sign].manifestaciones[keys[i]]
                r+=contItem+'<br>'
            }
        }
        //ta.text=house
        //return house
        if(house!==0){
            tit=(''+bodie+' en casa '+house+'').toUpperCase()
            r+='<h2>'+tit+'</h2><br>'
            for(var i=0;i<Object.keys(json[bodie+'_en_casa_'+house].manifestaciones).length; i++){
                keys = Object.keys(json[bodie+'_en_casa_'+house].manifestaciones);
                //ta.text+=keys[i]+'\n'
                let titItem='<h3>'+(''+keys[i]).toUpperCase().replace(/_/g, ' ')+'</h3>'
                r+=titItem
                let contItem=json[bodie+'_en_casa_'+house].manifestaciones[keys[i]]
                r+=contItem+'<br>'
            }
        }
        return r
    }
    function getJsonDataNumPit(form, num, tipo){
        let path='assets:/modules/ZoolMapData/'
        if(Qt.platform.os==='linux')path='./android/assets/modules/ZoolMapData/'
        let tipoCont='_segunda_persona'
        if(tipo===1){
            tipoCont='_resumida'
        }
        let s=''
        s+=unik.getFile(path+'numerologia'+tipoCont+'.json')
        //ta.text=s
        //lv.currentIndex=0
        //return
        let r=''
        let tit=('Vibración '+num+'').toUpperCase()
        r+='<h2>'+tit+'</h2><br>'
        r+='<p><b>Cálculo:</b> '+form+'</p><br>'
        let json=JSON.parse(s)
        for(var i=0;i<Object.keys(json['vibración_'+num].manifestaciones).length; i++){
            var keys = Object.keys(json['vibración_'+num].manifestaciones);
            //ta.text+=keys[i]+'\n'
            let titItem='<h3>'+(''+keys[i]).toUpperCase().replace(/_/g, ' ')+'</h3>'
            r+=titItem
            let contItem=json['vibración_'+num].manifestaciones[keys[i]]
            r+=contItem+'<br>'
        }
        r+='<h4>Manifestaciones Negativas</h4><br>'
        for(i=0;i<Object.keys(json['vibración_'+num].manifestaciones_negativas).length; i++){
            keys = Object.keys(json['vibración_'+num].manifestaciones_negativas);
            //ta.text+=keys[i]+'\n'
            let titItem='<h3>'+(''+keys[i]).toUpperCase().replace(/_/g, ' ')+'</h3>'
            r+=titItem
            let contItem=json['vibración_'+num].manifestaciones_negativas[keys[i]]
            r+=contItem+'<br>'
        }
        return r
    }
    function updateMenu(){
        lm.clear()
        lm.append(lm.addItem('Inicio', 'Presione Enter para lanzar la aplicación.'))
        lm.append(lm.addItem('Num', 'Presione Enter para definir fecha.'))
        lm.append(lm.addItem('Astro', 'Presione Enter para definir fecha.'))
        if(app.dev){
            lm.append(lm.addItem('Limpiar', 'Presione Enter para eliminar archivos descargados anteriormente.'))
            lm.append(lm.addItem('!Listar', 'Presione Enter para listar los archivos descargados de la aplicación.'))
        }
        lm.append(lm.addItem('Salir', 'Presione Enter para cerrar esta aplicación.'))
        lv.currentIndex=0
    }
    function runEnter(){
        //tLogTip.stop()
        var fp
        var h
        if(lv.currentIndex===0){
            //Cargar
            loadApp()
            return
        }
        //if(lv.currentIndex===1){

        //if(lv.currentIndex===lm.count-1){
        if(lm.get(lv.currentIndex).txt==='Salir'){
            //Salir
            Qt.quit()
        }
    }
    property int cantReqDev: 0
    function runToLeft(){
        //splash.visible=!splash.visible
        //        if(tAutoLoad.running){
        //           //tAutoLoad.stop()

        //            return
        //        }
        if(lv.currentIndex>0){
            lv.currentIndex--
        }else{
            if(app.cantReqDev<3){
                app.cantReqDev++
            }else{
                cantReqDev=0
            }
            if(app.cantReqDev===3){
                app.dev=true
            }else{
                app.dev=false
            }
        }
    }
    function runToRight(){
        if(lv.currentIndex<lm.count-1){
            lv.currentIndex++
        }
    }
    function runToDown(){
        //if(splash.visible){
        //splash.visible=false
        //return
        //}
        //        if(lm.get(lv.currentIndex).txt==='Urls' && app.dev){
        //           //tAutoLoad.stop()
        //           //tAutoUpdateGit.stop()
        //            if(app.currentUrlRepIndex<app.aUrlsReps.length-1){
        //                app.currentUrlRepIndex++
        //            }else{
        //                app.currentUrlRepIndex=0
        //            }
        //            let fp=unik.getPath(4)+'/url'
        //            let h=app.aUrlsReps[app.currentUrlRepIndex].replace(/ /g, '').replace(/\n/g, '')
        //            unik.setFile(fp, h)
        //            log('Se ha definido la Url de Repositorio para origen del código fuente: '+h)
        //            return
        //        }
        //        if(hostEditor.visible){
        //            hostEditor.toDown()
        //            return
        //        }
        if(flk.contentY<flk.contentHeight-flk.height){
            flk.contentY=flk.contentY+app.fs*0.5
        }
    }
    function runToUp(){
        //        if(lm.get(lv.currentIndex).txt==='Urls' && app.dev){
        //           //tAutoLoad.stop()
        //           //tAutoUpdateGit.stop()
        //            if(app.currentUrlRepIndex<app.aUrlsReps.length-1){
        //                app.currentUrlRepIndex++
        //            }else{
        //                app.currentUrlRepIndex=0
        //            }
        //            let fp=unik.getPath(4)+'/host'
        //            let h=app.aUrlsReps[app.currentUrlRepIndex].replace(/ /g, '').replace(/\n/g, '')
        //            unik.setFile(fp, h)
        //            log('Se ha definido la Url de Repositorio para Host: '+h)
        //            return
        //        }
        //        if(hostEditor.visible){
        //            hostEditor.toUp()
        //            return
        //        }
        if(flk.contentY>0){
            flk.contentY=flk.contentY-app.fs*0.5
        }
    }
    function log(t){
        ta.text+=t+'\n'
        flk.contentY=flk.contentHeight-flk.height
    }
    function clear(){
        ta.text=''
        flk.contentY=0
    }
    //-->NumPit
    function getNumNac(){
        let currentNumNacimiento=0
        /*let mfecha=txtDataSearchFecha.text.split('.')
        if(!mfecha[0]||!mfecha[1]||!mfecha[2]||mfecha[2].length<4){
            f0.text=''
            currentNumNacimiento=-1
            return
        }*/
        let d= num.controlTimeFecha.dia
        let m= num.controlTimeFecha.mes
        let a = num.controlTimeFecha.anio
        let sf=''+d+'/'+m+'/'+a
        let aGetNums=getNums(sf)
        currentNumNacimiento=aGetNums[0]
        //r.currentIndexAG=aGetNums[2]
        //log.ls('l1518: r.currentIndexAG: '+r.currentIndexAG, 500, 500)
        let dateP = new Date(num.controlTimeFecha.currentDate)
        //controlTimeYear.currentDate=dateP
        //r.currentDate = dateP
        let msfd=(''+d).split('')
        let sfd=''+msfd[0]
        if(msfd.length>1){
            sfd +='+'+msfd[1]
        }
        let msfm=(''+m).split('')
        let sfm=''+msfm[0]
        if(msfm.length>1){
            sfm +='+'+msfm[1]
        }
        //let msform=(''+a).split('')
        let msfa=(''+a).split('')
        let sfa=''+msfa[0]
        if(msfa.length>1){
            sfa +='+'+msfa[1]
        }
        if(msfa.length>2){
            sfa +='+'+msfa[2]
        }
        if(msfa.length>3){
            sfa +='+'+msfa[3]
        }
        let sform= sfd + '+' + sfm + '+' + sfa//msform[0] + '+' + msform[1] + '+'  + msform[2]+ '+'  + msform[3]
        let sum=0
        let mSum=sform.split('+')
        for(var i=0;i<mSum.length;i++){
            sum+=parseInt(mSum[i])
        }
        let mCheckSum=(''+sum).split('')
        if(mCheckSum.length>1){
            if(sum===11||sum===22||sum===33){
                //r.esMaestro=true
            }
            let dobleDigSum=parseInt(mCheckSum[0])+parseInt(mCheckSum[1])
            sform+='='+sum+'='+dobleDigSum
            let mCheckSum2=(''+dobleDigSum).split('')
            if(mCheckSum2.length>1){
                let dobleDigSum2=parseInt(mCheckSum2[0])+parseInt(mCheckSum2[1])
                sform+='='+dobleDigSum2
                currentNumNacimiento=dobleDigSum2
            }else{
                currentNumNacimiento=dobleDigSum
            }
        }else{
            currentNumNacimiento=sum
        }
        return [sform, currentNumNacimiento]
        //calcularAP()
    }
    function getNums(fecha){
        let d=''
        let nf=0
        let nf10=false
        let f=fecha
        let m0=f.split('/')
        let m1=m0[0].split('')
        if(m1.length<=0)return [-1, -1, -1]
        let m2=m0[1].split('')
        let m3=m0[2].split('')
        nf+=parseInt(m1[0])
        if(m1.length>1){
            nf+=parseInt(m1[1])
        }
        nf+=parseInt(m2[0])
        if(m2.length>1){
            nf+=parseInt(m2[1])
        }
        nf+=parseInt(m3[0])
        if(m3.length>3){
            nf+=parseInt(m3[1])
            nf+=parseInt(m3[2])
            nf+=parseInt(m3[3])
        }
        if(nf===10)nf10=true
        if(nf>9&&nf!==11&&nf!==22&&nf!==33&&nf!==44){
            let m4=(''+nf).split('')
            let nnf=parseInt(m4[0])
            if(m4.length>1){
                nnf+=parseInt(m4[1])
            }
            nf=nnf
        }
        d=''+parseInt(m0[0])
        if(parseInt(m0[0])>9){
            let m5=d.split('')
            let nfd=parseInt(m5[0])
            if(m5.length>1){
                nfd+=parseInt(m5[1])
            }
            d+='-'+nfd
        }
        if(nf===10)nf10=true
        if(nf>9){
            let m6=(''+nf).split('')
            let nnf6=parseInt(m6[0])
            if(m6.length>1){
                nnf6+=parseInt(m6[1])
            }
            nf=nnf6
        }
        let numArbolGen=-1
        if(!nf10){
            if(nf===1||nf===6||nf===8)numArbolGen=0
            if(nf===2||nf===5||nf===9)numArbolGen=1
            if(nf===3||nf===4)numArbolGen=2
            if(nf===7)numArbolGen=3
        }else{
            numArbolGen=2
        }
        return [nf, d, numArbolGen]
    }
    //<--NumPit
    //    function checkNewVersion(){
    //        let d=new Date(Date.now())
    //        let ms=d.getTime()
    //        let fp=unik.getPath(4)+'/host'
    //        let h=unik.getFile(fp).replace(/ /g, '').replace(/\n/g, '')
    //        JS.getRD(h+':8100/zool/getUZoolandVersion?r='+ms, setUZoolandVersion)
    //    }
    //    function loadApp(){
    //        //        log('Existe mainZoolandPath '+mainZoolandPath+'? '+unik.fileExist(mainZoolandPath))
    //        //        let m=(''+mainZoolandPath).replace('mainZooland.qml', 'main.qml')
    //        //        log('Existe main.qml '+m+'? '+unik.fileExist(m))
    //        //        if(Qt.platform.os==='android'){
    //        //            log('Existe /sdcard/Documents/mainZooland.qml ?'+unik.fileExist('/sdcard/Documents/mainZooland.qml'))
    //        //            log('Existe /sdcard/Documents/main.qml ?'+unik.fileExist('/sdcard/Documents/main.qml'))
    //        //        }

    //        //splash.enableAn=false
    //        //splash.t=splash.t+'\nCargando...'

    //        let v=apps.uZoolandNumberVersionDownloaded
    //        let mainLocation=''

    //        if(Qt.platform.os==='android'){
    //            mainLocation=unik.getPath(4)+'/mainZooland.qml'
    //            let fd=unik.getFile(unik.getPath(4)+'/main.qml')
    //            if(fd!=='error'){
    //                unik.setFile(mainLocation, fd)
    //            }
    //        }else{
    //            mainLocation=unik.getPath(4)+'/mainZooland.qml'
    //        }
    //        log('Cargando Zooland desde '+mainLocation)

    //        let mp=modulesPath
    //        if(!unik.folderExist(mp)){
    //            log('Error! La carpeta '+mp+' no existe!')
    //        }else{
    //            log('La carpeta '+mp+' no existe!')
    //        }

    //        //        let f=documentsPath+'/zooland'
    //        //        if(!unik.folderExist(f)){
    //        //            log('Error! La carpeta '+f+' no existe!')
    //        //            let bmkd=unik.mkdir(f, true)
    //        //            log('bmkd '+bmkd)
    //        //            if(unik.folderExist(f)){
    //        //                log('La carpeta '+f+' fue creada ahora mismo.')
    //        //            }else{
    //        //                log('Error! La carpeta '+f+' no se puede crear.')
    //        //            }
    //        //        }

    //        //engine.addImportPath(documentsPath+'/zooland_pn'+v+'/modules')
    //        if(!apps.engineLoadData){
    //            engine.load(mainLocation)
    //        }else{
    //            let mainQmlData=unik.getFile(mainLocation)
    //            engine.loadData(mainQmlData, 'file:./')
    //        }
    //    }
    //    function updateApp(num){
    //        if(app.dev){
    //            log('Actualizando de manera forzada de la aplicación...')
    //        }else{
    //            log('Actualizando aplicación...')
    //        }
    //        let f=unik.getPath(4)
    //        let fp=''
    //        let h=''

    //        if(num===1){
    //            let m0=apps.uZoolandZipAvailable.split('_v')
    //            let v=''
    //            if(apps.uZoolandZipAvailable!=='zooland-main.zip' && apps.uZoolandNumberVersionDownloaded >= 0){
    //                v=m0[1].replace('.zip', '')
    //            }
    //            f=unik.getPath(4)
    //            fp=unik.getPath(4)+'/host'
    //            h=unik.getFile(fp).replace(/ /g, '').replace(/\n/g, '')
    //            updated = unik.downloadGit(h+":8100/files/"+apps.uZoolandZipAvailable,f, false);
    //            return
    //        }
    //        if(num===2){
    //            f=unik.getPath(4)
    //            fp=unik.getPath(4)+'/url'
    //            h=unik.getFile(fp).replace(/ /g, '').replace(/\n/g, '')
    //            if(h==='' || h.length<=3){
    //                log('La url del código fuente no es válida.')
    //                log('Url: '+h)
    //                return
    //            }
    //            log('Comienza la descarga del código fuente desde '+h)
    //            log('Por favor espere.')
    //            if(apps.autoLoad){
    //                log('El código fuente será cargado y ejecutado automáticamente luego de la descarga.')
    //            }
    //            updated = unik.downloadGit(h,f, true);
    //            return
    //        }
    //    }
    //    function clearDir(){
    //        let fpHost=unik.getPath(4)+'/host'
    //        let hHost=unik.getFile(fpHost).replace(/ /g, '').replace(/\n/g, '')
    //        let fpUrl=unik.getPath(4)+'/url'
    //        let hUrl=unik.getFile(fpUrl).replace(/ /g, '').replace(/\n/g, '')

    //        let borrado=unik.clearDir(unik.getPath(4))

    //        if(borrado){
    //            log('Se han eliminado todos los archivos de la carpeta '+unik.getPath(4))
    //            unik.setFile(fpHost, hHost)
    //            unik.setFile(fpUrl, hUrl)
    //        }
    //    }
}

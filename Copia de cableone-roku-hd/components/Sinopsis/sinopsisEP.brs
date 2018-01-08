' ********** Copyright 2016 Roku Corp.  All Rights Reserved. ********** 
 ' inits details screen
 ' sets all observers 
 ' configures buttons for Details screen
 'TODO controlar mediatype al venir de canales en linea a series
Function Init()
    ? "[DetailsScreen] init"

'    'get titulo del contenido
    m.lblTitle              =   m.top.findNode("lblTitle")
    m.productList           = m.top.findNode("productList")
    'set label local (PASAR A GLOBAL O LOCALE)
    m.LABELOverview         = "Overview"
    m.LABELWatch            = "Watch"
    m.LABELSeason           = "Season"
    m.LABELEpisodes         = "Episodes"    
    m.LABELAddFavorite      = "Add Favorite"
    m.LABELRemoveFavorite   = "Delete Favorite"

    
     'Get y set de botones del menu horizontal
    m.btnOverview       =   m.top.findNode("btnOverview")
    m.btnOverview.text      = tr(m.LABELOverview)

    m.btnWatch          =   m.top.findNode("btnWatch")
    m.btnWatch.text     = tr(m.LABELWatch) 
    
    m.btnFavorite = m.top.findNode("btnFavorite")
    m.btnFavorite.text = tr(m.LABELAddFavorite)
    
    m.seasonList = m.top.findNode("seasonList")
    'get Menu toolbar
    m.mnutoolbar        =   m.top.findNode("mnutoolbar")
'    
'    'Alejandro redundancia
    m.DetailsScreenDeepLinking = m.top.findNode("productList")
    m.deeplinking = m.DetailsScreenDeepLinking
'    
'    'Eventos
    m.top.observeField("visible", "onVisibleChange")
    m.top.observeField("focusedChild", "OnFocusedChildChange")
    m.mnutoolbar.observeField("buttonSelected","OnButtonSelected")   
    m.productList.observeField("itemSelected", "makeDeeplinking")
    
'    
'    m.videoPlayer       =   m.top.findNode("VideoPlayer")
    m.poster            =   m.top.findNode("Poster")
'    m.grpContainer      =   m.top.findNode("gContainer")
    m.description       =   m.top.findNode("Description")
    
End Function

function OnIndexChanged()
?"OnIndexChanged"

m.loadingIndicator.control = "stop"
 '   if(m.simpleTask.result[0]<>invalid) then
 '       m.seasonList.content = m.simpleTask.result[0]
 '       m.seasonList.visible=true
 '       m.seasonList.setFocus(true)      
  '  end if

end function
sub makeDeeplinking()
    ?"making deeplinking..."
    
    contenido = m.productList.content.getChild(m.productList.itemFocused)
    ?"seeccionado"
     stop
    'dataDeep = getChnlInfo(contenido.labelProvider,contenido.streamUrl)
    dataDeep = getChnlInfo(contenido.labelProvider,contenido.streamUrl)
    m.simpleTask = CreateObject("roSGNode", "Deeplinking")  
    m.simpleTask.channelID =dataDeep.channelID
    m.simpleTask.contentID = dataDeep.contentID
    m.simpleTask.mediaType ="Movie"
        
    m.simpleTask.ObserveField("index", "onIndexChanged")
    m.simpleTask.control = "RUN"
end sub

function getChnlInfo( pProvider as string, pUrlDP as string) as Object
    ?"init getChnInfo"
    ?"init getChnInfo" + pProvider + pUrlDp
   
    
    aa = CreateObject("roAssociativeArray")
   
    mypos=0
    if(pProvider="Amazon.com") then
        
        mypos=Instr(1, pUrlDP, "/dp/")  
        aa.contentID = mid(pUrlDP, mypos+4)
        aa.channelID = "13"
    else
        if(pProvider="YouTube") then
            mypos=Instr(1, pUrlDP, "=")  
            aa.contentID = mid(pUrlDP, mypos+1)
            aa.channelID = "837"
        else
            if(pProvider="Hulu") then
                pUrlDP=pUrlDP.Replace("?d=Gracenote", "") 
                aa.contentID = mid(pUrlDP, 28)
                aa.channelID = "2285"
            else
                if(pProvider="Netflix") then
                
                    pUrlDP = pUrlDP.Replace("http://www.netflix.com/title/", "")
                    aa.contentID = pUrlDP.Replace("http://www.netflix.com/watch/", "")
                    
                    aa.channelID = "12"
                else
                    if(pProvider="VUDU") then
                        aa.contentID = pUrlDP.Replace("http://www.vudu.com/movies/#!content/", "")
                        aa.channelID = "13842"
                    end if
                end if
            end if
            
'13
        end if
    
    end if
   
    
    return aa
end function


function createFixture()
    ?"entra a createFixture"

    
    data = CreateObject("roSGNode", "ContentNode")

    dataItem = data.CreateChild("productItemData")
    dataItem.posterUrl = "pkg:/images/LogosChannels/Amazon.com.png"
    dataItem.labelProvider = "Netflix"
    dataItem.labelDefinition = "HD"
    dataItem.labelPrice = "9.99USD"
    dataItem.streamUrl = "http://www.netflix.com/watch/80057699"
   
    dataItem = data.CreateChild("productItemData")
    dataItem.posterUrl = "pkg:/images/LogosChannels/Hulu.png"
    dataItem.labelProvider = "Hulu"
    dataItem.labelDefinition = "SD"
    dataItem.labelPrice = "9.99USD"
    dataItem.streamUrl = "http://www.hulu.com/watch-mobile/759326"
 
  dataItem = data.CreateChild("productItemData")
    dataItem.posterUrl = "pkg:/images/LogosChannels/Hulu.png"
    dataItem.labelProvider = "Hulu"
    dataItem.labelDefinition = "SD"
    dataItem.labelPrice = "9.99USD"
    dataItem.streamUrl = "http://www.hulu.com/watch-mobile/759326"
    
     dataItem = data.CreateChild("productItemData")
    dataItem.posterUrl = "pkg:/images/LogosChannels/Hulu.png"
    dataItem.labelProvider = "Hulu"
    dataItem.labelDefinition = "SD"
    dataItem.labelPrice = "9.99USD"
    dataItem.streamUrl = "http://www.hulu.com/watch-mobile/759326"
    
     dataItem = data.CreateChild("productItemData")
    dataItem.posterUrl = "pkg:/images/LogosChannels/Hulu.png"
    dataItem.labelProvider = "Hulu"
    dataItem.labelDefinition = "SD"
    dataItem.labelPrice = "9.99USD"
    dataItem.streamUrl = "http://www.hulu.com/watch-mobile/759326"           
    contenido.strProducto =  data

    'm.top.content = contenido
     'm.productList.content = data
        ?"asigna a productlist a createFixture"
    
end function 

Sub OnButtonSelected()
    ?"[DetailsScreen] onButtonSelected"
    toggleView(m.mnutoolbar.buttonSelected)
  
End Sub
' set proper focus to buttons if Details opened and stops Video if Details closed
Sub onVisibleChange()
    ? "[DetailsScreen] onVisibleChange"
    if m.top.visible = true then
        ? "[DetailsScreen] onVisibleChange true"
        m.seasonList.content=invalid
         m.btnOverview.setFocus(true)
         toggleView(0)
     
    else
       ' m.videoPlayer.visible = false
       ' m.videoPlayer.control = "stop"
        ? "[DetailsScreen] onVisibleChange closing"
        end if
End Sub

' set proper focus to Buttons in case if return from Video PLayer
Sub OnFocusedChildChange()
? "[DetailsScreen] OnFocusedChildChange"
   
    'if m.top.isInFocusChain() and not m.btnOverview.hasFocus()  then
   '    ? "[DetailsScreen] OnFocusedChildChange true button focus"
     '  m.seasonList.setFocus(true)
   'else
   '   ? "[DetailsScreen] OnFocusedChildChange false rowlist focus"
   'end if
End Sub

' Content change handler
Sub OnContentChange()
?"onContentChange()"  
    m.description.content   = m.top.content
    m.lblTitle.text = m.top.content.labelText 'TITLE 
    m.poster.uri            = m.top.content.posterUrl
     m.productList.content = m.top.content.strProducto[0]
End Sub

sub toggleView(index as integer)
?"toggleview init>>" 
? index
    if(m.top.content<>invalid) then
        if(m.top.content.mediaType="serie" or m.top.content.mediaType="season") then
            m.btnWatch.visible      =false
            m.btnFavorite.visible   =false
    
        end if    
    end if

    if(index=0) then
        'showDeeplinking()
        showOverview()
    else
        if(index=1) then
            showDeeplinking()
        else
           if(index=2) then
            ?"favorite"
           else
            if(index=3)then
            ?"show seasons"
                cerrarOverview()
                showSeasons()
            end if
           end if
        endif
    endif

end sub

sub showOverview()
    ?"showOverview"
    
    m.description.visible="true"
    m.description.Categories.width = "1000"
    m.description.Actors.width = "1000"
    m.description.Rating.width = "1000"
    m.description.Description.width = "1000"
    m.productList.visible="false"
    m.productList.width="50"
    'abrirSeasons()
'    cerrarSeasons()
end sub

sub cerrarOverview()
 m.description.visible="false"
    m.description.Categories.width = "50"
    m.description.Actors.width = "50"
    m.description.Rating.width = "50"
    m.description.Description.width = "50"
end sub
sub abrirOverview()
 m.description.visible="true"
    m.description.Categories.width = "1000"
    m.description.Actors.width = "1000"
    m.description.Rating.width = "1000"
    m.description.Description.width = "1000"
    'if m.top.content.mediaType="serie" then
    'abrirSeasons()
    'end if
end sub

sub cerrarSeasons()
    m.seasonList.visible="false"
    m.seasonList.width="50"
end sub
sub abrirSeasons()
    m.seasonList.visible="true"
    m.seasonList.width="1000"
    m.seasonList.setFocus(true)
end sub

sub showDeeplinking()
    ?"showDeeplinking"
    m.description.visible="false"
    m.description.width="10"
    m.description.Categories.width = "10"
    m.description.Actors.width = "10"
    m.description.Rating.width = "10"
    m.description.Description.width = "10"
    m.productList.visible="true"
    m.productList.width="1000"
    m.productList.setFocus(true)
    
end sub

sub createTask(mediaType as String, serieid as String, callback as String )
    m.loadingIndicator = m.top.content.createChild("icono_cargando")
    m.simpleTask = CreateObject("roSGNode", "tskGetContentData")   
    m.simpleTask.serieid = serieid
    m.simpleTask.mediaType =mediaType
    m.simpleTask.ObserveField("index", callback)
    m.simpleTask.control = "RUN"
end sub

'final method to see

function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    ?key
    ?press
    if press then    
        if(key="OK") then
          ?"OK PRESSED"
            'if(m.productList.hasFocus()) then
             '   makeDeepLinking()
            'end if
        end if
        if(key="left" or key="right") then   
        ?"enter right"
           
'            if(key="left") then
'                if(m.btnOverview.hasFocus()) then
'                    m.btnFavorite.setFocus(true)
'                end if
'                if(m.btnWatch.hasFocus()) then
'                    m.btnOverview.setFocus(true)
'                end if
'                if(m.btnFavorite.hasFocus()) then
'                    m.btnWatch.setFocus(true)
'                end if            
'            end if
            if(key="right") then
                ?"enter moving r"

                
                if(m.btnOverview.hasFocus()) then
                    ?"to watch"
                    m.btnOverview.setFocus(false)
                    m.btnWatch.setFocus(true)
                    m.btnFavorite.setFocus(false)
                else
                    if(m.btnWatch.hasFocus()) then
                    ?"to favorite"
                        m.btnOverview.setFocus(false)
                        m.btnWatch.setFocus(false)
                        m.btnFavorite.setFocus(true)
                    else
                         if(m.btnFavorite.hasFocus()) then
                            ?"to overview"
                            
                            m.btnOverview.setFocus(true)
                            m.btnWatch.setFocus(false)
                            m.btnFavorite.setFocus(false)
                        end if                      
                    end if
                 
                end if
                
                         
            end if
  if(key="left") then
                ?"enter moving l"

                
                if(m.btnOverview.hasFocus()) then
                    ?"to watch"
                    m.btnOverview.setFocus(false)
                    m.btnWatch.setFocus(false)
                    m.btnFavorite.setFocus(true)
                else
                    if(m.btnWatch.hasFocus()) then
                    ?"to favorite"
                        m.btnOverview.setFocus(true)
                        m.btnWatch.setFocus(false)
                        m.btnFavorite.setFocus(false)
                    else
                         if(m.btnFavorite.hasFocus()) then
                            ?"to overview"
                            m.btnOverview.setFocus(false)
                            m.btnWatch.setFocus(true)
                            m.btnFavorite.setFocus(false)
                        end if                      
                    end if
                 
                end if
                
                         
            end if            
            result =true
          
        end if            
         if (key="back" and m.deeplinking.visible=true) or(key="back" and m.description.visible=true)  then
            if not m.btnWatch.hasFocus() and not m.btnOverview.hasFocus()  then
                m.btnOverview.setFocus(true)
                m.btnFavorite.setFocus(false)
                 result=true  
                else
                result=false
            endif 
        else
            
            result=false   
        end if
        
       else
        result=true   
       end if
    return result 
end function

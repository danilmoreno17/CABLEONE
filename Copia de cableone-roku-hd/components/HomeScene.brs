' ********** Copyright 2016 Roku Corp.  All Rights Reserved. **********  

sub init()
    crearContenido()   
    m.detailsScreen = m.top.findNode("Sinopsis")
    m.Search = m.top.findNode("Search") 
   m.loadingIndicator = m.top.findNode("loadingIndicator")
    m.video = m.top.findNode("Video")
    m.video.observeField("state", "OnVideoPlaybackFinished")
    m.hud = m.top.findNode("Hud")
    m.Dialog = m.top.findnode("Dialog")
    m.PanelSet = m.top.findNode("PanelSet")
    m.listPanel = m.panelSet.CreateChild("ListPanel")
    m.listPanel.observeField("createNextPanelIndex", "OnCreateNextPanelIndex")
     ' DetailsScreen Node with description, Video Player 
    m.DetailsListPanel = CreateObject("roSGNode", "LabelListPanel")
    m.DetailsListPanel.id = "DetailListPanel"
    m.DetailsListPanel.width = 0
    m.DetailsListPanel.list.observeField("itemfocused", "OnDetailsListPanelItemFocused")
    m.DetailsListPanel.list.observeField("itemSelected", "OnDetailsListPanelItemSelected")
    m.screenStack = []
    'set left side list
    m.LabelList = CreateObject("roSGNode", "LabelList")
    m.LabelList.observeField("itemfocused", "OnLabelListSelected")
    m.listPanel.list = m.LabelList   
    m.listPanel.appendChild(m.LabelList)
    m.ListPanel.setFocus(true)
 
    m.top.backgroundURI = "" '"pkg:/images/background.jpg"
    m.top.backgroundColor="#202020"        
    m.video = m.top.findNode("Video")
   ' m.video.observeField("state", "OnVideoPlaybackFinished")    
End sub
sub crearcontenido()
    m.top.content = CreateObject("roSGNode", "ContentNode")
    'content.title = m.Token.token
        m.top.content.title="title"
    Movies =     m.top.content.CreateChild("ContentNode")
    Movies.title = "Movies"    
    item = Movies.CreateChild("database_component")

    Series =     m.top.content.CreateChild("ContentNode")
    Series.title = "Series"    

    Guide =     m.top.content.CreateChild("ContentNode")
    Guide.title = "Guide"    
    Favourites =     m.top.content.CreateChild("ContentNode")
    Favourites.title = "Favourites"    
    Histories =     m.top.content.CreateChild("ContentNode")
    Histories.title = "Histories"    
    Reminders =     m.top.content.CreateChild("ContentNode")
    Reminders.title = "Reminders"  
    'TODO: Parametrizar  
    'createserieTask("season","SH017222300000","OnIndexChanged")
   'createTask("movie","10","1","99","OnIndexChanged",["Netflix","VUDU"],["Action"])
    createTask("movie","10","1","99","OnIndexChanged",["Netflix","VUDU"],["Action","Comedy-Romance","Drama","Sport","Adult","Misc","Documentary","Anime","Kids-Family","SciFi-Horror","International","Soap-Sitcom"])
    'createTask("serie","1","1","99","OnIndexChanged",["Netflix","VUDU"],["Action","Comedy-Romance","Drama","Sport","Adult","Misc","Documentary","Anime","Kids-Family","SciFi-Horror","International","Soap-Sitcom"])
                            
        
end sub

sub createTask(mediaType as String, limit as String, offset as String, permission as String, callback as String, providers as object, category as object)
    m.simpleTask = CreateObject("roSGNode", "tskGetContentData")   
    m.simpleTask.provider = providers
    
    m.simpleTask.mediaType =mediaType
    m.simpleTask.categories = category
    m.simpleTask.limit =limit
    m.simpleTask.offset = offset
    m.simpleTask.permission =permission
    m.simpleTask.ObserveField("index", callback)
    m.simpleTask.control = "RUN"
end sub

function OnIndexChanged()
?"OnIndexChanged"
stop
if(m.simpleTask.mediaType="movie" or m.simpleTask.mediaType="Movies")  then
    ?"onIndexChanged en movie"
    ?m.simpleTask.result[0]
    m.ContentListPanel.list.content = m.simpleTask.result[0]
    '
    'm.top.content.getChild(0).content = m.ContentListPanel.list.content
    m.top.content.replaceChild(m.ContentListPanel.list.content,0)
    createTask("serie","10","1","99","OnIndexChanged",["Netflix","VUDU"],["Action","Comedy-Romance","Drama","Sport","Adult","Misc","Documentary","Anime","Kids-Family","SciFi-Horror","International","Soap-Sitcom"])
else

    if(m.simpleTask.mediaType="serie" or m.simpleTask.mediaType="Series") and m.simpleTask.result<>invalid then
   ?"onIndexChanged en serie"
        m.top.content.replaceChild(m.simpleTask.result[0],1)
        if m.LabelList.itemFocused=1 then
            m.ContentListPanel.list.content = m.simpleTask.result[0]
        end if
    else
        if(m.simpleTask.mediaType="service") and m.simpleTask.result<>invalid then
        m.top.content.replaceChild(m.simpleTask.result[0],2)
            m.ContentListPanel.list.content = m.simpleTask.result[0]
        end if
    end if   
end if
m.loadingIndicator.control = "stop"
end function


Sub OnLabelListSelected()
    ?"[HomeScreen]OnLabelListSelected"
    ?"[HomeScreen]OnLabelListSelected itemFocused="
    ?m.LabelList.itemFocused
    intIndex = m.LabelList.itemFocused
    
    if(intIndex>=0)then
            ?"content children>>>>"
           ?m.top.content.getChild(intIndex).getchildCount()
        if m.ContentListPanel <> invalid and m.top.content.getChild(intIndex).getchildCount()>0 then
       ' stop
        
            m.ContentListPanel.list.content="" 
            m.ContentListPanel.list.content=m.top.content.getChild(intIndex)
        else
            if intIndex=0 and m.top.content.getChild(0).getchildCount()=0 then
                createTask("movie","1","1","99","OnIndexChanged",["Netflix","VUDU"],["Action","Comedy-Romance","Drama","Sport","Adult","Misc","Documentary","Anime","Kids-Family","SciFi-Horror","International","Soap-Sitcom"])
            else
                if intIndex=1 and m.top.content.getChild(1).getchildCount()=0 then
                'TODO: Parametrizar
                    createTask("serie","10","1","99","OnIndexChanged",["Netflix","VUDU"],["Action","Comedy-Romance","Drama","Sport","Adult","Misc","Documentary","Anime","Kids-Family","SciFi-Horror","International","Soap-Sitcom"])    
                else
                    if intIndex=2 and     m.top.content.getChild(2).getchildCount()=0      then
                     
                        m.simpleTask = CreateObject("roSGNode", "tskGetLiveContent")   
                        m.simpleTask.mediaType = "service"
                        m.simpleTask.ObserveField("index", "OnIndexChanged")
                        m.simpleTask.control = "RUN"
                    end if   
                end if
            end if
        end if
    end if
end sub


'triggers when content received
'______________________________
Sub OnChangeLabelContent() 
    m.LabelList.content = m.top.LabelContent
End Sub 
Sub OnChangeOptionsContent()
    'm.DetailsListPanel.list.content = m.top.OptionsContent
End Sub
Sub OnChangeContent()
    if m.ContentListPanel <> invalid then
        m.ContentListPanel.list.content=m.top.content.getChild(0).getChild(0).content
    end if
End Sub


'______________________________

Sub OnCreateNextPanelIndex()
    'print "in HomeScene OnCreateNextPanelIndex()"
    m.ContentListPanel       = CreateObject("roSGNode", "MarkupListPanel")
    
    if m.ContentListPanel = invalid then return
    
    'm.ContentListPanel.width = "full"
    m.ContentListPanel.height = 524
    'setup layout of this panel
    list                     = m.ContentListPanel.list
    list.itemComponentName   = "VideoItem"
    list.itemSize            = [m.ContentListPanel.width, 200]
    list.itemSpacing         = [0, 30]
    
     list.translation="[-50, 0]"
     list.itemSize="[1827, 218]"
     list.numRows="2"
     list.itemSpacing="[13, 0]"
     list.focusXOffset="[147]"
     list.rowFocusAnimationStyle="fixedFocusWrap"
     'list.rowItemSize="[[262, 147]]"
     list.rowHeights = [500,500,500,500,500,500,500,500,500,500,500,500]
     list.rowItemSize = [[320,440]]
     list.rowItemSpacing="[[19.5, 3]]"
     list.showRowLabel="true"
     list.showRowCounter="true"
     list.rowLabelOffset="[[147, 20]]"
    
    list.observeField("itemFocused", "OnContentListPanelItemFocused")
    list.observeField("rowItemSelected", "OnRowItemSelected")      
    list.ObserveField("rowItemFocused", "onRowItemFocused")  
    'set loading indicator to panel
    m.listPanel.nextPanel    = m.ContentListPanel
    if m.top.content <> invalid
    '    stop
        m.ContentListPanel.list.content = m.top.content.getChild(0).getChild(0).content
    end if
    m.global.addFields( {Token:m.top.content.title} ) 
End Sub


function onRowItemFocused() as void
    row = m.ContentListPanel.list.rowItemFocused[0]
    col = m.ContentListPanel.list.rowItemFocused[1]
    print "Row Focused: " + stri(row)
    print "Col Focused: " + stri(col)
end function

Sub PlayVideoFromGrid(pcontent as object)
    ? "[HomeScene] OnRowItemSelected"
    selectedItem = pcontent
    
    m.videoPlayer = CreateObject("roSGNode", "Video")
    m.videoPlayer.id="videoPlayer"
    m.videoPlayer.translation="[0, 0]"
    m.videoPlayer.width="1920"
    m.videoPlayer.height="1080"
    m.top.appendChild(m.videoPlayer)
    
    
    videoContent = createObject("RoSGNode", "ContentNode")
    videoContent.url = "https://roku.s.cpl.delvenetworks.com/media/59021fabe3b645968e382ac726cd6c7b/60b4a471ffb74809beb2f7d5a15b3193/roku_ep_111_segment_1_final-cc_mix_033015-a7ec8a288c4bcec001c118181c668de321108861.m3u8"
    ?"playing>>>>"+selectedItem.streamUrl
    'selectedItem.streamUrl
    videoContent.title = selectedItem.labelTitle
    videoContent.streamformat = "hls"
        
       
    'init of video player and start playback
        m.videoPlayer.content = videoContent
        
    'show video player
        ShowScreen(m.videoPlayer)

        m.videoPlayer.control = "play"
        'STOP
    m.videoPlayer.observeField("state", "OnVideoPlayerStateChange")
    m.videoPlayer.observeField("visible", "OnVideoPlayerVisibilityChange")
End Sub
Sub OnVideoPlayerStateChange()
    if(m.videoPlayer<>invalid) then
        ? "HomeScene > OnVideoPlayerStateChange : state == ";m.videoPlayer.state
        ?m.videoPlayer.content
            if m.videoPlayer.state = "error" OR m.videoPlayer.state = "finished"
                'hide video player in case of error
                HideScreen(m.videoplayer)
            end if    
    end if

end Sub

sub OnVideoPlayerVisibilityChange()
    'stop video playback
    if not m.videoPlayer.visible then
        m.videoPlayer.control = "stop"
        m.videoPlayer.content = invalid
        m.top.removeChild(m.videoPlayer)
        m.videoPlayer = invalid
        m.ContentListPanel.visible = "true"
    end if
end sub
' Row item selected handler
Function OnRowItemSelected()
?"[HomeScreen] OnRowItemSelected"
    m.ContentListPanel.visible = "false"
    row = m.ContentListPanel.list.rowItemFocused[0]
    col = m.ContentListPanel.list.rowItemFocused[1]
    
    selectedContent = m.ContentListPanel.list.content.getChild(row).getChild(col)
    
    if(selectedContent.mediaType="programme")then
    
        'm.video.content = m.ContentListPanel.list.content.getChild(row).getChild(col)
        PlayVideoFromGrid(selectedContent)
    else
    ' On select any item on home scene, show Details node and hide Grid
   ' showScreen(m.detailsScreen)
        m.detailsScreen.content=  m.ContentListPanel.list.content.getChild(row).getChild(col)
        m.detailsScreen.visible = "true"
        m.detailsScreen.setFocus(true) 
    end if
    
End Function

Sub OnContentListPanelItemFocused()

    'appends details buttons if content row is focused
    if m.panelSet.FindNode(m.DetailsListPanel.id) = invalid then
        m.panelSet.AppendChild(m.DetailsListPanel)
    end if
    
    if m.ContentListPanel = invalid then return
    
    'gets focused content node
    list = m.ContentListPanel.list
   
End Sub

Sub OnDetailsListPanelItemFocused()
    'if details buttons is focused then shows hud
    'm.hud.show = true
    ?"[HomeScene] OnDetailsListPanelItemFocused"
End Sub

Sub OnDetailsListPanelItemSelected()
    ?"[HomeScene] OnDetailsListPanelItemSelected"
    'on button selected details button plays video
    m.video.visible="true"
    m.video.control="play"
    m.video.setFocus(true)
End Sub

Sub OnVideoPlaybackFinished()
    if m.video.state="finished" then
        m.video.visible = false
        m.video.control="stop"
        m.DetailsListPanel.setFocus(true)
    end if    
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    ?key
    if press then
    
        if key="back" then
            ? "in HomeScene OnKeyEvent(back pressed)"           
            'close video when we press back
            if m.videoPlayer<>invalid then
                if m.videoPlayer.visible=true then
                
                m.videoPlayer.visible = false

                end if
                
                result = true       
            end if     
            if m.detailsScreen.visible then
                ? "in HomeScene OnKeyEvent(back pressed) closing detailsScreen"
                m.ContentListPanel.visible = "true"
    ' On select any item on home scene, show Details node and hide Grid
              
               m.detailsScreen.visible = "false"
                m.ContentListPanel.setFocus(true)
                result = true  
            else
                if m.ContentListPanel.hasFocus() then
                     m.ListPanel.setFocus()
                endif
                result=true         
            end if     
        else if key="options" then
           'we are not in video playback
            'If Not m.ContentListPanel.detailsScreen.visible Then
                if NOT m.dialog.visible then
                    m.focusedNode = m.panelSet.focusedChild
                    m.dialog.visible = true
                    m.dialog.setFocus(true)
                    result = true
                else
                    m.dialog.visible = false 
                    m.focusedNode.SetFocus(true)
                    result = true
                end if
            'end if
        end if
    else if key="back" and m.dialog.visible then
        m.Dialog.visible = false
        m.focusedNode.SetFocus(true)
        result = true           
    end if
    return result 
end function
Sub ShowScreen(node)
?"Showing screen"
    prev = m.screenStack.peek()
    if prev <> invalid
        prev.visible = false
    end if
    node.visible = true
    node.setFocus(true)
    m.screenStack.push(node)
End Sub

Sub HideTop()
    HideScreen(invalid)
end Sub

Sub HideScreen(node as Object)
    if node = invalid OR (m.screenStack.peek() <> invalid AND m.screenStack.peek().isSameNode(node)) 
        last = m.screenStack.pop()
        last.visible = false
        
        prev = m.screenStack.peek()
        if prev <> invalid
            prev.visible = true
            prev.setFocus(true)
        end if
    end if
End Sub

' ********** Copyright 2016 Roku Corp.  All Rights Reserved. ********** 
 
 sub RunUserInterface()
 'Se crea la escena
    screen = CreateObject("roSGScreen")
    scene = screen.CreateScene("HomeScene")
    port = CreateObject("roMessagePort")
    screen.SetMessagePort(port)
    screen.Show()   
    'gcurrent_user = CreateObject("roAssociativeArray")
    'gcurrent_user.AddReplace("parental_level", "15")
    'm.global.addFields( {current_user:gcurrent_user} )
     
'Se aniaden data de los menus    
    LabelList = [
        {title : "Movies"},
        {title : "Series"},
        {title : "Guide"},
        {title : "Favorites"},
        {title : "Historial"},
        {title : "Reminders"}
    ]
'Data del menu play  
    'OptionsList = [{Title:"Play"}]     
    OptionsList = [] 
    print "//************ - Crea Task MenuRowListScene Movies *************"
    
    
   ' scene.Content = GetContet()
   scene.backgroundUri = "pkg:/images/background.jpg"
    scene.LabelContent = ContentList2Node(LabelList)
    scene.OptionsContent = ContentList2Node(OptionsList)
    scene.Token = m.Token
    while true
        msg = wait(0, port)
        print "------------------"
        print "msg = "; msg
    end while
    
    if screen <> invalid then
        screen.Close()
        screen = invalid
    end if
    
end sub


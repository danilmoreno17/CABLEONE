' ********** Copyright 2016 Roku Corp.  All Rights Reserved. ********** 
 'setting top interfaces
Sub Init()
    m.top.Title             = m.top.findNode("Title")
    m.top.Description       = m.top.findNode("Description")
    m.top.ReleaseDate       = m.top.findNode("ReleaseDate")
    m.top.Value       = m.top.findNode("Value")
    m.top.Rating       = m.top.findNode("Rating")
    m.top.Categories       = m.top.findNode("Categories")
    m.top.Actors       = m.top.findNode("Actors")
    m.seasonList = m.top.findnode("seasonList")
    m.top.seasonList = m.seasonList
End Sub



' Content change handler
' All fields population
Sub OnContentChanged()
    
    item = m.top.content
       
    m.top.Actors.text           =item.strActors     
    m.top.Rating.text           =item.strRating
    m.top.Categories.text        =item.strCategories
    
    m.top.title.text = item.strTitle
    m.top.description.text = item.strDescription
    m.top.Description.width = "1000"
    
    title = item.title.toStr()
    if title <> invalid then
        m.top.Title.text = title.toStr()
    end if
    
    value =item.description
    
    if value <> invalid then
        if value.toStr() <> "" then
            m.top.Description.text = value.toStr()
        else
            m.top.Description.text = "No description"
        end if
    end if
  
End Sub

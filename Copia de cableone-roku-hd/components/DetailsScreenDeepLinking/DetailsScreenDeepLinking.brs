' ********** Copyright 2016 Roku Corp.  All Rights Reserved. ********** 
 ' inits details screen
 ' sets all observers 
 ' configures buttons for Details screen
Function Init()
?"[DetailsScreenDeepLinking]Init"


    m.top.observeField("visible", "onVisibleChange")
    m.top.observeField("focusedChild", "OnFocusedChildChange")

    m.itemText = m.top.findNode("itemText")
    m.itemArtist = m.top.findNode("itemArtist")
    m.itemImage = m.top.findNode("itemImage")
    m.playIcon = m.top.findNode("playIcon")
 

End Function


'///////////////////////////////////////////'
' Helper function convert AA to Node
Function ContentList2SimpleNode(contentList as Object, nodeType = "ContentNode" as String) as Object
    result = createObject("roSGNode",nodeType)
    if result <> invalid
        for each itemAA in contentList
            item = createObject("roSGNode", nodeType)
            item.setFields(itemAA)
            result.appendChild(item)
        end for
    end if
    return result
End Function

function itemContentChanged()
    m.itemImage.uri = "pkg:/images/LogosChannels/Amazon.com.png"'m.top.itemContent.label
    m.itemText.text = m.top.itemContent.TITLE
    m.itemArtist.text = m.top.itemContent.price
    updateLayout()
  end function
 
  function widthChanged()
    updateLayout()
  end function
 
  function heightChanged()
    updateLayout()
  end function
 
  function focusPercentChanged()
    if m.top.listHasFocus and m.top.focusPercent > 0.5
      m.itemText.color = "0x000000FF"
    else
      m.itemText.color = "0xFFFFFFFF"
    end if
    m.itemArtist.color = m.itemText.color
  end function
 
  function updateLayout()
    if m.top.height > 0 and m.top.width > 0
      posterSize = m.top.height
      m.itemImage.width = m.top.height - 20 ' make the posters square
      m.itemImage.height = m.top.height - 20
      m.itemText.width = m.top.width - m.itemImage.width - 20
      m.itemArtist.width = m.top.width - m.itemImage.width - 20
    end if
  end function
 



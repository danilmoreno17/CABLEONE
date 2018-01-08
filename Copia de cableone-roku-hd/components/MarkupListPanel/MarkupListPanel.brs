' ********** Copyright 2016 Roku Corp.  All Rights Reserved. ********** 

'cache children nodes for future operations
function Init()
    m.rowList       =   m.top.findNode("List")
    m.top.list = m.top.FindNode("List")
    m.top.width=1000
    m.top.observeField("focusedChild", "OnFocusedChildChanged")
     m.top.observeField("visible", "onVisibleChange")
    
end function


'handle list item focus change
function OnFocusedChildChanged()
? "[MarkUpListPanel] OnFocusedChildChanged"
    if m.top.isInFocusChain() AND not m.top.list.hasFocus() then
        m.top.list.setFocus(true)
        ? "[MarkUpListPanel] OnFocusedChildChanged"
        ? m.top.list.hasFocus()
        
        row = m.top.list.rowItemFocused[0]
        col = m.top.list.rowItemFocused[1]
        if row<>invalid and col<>invalid then
            content =m.top.list.content.getChild(row).getChild(col)
        end if
        
   
    end if
end function

' set proper focus to RowList in case if return from Details Screen
Sub onVisibleChange()
? "[MarkUpListPanel] onVisibleChange"
    if m.top.visible = true then
        m.top.list.setFocus(true)
    end if
End Sub
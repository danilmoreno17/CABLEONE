'***************** SIMPLE ROW LIST *****************

function init()
    print "in SimpleRowListPanel init()"
    m.top.rowLabelColor="0xa0b033ff"
    m.top.visible = true   
    m.top.observeField("focusedChild", "OnFocusedChildChanged")
    m.top.observeField("visible", "onVisibleChange")
end function

    
'handle list item focus change
function OnFocusedChildChanged()
? "[SimpleRowList] OnFocusedChildChanged"
    if m.top.isInFocusChain()  then
        ?"[SimpleRowList] OnFocusedChildChanged true "
    end if
end function

' set proper focus to RowList in case if return from Details Screen
Sub onVisibleChange()
? "[SimpleRowList] onVisibleChange"
    if m.top.visible = true then
        ?"[SimpleRowList] onVisibleChange  true"
    end if
End Sub
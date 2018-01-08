'********** Copyright 2016 Roku Corp.  All Rights Reserved. **********

function makeMetaData()
     print "Setear Credenciales................"
 
     if (m.top.menuOption="CALL_MOVIES")
        objContentNode = MoviesContentNode()
     else if (m.top.menuOption="CALL_SERIES")
        objContentNode = SeriesContentNode()
     else if (m.top.menuOption="CALL_SERIESEP")     
        objContentNode = SeriesEpContentNode()
     else if(m.top.menuOption="GET_TOKEN")
        ExecuteGetToken()
     else if(m.top.menuOption="4")
       objContentNode = ConvertToContentNodeSearch()
      else if (m.top.menuOption="GET_GUIDE")
        objContentNode = GuideContentNode()       
    else if (m.top.menuOption="GET_FAVORITE")
       objContentNode = FavoritesContentNode()
     else if (m.top.menuOption="GET_HISTORY")
       objContentNode = HistorialContentNode()
     else if (m.top.menuOption="GET_REMINDER")
       objContentNode = ReminderContentNode()
     else if (m.top.menuOption="DELETE_REMINDER")
       ExecuteDeleteReminder()
     else if (m.top.menuOption="DELETE_FAVORITE")
       ExecuteDeleteFavourite()
     else if (m.top.menuOption="PUT_FAVORITE")
       ExecutePutFavorite()
     else if (m.top.menuOption="POST_REMINDER")
       ExecutePostReminder()                 
    else if (m.top.menuOption="POST_HISTORY")
       ExecutePostHistory()
    else if (m.top.menuOption="IS_FAVORITE")
        'objContentNode = IsFavorite()   
    else if (m.top.menuOption="IS_REMIND")
        objContentNode = IsRemind()   
    end if

     'm.top.content = objContentNode
end function
function ExecuteGetToken()
    conn = CreateObject("roUrlTransfer")
    url = "http://ssolab1.nagra.com/net/qsp/gateway/http/js/signonService/signonByUser?arg0=FAB&arg1=1234"
    conn.SetUrl(url)
    conn.SetRequest("GET")    'do not forget to overwrite http method
    data = conn.GetToString()
    objToken = ParseJson(data)
    print "Token";objToken.token
    m.top.strToken =objToken.token
end function
function ExecuteDeleteReminder()
    objDeleteReminder = NewRequestFavs("http://ssolab1.nagra.com/net/useractivityvault/v1/clientdata/account/TQMG/reminders/"+m.top.contentId+"?token="+m.global.Token,m.top.requestOption,m.top.Body).Execute()
end function
function ExecuteDeleteFavourite()
    objDeleteFavorite = NewRequestFavs("http://ssolab1.nagra.com/net/useractivityvault/v1/clientdata/account/TQMG/favouriteslists/2551c3c0-e316-11e6-a12c-218dd48cc1a1/content/"+m.top.contentId+"?token="+m.global.Token,m.top.requestOption,m.top.Body).Execute()
    m.top.isboolean=m.isboolean  
end function
function ExecutePutFavorite()
    objPutFavorite = NewRequestFavs("http://ssolab1.nagra.com/net/useractivityvault/v1/clientdata/account/TQMG/favouriteslists/2551c3c0-e316-11e6-a12c-218dd48cc1a1/content/"+m.top.contentId+"?token="+m.global.Token,m.top.requestOption,m.top.Body).Execute()
    m.top.isboolean=m.isboolean        
end function
function ExecutePostHistory()
    objPostHistory = NewRequestFavs("http://ssolab1.nagra.com/net/useractivityvault/v1/clientdata/account/TQMG/history?token="+m.global.Token,m.top.requestOption,m.top.Body).Execute()
    m.top.isboolean=m.isboolean
end function
function ExecutePostReminder()
   objPostReminder = NewRequestFavs("http://ssolab1.nagra.com/net/useractivityvault/v1/clientdata/account/TQMG/reminders?token="+m.global.Token,m.top.requestOption,m.top.Body).Execute()
   print "reminder: ";objPostReminder.id
   m.top.contentId = objPostReminder.id                
end function
function ConvertToContentNodeSearch() as object
            content = createObject("roSGNode", "ContentNode")
             searchContent = NewRequest("https://213.244.195.170/metadata/solr/CMS4X/search?q="+m.top.contentId+"&fq=domain:"+CHR(34)+"Browser|"+CHR(34)+"").Execute()["response"] 
             print "docs :";searchContent.docs
             for each kind in searchContent.docs
                print "id: ";kind.id
                print kind.entity
                if(kind.entity="programme")
                    objContent = NewRequest("https://213.244.195.170/metadata/delivery/CMS4X/btv/programmes?&filter={"+CHR(34)+"id"+CHR(34)+":"+CHR(34)+""+kind.id+""+CHR(34)+"}&fields=["+CHR(34)+"id"+CHR(34)+","+CHR(34)+"Title"+CHR(34)+","+CHR(34)+"PromoImages"+CHR(34)+","+CHR(34)+"Description"+CHR(34)+","+CHR(34)+"Sinopsis"+CHR(34)+","+CHR(34)+"Year"+CHR(34)+","+CHR(34)+"period.start"+CHR(34)+","+CHR(34)+"period.end"+CHR(34)+","+CHR(34)+"Rating.Title"+CHR(34)+"]&sort=[["+CHR(34)+"period.start"+CHR(34)+",1]]&limit=10&offset=0").Execute()["programmes"]    
                else if(kind.entity="content")
                    objContent = NewRequest("https://213.244.195.170/metadata/delivery/CMS4X/vod/editorials?&filter={" + Chr(34) + "technical.deviceType" + Chr(34) + ":"  + Chr(34) + "Browser" + Chr(34) + ","+CHR(34)+"editorial._id"+CHR(34)+" : "+CHR(34)+""+kind.id+""+CHR(34)+"}&fields=[" + CHR(34) + "editorial._id" + Chr(34) + "," + Chr(34) + "editorial.Title" + Chr(34) + "," + Chr(34) + "editorial.title" + Chr(34) + "," + Chr(34) + "editorial.Description" + Chr(34) + "," + Chr(34) + "editorial.Actors" + Chr(34) + "," + Chr(34) + "editorial.Categories" + Chr(34) + "," + Chr(34) + "editorial.Rating" + Chr(34) + "," + Chr(34) + "editorial.episodeNumber" + Chr(34) + "," + Chr(34) + "editorial.PromoImages" + Chr(34) + "," + Chr(34) + "technical.Definition" + Chr(34) + "," + Chr(34) + "technical.media" + Chr(34) + "," + Chr(34) + "product.price" + Chr(34) + "," + Chr(34) + "product.type" + Chr(34) + "," + Chr(34) + "product.nodeRefs" + Chr(34) + "," + Chr(34) + "product.startPurchase" + Chr(34) + "," + Chr(34) + "product.endPurchase" + Chr(34) + "," + Chr(34) + "product.startValidity" + Chr(34) + "," + Chr(34) + "product.endValidity" + Chr(34) + "," + Chr(34) + "editorial.seriesRef" + Chr(34) + "," + Chr(34) + "voditem.nodeRefs" + Chr(34) + "]&sort=[[" + Chr(34) + "editorial.title" + Chr(34) + ",1]]&limit=10&offset=0" ).Execute()["editorials"]
                    'print "https://213.244.195.170/metadata/delivery/CMS4X/vod/editorials?&filter={" + Chr(34) + "technical.deviceType" + Chr(34) + ":"  + Chr(34) + "Browser" + Chr(34) + ","+CHR(34)+"editorial._id"+CHR(34)+" : "+CHR(34)+""+kind.id+""+CHR(34)+"}&fields=[" + CHR(34) + "editorial._id" + Chr(34) + "," + Chr(34) + "editorial.Title" + Chr(34) + "," + Chr(34) + "editorial.title" + Chr(34) + "," + Chr(34) + "editorial.Description" + Chr(34) + "," + Chr(34) + "editorial.Actors" + Chr(34) + "," + Chr(34) + "editorial.Categories" + Chr(34) + "," + Chr(34) + "editorial.Rating" + Chr(34) + "," + Chr(34) + "editorial.episodeNumber" + Chr(34) + "," + Chr(34) + "editorial.PromoImages" + Chr(34) + "," + Chr(34) + "technical.Definition" + Chr(34) + "," + Chr(34) + "technical.media" + Chr(34) + "," + Chr(34) + "product.price" + Chr(34) + "," + Chr(34) + "product.type" + Chr(34) + "," + Chr(34) + "product.nodeRefs" + Chr(34) + "," + Chr(34) + "product.startPurchase" + Chr(34) + "," + Chr(34) + "product.endPurchase" + Chr(34) + "," + Chr(34) + "product.startValidity" + Chr(34) + "," + Chr(34) + "product.endValidity" + Chr(34) + "," + Chr(34) + "editorial.seriesRef" + Chr(34) + "," + Chr(34) + "voditem.nodeRefs" + Chr(34) + "]&sort=[[" + Chr(34) + "editorial.title" + Chr(34) + ",1]]&limit=10&offset=0"
                    print "movies ";objContent
                    for each kinds in objContent
                        print kinds.Categories
                        print kinds.technicals[0]
                        itemContent = content.createChild("ContentNode")
                        itemContent.title = kinds.Title
                        itemContent.Description = kinds.Description
                        itemContent.ReleaseDate = kinds.Actors[0] 
                        itemContent.Rating = kinds.Rating.Title  + "            " + kinds.Categories[0]
                        itemContent.Stream = kinds.Technicals[0].media.AV_ClearTS.fileName
                        itemContent.url = kinds.Technicals[0].media.AV_ClearTS.fileName
                        itemContent.streamFormat = kinds.Technicals[0].media.AV_ClearTS.format
                        itemContent.HDPosterUrl = kinds.PromoImages[0]
                        itemContent.SDPosterUrl= kinds.PromoImages[0]        
                    end for
                end if
            end for
             
            m.top.content = content
            return content
end function
function IsFavorite() as boolean
    exist=false
    print "Token: ";m.global.Token
    objContentFav = NewRequestFavs("http://ssolab1.nagra.com/net/useractivityvault/v1/clientdata/account/TQMG/favouriteslists/2551c3c0-e316-11e6-a12c-218dd48cc1a1?token="+m.global.Token,"GET","invalid").Execute()["favourites"]
    'print "http://ssolab1.nagra.com/net/useractivityvault/v1/clientdata/account/TQMG/favouriteslists/2551c3c0-e316-11e6-a12c-218dd48cc1a1?token="+objToken.token
    for each kind in objContentFav
        if(kind.contentId=m.top.contentId)then
            exist=true
            print "si exite"
        end if
    end for
    m.top.isboolean = exist
    return exist
end function
function IsRemind() as boolean
    exist=false
    objContentRed = NewRequestFavs("http://ssolab1.nagra.com/net/useractivityvault/v1/clientdata/account/TQMG/reminders?token="+m.global.Token,"GET","invalid").Execute()["reminders"]
    'print "http://ssolab1.nagra.com/net/useractivityvault/v1/clientdata/account/TQMG/favouriteslists/2551c3c0-e316-11e6-a12c-218dd48cc1a1?token="+objToken.token
    IdRemind="invalid"
    for each kind in objContentRed
        if(kind.contentId=m.top.contentId)then
            exist=true
            IdRemind=kind.id
            print "si exite"
        end if
    end for
    m.top.remindId = IdRemind
    m.top.isboolean = exist
    return exist
end function
function MoviesContentNode() as object
            content = createObject("roSGNode", "ContentNode")
            print "ConvertToContentNode.................";m.global.current_user                    
            objContent = NewRequest("https://213.244.195.170/metadata/delivery/CMS4X/vod/editorials?&filter={" + Chr(34) + "technical.deviceType" + Chr(34) + ":"  + Chr(34) + "Browser" + Chr(34) + ","  + Chr(34) + "editorial.episodeNumber"  + Chr(34) + Chr(58) + "{" + Chr(34) +  "$exists" + Chr(34) + Chr(58) + "false}," + Chr(34) + "editorial.Categories" + Chr(34) + Chr(58) +  Chr(34) + "Action"  + Chr(34) + ","  + Chr(34) + "editorial.Rating.code"  + Chr(34) + ":{"  + Chr(34) + "$lte"  + Chr(34) + ":"  + Chr(34) + ""+m.global.current_user.parental_level+""  + Chr(34) + "}}&fields=[" + Chr(34) + "editorial._id" + Chr(34) + "," + Chr(34) + "editorial.Title" + Chr(34) + "," + Chr(34) + "editorial.title" + Chr(34) + "," + Chr(34) + "editorial.Description" + Chr(34) + "," + Chr(34) + "editorial.Actors" + Chr(34) + "," + Chr(34) + "editorial.Categories" + Chr(34) + "," + Chr(34) + "editorial.Rating" + Chr(34) + "," + Chr(34) + "editorial.episodeNumber" + Chr(34) + "," + Chr(34) + "editorial.PromoImages" + Chr(34) + "," + Chr(34) + "technical.Definition" + Chr(34) + "," + Chr(34) + "technical.media" + Chr(34) + "," + Chr(34) + "product.price" + Chr(34) + "," + Chr(34) + "product.type" + Chr(34) + "," + Chr(34) + "product.nodeRefs" + Chr(34) + "," + Chr(34) + "product.startPurchase" + Chr(34) + "," + Chr(34) + "product.endPurchase" + Chr(34) + "," + Chr(34) + "product.startValidity" + Chr(34) + "," + Chr(34) + "product.endValidity" + Chr(34) + "," + Chr(34) + "editorial.seriesRef" + Chr(34) + "," + Chr(34) + "voditem.nodeRefs" + Chr(34) + "]&sort=[[" + Chr(34) + "editorial.title" + Chr(34) + ",1]]&limit=10&offset=0" ).Execute()["editorials"]  ' '.Execute()["total_records"]  '
            print "URL **************************************"; "https://213.244.195.170/metadata/delivery/CMS4X/vod/editorials?&filter={" + Chr(34) + "technical.deviceType" + Chr(34) + ":"  + Chr(34) + "Browser" + Chr(34) + ","  + Chr(34) + "editorial.episodeNumber"  + Chr(34) + Chr(58) + "{" + Chr(34) +  "$exists" + Chr(34) + Chr(58) + "false}," + Chr(34) + "editorial.Categories" + Chr(34) + Chr(58) +  Chr(34) + "Action"  + Chr(34) + "}&fields=[" + Chr(34) + "editorial._id" + Chr(34) + "," + Chr(34) + "editorial.Title" + Chr(34) + "," + Chr(34) + "editorial.title" + Chr(34) + "," + Chr(34) + "editorial.Description" + Chr(34) + "," + Chr(34) + "editorial.Actors" + Chr(34) + "," + Chr(34) + "editorial.Categories" + Chr(34) + "," + Chr(34) + "editorial.Rating" + Chr(34) + "," + Chr(34) + "editorial.episodeNumber" + Chr(34) + "," + Chr(34) + "editorial.PromoImages" + Chr(34) + "," + Chr(34) + "technical.Definition" + Chr(34) + "," + Chr(34) + "technical.media" + Chr(34) + "," + Chr(34) + "product.price" + Chr(34) + "," + Chr(34) + "product.type" + Chr(34) + "," + Chr(34) + "product.nodeRefs" + Chr(34) + "," + Chr(34) + "product.startPurchase" + Chr(34) + "," + Chr(34) + "product.endPurchase" + Chr(34) + "," + Chr(34) + "product.startValidity" + Chr(34) + "," + Chr(34) + "product.endValidity" + Chr(34) + "," + Chr(34) + "editorial.seriesRef" + Chr(34) + "," + Chr(34) + "voditem.nodeRefs" + Chr(34) + "]&sort=[[" + Chr(34) + "editorial.title" + Chr(34) + ",1]]&limit=10&offset=0"
            
            playlist = CreateObject("roArray", 10, true)
            
            itemContent = content.createChild("ContentNode")
            itemContent.title = "Action"
            for each kind in objContent
                    print kind
                    subItemContent = itemContent.createChild("ContentNode")
                    subItemContent.id = kind.id
                    subItemContent.title = kind.Title
                    subItemContent.Description = kind.Description
                    'subItemContent.ReleaseDate = kind.Actors[0]
                    subItemContent.Rating = kind.Rating.Title + "            " + kind.Categories[0] + "            " + kind.Technicals[0].Definition
                    subItemContent.Stream = kind.Technicals[0].media.AV_ClearTS.fileName

                    Result = CreateObject("roArray", 10, true)
                    ResultIds = CreateObject("roArray", 10, true)
                    contentIdRecord = ""
                    cont = 0
                     for each kindTechnical in kind.Technicals
                        if (kindTechnical.media.AV_ClearTS.comment = "Youtube") then 
                            Record = kindTechnical.media.AV_ClearTS.id.Split("=")                        
                            if (Record<>invalid) 
                                contentIdRecord = Record[1]
                            else
                                contentIdRecord = "invalid" 
                            end if
                         else
                            Record = kindTechnical.media.AV_ClearTS.id.Split("=")                        
                            if (Record<>invalid) 
                                contentIdRecord = Record[Record.Count()-1]
                            else
                                contentIdRecord = "invalid" 
                            end if

                         end if
                        Result.push(kindTechnical.media.AV_ClearTS.fileName)
                        ResultIds.push(kindTechnical.media.AV_ClearTS.comment.ToStr() + "_" + contentIdRecord  + "_" + kind.id)
                        cont = cont + 1
                     end for
                    subItemContent.Streams = Result'subSubItemContent
                    subItemContent.StreamUrls = Result'subSubItemContent
                    subItemContent.StreamContentIDs = ResultIds
                    subItemContent.StreamQualities=Result
                    subItemContent.Id = kind.id
                    print "STREAMSSSSSSSSSSSSS"; kind.id
                    subItemContent.url = kind.Technicals[0].media.AV_ClearTS.fileName
                    subItemContent.streamFormat = kind.Technicals[0].media.AV_ClearTS.format
                    subItemContent.HDPosterUrl = kind.PromoImages[0]
                    subItemContent.SDPosterUrl= kind.PromoImages[0]
            end for            
            
            objContent2 = NewRequest("https://213.244.195.170/metadata/delivery/CMS4X/vod/editorials?&filter={" + Chr(34) + "technical.deviceType" + Chr(34) + ":"  + Chr(34) + "Browser" + Chr(34) + ","  + Chr(34) + "editorial.episodeNumber"  + Chr(34) + Chr(58) + "{" + Chr(34) +  "$exists" + Chr(34) + Chr(58) + "false}," + Chr(34) + "editorial.Categories" + Chr(34) + Chr(58) +  Chr(34) + "Drama"  + Chr(34) + ","  + Chr(34) + "editorial.Rating.code"  + Chr(34) + ":{"  + Chr(34) + "$lte"  + Chr(34) + ":"  + Chr(34) + ""+m.global.current_user.parental_level+""  + Chr(34) + "}}&fields=[" + Chr(34) + "editorial._id" + Chr(34) + "," + Chr(34) + "editorial.Title" + Chr(34) + "," + Chr(34) + "editorial.title" + Chr(34) + "," + Chr(34) + "editorial.Description" + Chr(34) + "," + Chr(34) + "editorial.Actors" + Chr(34) + "," + Chr(34) + "editorial.Categories" + Chr(34) + "," + Chr(34) + "editorial.Rating" + Chr(34) + "," + Chr(34) + "editorial.episodeNumber" + Chr(34) + "," + Chr(34) + "editorial.PromoImages" + Chr(34) + "," + Chr(34) + "technical.Definition" + Chr(34) + "," + Chr(34) + "technical.media" + Chr(34) + "," + Chr(34) + "product.price" + Chr(34) + "," + Chr(34) + "product.type" + Chr(34) + "," + Chr(34) + "product.nodeRefs" + Chr(34) + "," + Chr(34) + "product.startPurchase" + Chr(34) + "," + Chr(34) + "product.endPurchase" + Chr(34) + "," + Chr(34) + "product.startValidity" + Chr(34) + "," + Chr(34) + "product.endValidity" + Chr(34) + "," + Chr(34) + "editorial.seriesRef" + Chr(34) + "," + Chr(34) + "voditem.nodeRefs" + Chr(34) + "]&sort=[[" + Chr(34) + "editorial.title" + Chr(34) + ",1]]&limit=10&offset=0" ).Execute()["editorials"]
            itemContent = content.createChild("ContentNode")
            itemContent.title = "Drama"
            for each kind in objContent2
                    print kind
                    subItemContent = itemContent.createChild("ContentNode")
                    subItemContent.id = kind.id
                    subItemContent.title = kind.Title
                    subItemContent.Description = kind.Description
                    subItemContent.ReleaseDate = kind.Actors[0] '+ "            " +kind.Rating.Title '+ "            " + kind.Categories[0]
                    subItemContent.Rating =  kind.Rating.Title + "            " + kind.Categories[0] + "            " + kind.Technicals[0].Definition
                    subItemContent.Stream = kind.Technicals[0].media.AV_ClearTS.fileName
                    Result = CreateObject("roArray", 10, true)
                    ResultIds = CreateObject("roArray", 10, true)
                    contentIdRecord = ""
                    cont = 0
                     for each kindTechnical in kind.Technicals
                        if (kindTechnical.media.AV_ClearTS.comment = "Youtube") then 
                            Record = kindTechnical.media.AV_ClearTS.id.Split("=")                        
                            if (Record<>invalid) 
                                contentIdRecord = Record[1]
                            else
                                contentIdRecord = "invalid" 
                            end if
                         else
                            Record = kindTechnical.media.AV_ClearTS.id.Split("=")                        
                            if (Record<>invalid) 
                                contentIdRecord = Record[Record.Count()-1]
                            else
                                contentIdRecord = "invalid" 
                            end if

                         end if
                        Result.push(kindTechnical.media.AV_ClearTS.fileName)
                        ResultIds.push(kindTechnical.media.AV_ClearTS.comment.ToStr() + "_" + contentIdRecord  + "_" + kind.id)
                        cont = cont + 1
                     end for
                    subItemContent.Streams = Result'subSubItemContent
                    subItemContent.StreamUrls = Result'subSubItemContent
                    subItemContent.StreamContentIDs = ResultIds
                    subItemContent.StreamQualities=Result
                    subItemContent.Id = kind.id
                    print "STREAMSSSSSSSSSSSSS"; kind.id
                    subItemContent.url = kind.Technicals[0].media.AV_ClearTS.fileName
                    subItemContent.streamFormat = kind.Technicals[0].media.AV_ClearTS.format
                    subItemContent.HDPosterUrl = kind.PromoImages[0]
                    subItemContent.SDPosterUrl= kind.PromoImages[0]
            end for
                        
            m.top.content = content
            playlist.push(content)
            'return playlist
            return content
end function

function roStringSplit(Result, Value, Delimiter) as object ' Is like tokenize but doesnt dump empty values, boxed version
    Result.Clear()
    OldSpot=-1: Spot = Value.Instr(Delimiter)
    while Spot<>-1
        Result.Push(Value.Mid(OldSpot+1,Spot-OldSpot-1))         
        OldSpot=Spot
        Spot = Value.Instr(Spot+1, Delimiter)         
    end while
    Result.Push(Value.Mid(OldSpot+1))      
    return Result
end function

function SeriesContentNode() as object
            content = createObject("roSGNode", "ContentNode")
            print "ConvertToContentNode................."                    
            objContent = NewRequest("https://213.244.195.170/metadata/delivery/CMS4X/vod/series?filter={'PrivateMetadata':'isParent:true'}&filter={"  + Chr(34) + "Categories"  + Chr(34) + ":"  + Chr(34) + "Action"  + Chr(34) + ","  + Chr(34) + "editorial.Rating.code"  + Chr(34) + ":{"  + Chr(34) + "$lte"  + Chr(34) + ":"  + Chr(34) + ""+m.global.current_user.parental_level+""  + Chr(34) + "}}&fields=["  + Chr(34) + "id"  + Chr(34) + ","  + Chr(34) + "Title"  + Chr(34) + ","  + Chr(34) + "title"  + Chr(34) + ","  + Chr(34) + "Description"  + Chr(34) + ","  + Chr(34) + "Categories"  + Chr(34) + ","  + Chr(34) + "Rating"  + Chr(34) + ","  + Chr(34) + "PromoImages"  + Chr(34) + "]&sort=[["  + Chr(34) + "Title"  + Chr(34) + ",1]]&limit=10&offset=0" ).Execute()["series"]
            print "URL **************************************"; "https://213.244.195.170/metadata/delivery/CMS4X/vod/series?&filter={"  + Chr(34) + "Categories"  + Chr(34) + ":"  + Chr(34) + "Action"  + Chr(34) + "}&fields=["  + Chr(34) + "id"  + Chr(34) + ","  + Chr(34) + "Title"  + Chr(34) + ","  + Chr(34) + "title"  + Chr(34) + ","  + Chr(34) + "Description"  + Chr(34) + ","  + Chr(34) + "Categories"  + Chr(34) + ","  + Chr(34) + "Rating"  + Chr(34) + ","  + Chr(34) + "PromoImages"  + Chr(34) + "]&sort=[["  + Chr(34) + "Title"  + Chr(34) + ",1]]&limit=10&offset=0"
            playlist = CreateObject("roArray", 10, true)
            
            itemContent = content.createChild("ContentNode")
            itemContent.title = "Action"
            for each kind in objContent
                    print kind
                    subItemContent = itemContent.createChild("ContentNode")
                    subItemContent.id = kind.id
                    subItemContent.title = kind.Title
                    subItemContent.Description = kind.Description
                    'subItemContent.ReleaseDate = kind.Actors[0] + "            " +kind.Rating.Title + "            " + kind.Categories[0]
                    'subItemContent.Rating = kind.Technicals[0].Definition
                    'subItemContent.Stream = kind.Technicals[0].media.AV_ClearTS.fileName
                    subItemContent.HDPosterUrl = kind.PromoImages[0]
                    subItemContent.SDPosterUrl= kind.PromoImages[0]
            end for            
            
            'objContent2 = NewRequest("https://213.244.195.170/metadata/delivery/CMS4X/vod/editorials?&filter={" + Chr(34) + "technical.deviceType" + Chr(34) + ":"  + Chr(34) + "Browser" + Chr(34) + ","  + Chr(34) + "editorial.episodeNumber"  + Chr(34) + Chr(58) + "{" + Chr(34) +  "$exists" + Chr(34) + Chr(58) + "false}," + Chr(34) + "editorial.Categories" + Chr(34) + Chr(58) +  Chr(34) + "Drama"  + Chr(34) + "}&fields=[" + Chr(34) + "editorial._id" + Chr(34) + "," + Chr(34) + "editorial.Title" + Chr(34) + "," + Chr(34) + "editorial.title" + Chr(34) + "," + Chr(34) + "editorial.Description" + Chr(34) + "," + Chr(34) + "editorial.Actors" + Chr(34) + "," + Chr(34) + "editorial.Categories" + Chr(34) + "," + Chr(34) + "editorial.Rating" + Chr(34) + "," + Chr(34) + "editorial.episodeNumber" + Chr(34) + "," + Chr(34) + "editorial.PromoImages" + Chr(34) + "," + Chr(34) + "technical.Definition" + Chr(34) + "," + Chr(34) + "technical.media" + Chr(34) + "," + Chr(34) + "product.price" + Chr(34) + "," + Chr(34) + "product.type" + Chr(34) + "," + Chr(34) + "product.nodeRefs" + Chr(34) + "," + Chr(34) + "product.startPurchase" + Chr(34) + "," + Chr(34) + "product.endPurchase" + Chr(34) + "," + Chr(34) + "product.startValidity" + Chr(34) + "," + Chr(34) + "product.endValidity" + Chr(34) + "," + Chr(34) + "editorial.seriesRef" + Chr(34) + "," + Chr(34) + "voditem.nodeRefs" + Chr(34) + "]&sort=[[" + Chr(34) + "editorial.title" + Chr(34) + ",1]]&limit=10&offset=0" ).Execute()["editorials"]
            objContent2 = NewRequest("https://213.244.195.170/metadata/delivery/CMS4X/vod/series?&filter={"  + Chr(34) + "Categories"  + Chr(34) + ":"  + Chr(34) + "Drama"  + Chr(34) + ","  + Chr(34) + "editorial.Rating.code"  + Chr(34) + ":{"  + Chr(34) + "$lte"  + Chr(34) + ":"  + Chr(34) + ""+m.global.current_user.parental_level+""  + Chr(34) + "}}&fields=["  + Chr(34) + "id"  + Chr(34) + ","  + Chr(34) + "Title"  + Chr(34) + ","  + Chr(34) + "title"  + Chr(34) + ","  + Chr(34) + "Description"  + Chr(34) + ","  + Chr(34) + "Categories"  + Chr(34) + ","  + Chr(34) + "Rating"  + Chr(34) + ","  + Chr(34) + "PromoImages"  + Chr(34) + "]&sort=[["  + Chr(34) + "Title"  + Chr(34) + ",1]]&limit=10&offset=0" ).Execute()["series"]
'            BuildContentNode(objContent2, "Drama")
            itemContent = content.createChild("ContentNode")
            itemContent.title = "Drama"
            for each kind in objContent2
                    print kind
                    subItemContent = itemContent.createChild("ContentNode")
                    subItemContent.id = kind.id
                    subItemContent.title = kind.Title
                    subItemContent.Description = kind.Description
                    'subItemContent.ReleaseDate = kind.Actors[0] + "            " +kind.Rating.Title + "            " + kind.Categories[0]
                    'subItemContent.Rating = kind.Technicals[0].Definition
                    'subItemContent.Stream = kind.Technicals[0].media.AV_ClearTS.fileName
                    subItemContent.HDPosterUrl = kind.PromoImages[0]
                    subItemContent.SDPosterUrl= kind.PromoImages[0]
            end for
                        
            m.top.content = content
            'return content
            playlist.push(content)
            return playlist
end function

function SeriesEpContentNode() as object
            content = createObject("roSGNode", "ContentNode")
            print "ConvertToContentNode................."                    
'            objContent = NewRequest("https://213.244.195.170/metadata/delivery/CMS4X/vod/editorials?&filter={" + Chr(34) + "technical.deviceType" + Chr(34) + ":"  + Chr(34) + "Browser" + Chr(34) + ","  + Chr(34) + "editorial.seriesRef"  + Chr(34) + Chr(58) + Chr(34) +  m.top.sRef + Chr(34)  + "," + Chr(34) + "editorial.Categories" + Chr(34) + Chr(58) +  Chr(34) +  m.top.sCategory  + Chr(34) + "}&fields=[" + Chr(34) + "editorial._id" + Chr(34) + "," + Chr(34) + "editorial.Title" + Chr(34) + "," + Chr(34) + "editorial.title" + Chr(34) + "," + Chr(34) + "editorial.Description" + Chr(34) + "," + Chr(34) + "editorial.Actors" + Chr(34) + "," + Chr(34) + "editorial.Categories" + Chr(34) + "," + Chr(34) + "editorial.Rating" + Chr(34) + "," + Chr(34) + "editorial.episodeNumber" + Chr(34) + "," + Chr(34) + "editorial.PromoImages" + Chr(34) + "," + Chr(34) + "technical.Definition" + Chr(34) + "," + Chr(34) + "technical.media" + Chr(34) + "," + Chr(34) + "product.price" + Chr(34) + "," + Chr(34) + "product.type" + Chr(34) + "," + Chr(34) + "product.nodeRefs" + Chr(34) + "," + Chr(34) + "product.startPurchase" + Chr(34) + "," + Chr(34) + "product.endPurchase" + Chr(34) + "," + Chr(34) + "product.startValidity" + Chr(34) + "," + Chr(34) + "product.endValidity" + Chr(34) + "," + Chr(34) + "editorial.seriesRef" + Chr(34) + "," + Chr(34) + "voditem.nodeRefs" + Chr(34) + "]&sort=[[" + Chr(34) + "editorial.title" + Chr(34) + ",1]]&limit=10&offset=0" ).Execute()["editorials"]  ' '.Execute()["total_records"]  '
            objContent = NewRequest("https://213.244.195.170/metadata/delivery/CMS4X/vod/editorials?&filter={" + Chr(34) + "technical.deviceType" + Chr(34) + ":"  + Chr(34) + "Browser" + Chr(34) + ","  + Chr(34) + "editorial.seriesRef"  + Chr(34) + Chr(58) + Chr(34) +  m.top.sRef + Chr(34) +  ","  + Chr(34) + "editorial.Rating.code"  + Chr(34) + ":{"  + Chr(34) + "$lte"  + Chr(34) + ":"  + Chr(34) + ""+m.global.current_user.parental_level+""  + Chr(34) + "}}&fields=[" + Chr(34) + "editorial._id" + Chr(34) + "," + Chr(34) + "editorial.Title" + Chr(34) + "," + Chr(34) + "editorial.title" + Chr(34) + "," + Chr(34) + "editorial.Description" + Chr(34) + "," + Chr(34) + "editorial.Actors" + Chr(34) + "," + Chr(34) + "editorial.Categories" + Chr(34) + "," + Chr(34) + "editorial.Rating" + Chr(34) + "," + Chr(34) + "editorial.episodeNumber" + Chr(34) + "," + Chr(34) + "editorial.PromoImages" + Chr(34) + "," + Chr(34) + "technical.Definition" + Chr(34) + "," + Chr(34) + "technical.media" + Chr(34) + "," + Chr(34) + "product.price" + Chr(34) + "," + Chr(34) + "product.type" + Chr(34) + "," + Chr(34) + "product.nodeRefs" + Chr(34) + "," + Chr(34) + "product.startPurchase" + Chr(34) + "," + Chr(34) + "product.endPurchase" + Chr(34) + "," + Chr(34) + "product.startValidity" + Chr(34) + "," + Chr(34) + "product.endValidity" + Chr(34) + "," + Chr(34) + "editorial.seriesRef" + Chr(34) + "," + Chr(34) + "voditem.nodeRefs" + Chr(34) + "]&sort=[[" + Chr(34) + "editorial.title" + Chr(34) + ",1]]&limit=10&offset=0" ).Execute()["editorials"]  ' '.Execute()["total_records"]  '
            print "URL **************************************"; "https://213.244.195.170/metadata/delivery/CMS4X/vod/editorials?&filter={" + Chr(34) + "technical.deviceType" + Chr(34) + ":"  + Chr(34) + "Browser" + Chr(34) + ","  + Chr(34) + "editorial.seriesRef"  + Chr(34) + Chr(58) + Chr(34) +  m.top.sRef + Chr(34)  + "," + Chr(34) + "editorial.Categories" + Chr(34) + Chr(58) +  Chr(34) +  m.top.sCategory  + Chr(34) + "}&fields=[" + Chr(34) + "editorial._id" + Chr(34) + "," + Chr(34) + "editorial.Title" + Chr(34) + "," + Chr(34) + "editorial.title" + Chr(34) + "," + Chr(34) + "editorial.Description" + Chr(34) + "," + Chr(34) + "editorial.Actors" + Chr(34) + "," + Chr(34) + "editorial.Categories" + Chr(34) + "," + Chr(34) + "editorial.Rating" + Chr(34) + "," + Chr(34) + "editorial.episodeNumber" + Chr(34) + "," + Chr(34) + "editorial.PromoImages" + Chr(34) + "," + Chr(34) + "technical.Definition" + Chr(34) + "," + Chr(34) + "technical.media" + Chr(34) + "," + Chr(34) + "product.price" + Chr(34) + "," + Chr(34) + "product.type" + Chr(34) + "," + Chr(34) + "product.nodeRefs" + Chr(34) + "," + Chr(34) + "product.startPurchase" + Chr(34) + "," + Chr(34) + "product.endPurchase" + Chr(34) + "," + Chr(34) + "product.startValidity" + Chr(34) + "," + Chr(34) + "product.endValidity" + Chr(34) + "," + Chr(34) + "editorial.seriesRef" + Chr(34) + "," + Chr(34) + "voditem.nodeRefs" + Chr(34) + "]&sort=[[" + Chr(34) + "editorial.title" + Chr(34) + ",1]]&limit=10&offset=0"
            
            playlist = CreateObject("roArray", 10, true)
            
            itemContent = content.createChild("ContentNode")
            itemContent.title = "Episode "
            for each kind in objContent
                    print kind
                    subItemContent = itemContent.createChild("ContentNode")
                    subItemContent.id = kind.id
                    subItemContent.title = kind.Title
                    subItemContent.Description = kind.Description
                    subItemContent.ReleaseDate = kind.Actors[0] '+ "            " +kind.Rating.Title '+ "            " + kind.Categories[0]
                    subItemContent.Rating = kind.Rating.Title + "            " + kind.Categories[0] + "            " + kind.Technicals[0].Definition
                    subItemContent.Stream = kind.Technicals[0].media.AV_ClearTS.fileName

                    Result = CreateObject("roArray", 10, true)
                    ResultIds = CreateObject("roArray", 10, true)
                    contentIdRecord = ""
                    cont = 0
                     for each kindTechnical in kind.Technicals
                        if (kindTechnical.media.AV_ClearTS.comment = "Youtube") then 
                            Record = kindTechnical.media.AV_ClearTS.id.Split("=")                        
                            if (Record<>invalid) 
                                contentIdRecord = Record[1]
                            else
                                contentIdRecord = "invalid" 
                            end if
                         else
                            Record = kindTechnical.media.AV_ClearTS.id.Split("=")                        
                            if (Record<>invalid) 
                                contentIdRecord = Record[Record.Count()-1]
                            else
                                contentIdRecord = "invalid" 
                            end if

                         end if
                        Result.push(kindTechnical.media.AV_ClearTS.fileName)
                        print "kindTechnical.media.AV_ClearTS.comment.ToStr() "; kindTechnical.media.AV_ClearTS.comment.ToStr()
                        print "contentIdRecord "; contentIdRecord
                        print "kind.id "; kind.id
                        print "kind.episodeNumber.ToStr() "; kind.episodeNumber.ToStr()
                        ResultIds.push(kindTechnical.media.AV_ClearTS.comment.ToStr() + "_" + contentIdRecord  + "_" + kind.id + "_" + kind.episodeNumber.ToStr())
                        cont = cont + 1
                     end for
                    subItemContent.Streams = Result'subSubItemContent
                    subItemContent.StreamUrls = Result'subSubItemContent
                    subItemContent.StreamContentIDs = ResultIds
                    subItemContent.StreamQualities=Result
                    subItemContent.Id = kind.id
                    print "STREAMSSSSSSSSSSSSS"; kind.id
                    subItemContent.url = kind.Technicals[0].media.AV_ClearTS.fileName
                    subItemContent.streamFormat = kind.Technicals[0].media.AV_ClearTS.format
                    subItemContent.HDPosterUrl = kind.PromoImages[0]
                    subItemContent.SDPosterUrl= kind.PromoImages[0]
            end for            
           
                        
            m.top.content = content
            playlist.push(content)
            'return playlist
            print "CONTENTTTT *************" ; content
            
            return content
            
            
end function

function FavoritesContentNode() as object
    content = createObject("roSGNode", "ContentNode")
    print "ConvertToContentNode................."      
    playlist = CreateObject("roArray", 10, true)
    contentPoster = createObject("roSGNode", "ContentNode")
    itemContent = contentPoster.createChild("ContentNode")
    itemContent.title = "Favorites"   
    
    objContentFav = NewRequestFavs("http://ssolab1.nagra.com/net/useractivityvault/v1/clientdata/account/TQMG/favouriteslists/2551c3c0-e316-11e6-a12c-218dd48cc1a1?token="+m.global.Token,"GET","invalid").Execute()["favourites"]  
    print "URL **************************************"; "http://ssolab1.nagra.com/net/useractivityvault/v1/clientdata/account/TQMG/favouriteslists/2551c3c0-e316-11e6-a12c-218dd48cc1a1?token="+m.global.Token
    
    for each kindFav in objContentFav
        print "LEFT *****";Left(kindFav.contentId, 3)
        contId = Left(kindFav.contentId, 3)
        if (contId <> "CNT") then
            objContent = NewRequest("https://213.244.195.170/metadata/delivery/CMS4X/vod/editorials?&filter={" + Chr(34) + "technical.deviceType" + Chr(34) + ":"  + Chr(34) + "Browser" + Chr(34) + ","  + Chr(34) + "editorial.seriesRef"  + Chr(34) + Chr(58) + Chr(34) +  kindFav.contentId + Chr(34) +  "}&fields=[" + Chr(34) + "editorial._id" + Chr(34) + "," + Chr(34) + "editorial.Title" + Chr(34) + "," + Chr(34) + "editorial.title" + Chr(34) + "," + Chr(34) + "editorial.Description" + Chr(34) + "," + Chr(34) + "editorial.Actors" + Chr(34) + "," + Chr(34) + "editorial.Categories" + Chr(34) + "," + Chr(34) + "editorial.Rating" + Chr(34) + "," + Chr(34) + "editorial.episodeNumber" + Chr(34) + "," + Chr(34) + "editorial.PromoImages" + Chr(34) + "," + Chr(34) + "technical.Definition" + Chr(34) + "," + Chr(34) + "technical.media" + Chr(34) + "," + Chr(34) + "product.price" + Chr(34) + "," + Chr(34) + "product.type" + Chr(34) + "," + Chr(34) + "product.nodeRefs" + Chr(34) + "," + Chr(34) + "product.startPurchase" + Chr(34) + "," + Chr(34) + "product.endPurchase" + Chr(34) + "," + Chr(34) + "product.startValidity" + Chr(34) + "," + Chr(34) + "product.endValidity" + Chr(34) + "," + Chr(34) + "editorial.seriesRef" + Chr(34) + "," + Chr(34) + "voditem.nodeRefs" + Chr(34) + "]&sort=[[" + Chr(34) + "editorial.title" + Chr(34) + ",1]]&limit=10&offset=0" ).Execute()["editorials"]  ' '.Execute()["total_records"]  '
            print "URL **************************************"; "https://213.244.195.170/metadata/delivery/CMS4X/vod/editorials?&filter={" + Chr(34) + "technical.deviceType" + Chr(34) + ":"  + Chr(34) + "Browser" + Chr(34) + ","  + Chr(34) + "editorial.seriesRef"  + Chr(34) + Chr(58) + Chr(34) +  kindFav.contentId + Chr(34) +  "}&fields=[" + Chr(34) + "editorial._id" + Chr(34) + "," + Chr(34) + "editorial.Title" + Chr(34) + "," + Chr(34) + "editorial.title" + Chr(34) + "," + Chr(34) + "editorial.Description" + Chr(34) + "," + Chr(34) + "editorial.Actors" + Chr(34) + "," + Chr(34) + "editorial.Categories" + Chr(34) + "," + Chr(34) + "editorial.Rating" + Chr(34) + "," + Chr(34) + "editorial.episodeNumber" + Chr(34) + "," + Chr(34) + "editorial.PromoImages" + Chr(34) + "," + Chr(34) + "technical.Definition" + Chr(34) + "," + Chr(34) + "technical.media" + Chr(34) + "," + Chr(34) + "product.price" + Chr(34) + "," + Chr(34) + "product.type" + Chr(34) + "," + Chr(34) + "product.nodeRefs" + Chr(34) + "," + Chr(34) + "product.startPurchase" + Chr(34) + "," + Chr(34) + "product.endPurchase" + Chr(34) + "," + Chr(34) + "product.startValidity" + Chr(34) + "," + Chr(34) + "product.endValidity" + Chr(34) + "," + Chr(34) + "editorial.seriesRef" + Chr(34) + "," + Chr(34) + "voditem.nodeRefs" + Chr(34) + "]&sort=[[" + Chr(34) + "editorial.title" + Chr(34) + ",1]]&limit=10&offset=0"
        else
            objContent = NewRequest("https://213.244.195.170/metadata/delivery/CMS4X/vod/editorials?&filter={" + Chr(34) + "technical.deviceType" + Chr(34) + ":"  + Chr(34) + "Browser" + Chr(34) + ","  + Chr(34) + "editorial.id"  + Chr(34) + Chr(58) + Chr(34) +  kindFav.contentId + Chr(34) +  "}&fields=[" + Chr(34) + "editorial._id" + Chr(34) + "," + Chr(34) + "editorial.Title" + Chr(34) + "," + Chr(34) + "editorial.title" + Chr(34) + "," + Chr(34) + "editorial.Description" + Chr(34) + "," + Chr(34) + "editorial.Actors" + Chr(34) + "," + Chr(34) + "editorial.Categories" + Chr(34) + "," + Chr(34) + "editorial.Rating" + Chr(34) + "," + Chr(34) + "editorial.episodeNumber" + Chr(34) + "," + Chr(34) + "editorial.PromoImages" + Chr(34) + "," + Chr(34) + "technical.Definition" + Chr(34) + "," + Chr(34) + "technical.media" + Chr(34) + "," + Chr(34) + "product.price" + Chr(34) + "," + Chr(34) + "product.type" + Chr(34) + "," + Chr(34) + "product.nodeRefs" + Chr(34) + "," + Chr(34) + "product.startPurchase" + Chr(34) + "," + Chr(34) + "product.endPurchase" + Chr(34) + "," + Chr(34) + "product.startValidity" + Chr(34) + "," + Chr(34) + "product.endValidity" + Chr(34) + "," + Chr(34) + "editorial.seriesRef" + Chr(34) + "," + Chr(34) + "voditem.nodeRefs" + Chr(34) + "]&sort=[[" + Chr(34) + "editorial.title" + Chr(34) + ",1]]&limit=10&offset=0" ).Execute()["editorials"]  ' '.Execute()["total_records"]  '
            print "URL **************************************"; "https://213.244.195.170/metadata/delivery/CMS4X/vod/editorials?&filter={" + Chr(34) + "technical.deviceType" + Chr(34) + ":"  + Chr(34) + "Browser" + Chr(34) + ","  + Chr(34) + "editorial.id"  + Chr(34) + Chr(58) + Chr(34) +  kindFav.contentId + Chr(34) +  "}&fields=[" + Chr(34) + "editorial._id" + Chr(34) + "," + Chr(34) + "editorial.Title" + Chr(34) + "," + Chr(34) + "editorial.title" + Chr(34) + "," + Chr(34) + "editorial.Description" + Chr(34) + "," + Chr(34) + "editorial.Actors" + Chr(34) + "," + Chr(34) + "editorial.Categories" + Chr(34) + "," + Chr(34) + "editorial.Rating" + Chr(34) + "," + Chr(34) + "editorial.episodeNumber" + Chr(34) + "," + Chr(34) + "editorial.PromoImages" + Chr(34) + "," + Chr(34) + "technical.Definition" + Chr(34) + "," + Chr(34) + "technical.media" + Chr(34) + "," + Chr(34) + "product.price" + Chr(34) + "," + Chr(34) + "product.type" + Chr(34) + "," + Chr(34) + "product.nodeRefs" + Chr(34) + "," + Chr(34) + "product.startPurchase" + Chr(34) + "," + Chr(34) + "product.endPurchase" + Chr(34) + "," + Chr(34) + "product.startValidity" + Chr(34) + "," + Chr(34) + "product.endValidity" + Chr(34) + "," + Chr(34) + "editorial.seriesRef" + Chr(34) + "," + Chr(34) + "voditem.nodeRefs" + Chr(34) + "]&sort=[[" + Chr(34) + "editorial.title" + Chr(34) + ",1]]&limit=10&offset=0"
        end if
        print "COUNT ************ ";objContent.Count()
        
        for each kind in objContent
                print "KIND ******************"; kind
                itemContentPoster = contentPoster.createChild("ContentNode")
                itemContentPoster.Id = kind.Id
                itemContentPoster.HDGRIDPOSTERURL = kind.PromoImages[0]
                itemContentPoster.SDGRIDPOSTERURL = kind.PromoImages[0]
                itemContentPoster.shortdescriptionline1 = kind.Title
                itemContentPoster.shortdescriptionline2 = kind.Description
                
                itemContentPoster.title = kind.Title

                itemContentPoster.title = kind.Title
                itemContentPoster.Description = kind.Description
                itemContentPoster.ReleaseDate = kind.Actors[0] '+ "            " +kind.Rating.Title '+ "            " + kind.Categories[0]
                itemContentPoster.Rating = kind.Rating.Title + "            " + kind.Categories[0] + "            " + kind.Technicals[0].Definition
                itemContentPoster.Stream = kind.Technicals[0].media.AV_ClearTS.fileName

                Result = CreateObject("roArray", 10, true)
                ResultIds = CreateObject("roArray", 10, true)
                contentIdRecord = ""
                cont = 0
                 for each kindTechnical in kind.Technicals
                    if (kindTechnical.media.AV_ClearTS.comment = "Youtube") then 
                        Record = kindTechnical.media.AV_ClearTS.id.Split("=")                        
                        if (Record<>invalid) 
                            contentIdRecord = Record[1]
                        else
                            contentIdRecord = "invalid" 
                        end if
                     else
                        Record = kindTechnical.media.AV_ClearTS.id.Split("=")                        
                        if (Record<>invalid) 
                            contentIdRecord = Record[Record.Count()-1]
                        else
                            contentIdRecord = "invalid" 
                        end if

                     end if
                    Result.push(kindTechnical.media.AV_ClearTS.fileName)
                    ResultIds.push(kindTechnical.media.AV_ClearTS.comment.ToStr() + "_" + contentIdRecord  + "_" + kind.id)
                    cont = cont + 1
                 end for
                itemContentPoster.Streams = Result'subSubItemContent
                itemContentPoster.StreamUrls = Result'subSubItemContent
                itemContentPoster.StreamContentIDs = ResultIds
                itemContentPoster.StreamQualities=Result
                itemContentPoster.Id = kind.id
                print "STREAMSSSSSSSSSSSSS"; kind.id
                itemContentPoster.url = kind.Technicals[0].media.AV_ClearTS.fileName
                itemContentPoster.streamFormat = kind.Technicals[0].media.AV_ClearTS.format
                itemContentPoster.HDPosterUrl = kind.PromoImages[0]
                itemContentPoster.SDPosterUrl= kind.PromoImages[0]
                                       
               print "itemContentPoster *********";itemContentPoster 
                
        end for            

    end for
                                 
    m.top.content = content
    m.top.contentPoster = contentPoster
    playlist.push(content)
    return content
end function

function HistorialContentNode() as object
    content = createObject("roSGNode", "ContentNode")
    print "ConvertToContentNode................."      
    playlist = CreateObject("roArray", 10, true)
    contentPoster = createObject("roSGNode", "ContentNode")
    itemContent = contentPoster.createChild("ContentNode")
    itemContent.title = "Favorites"   
    
    objContentFav = NewRequestFavs("http://ssolab1.nagra.com/net/useractivityvault/v1/clientdata/account/TQMG/history?limit=10&token="+m.global.Token,"GET","invalid").Execute()["histories"]
    print "URL **************************************"; "http://ssolab1.nagra.com/net/useractivityvault/v1/clientdata/account/TQMG/history?token="+m.global.Token
    
    for each kindFav in objContentFav
        print "LEFT *****";Left(kindFav.contentId, 3)
        contId = Left(kindFav.contentId, 3)
        if (contId <> "CNT") then
            objContent = NewRequest("https://213.244.195.170/metadata/delivery/CMS4X/vod/editorials?&filter={" + Chr(34) + "technical.deviceType" + Chr(34) + ":"  + Chr(34) + "Browser" + Chr(34) + ","  + Chr(34) + "editorial.seriesRef"  + Chr(34) + Chr(58) + Chr(34) +  kindFav.contentId + Chr(34) +  "}&fields=[" + Chr(34) + "editorial._id" + Chr(34) + "," + Chr(34) + "editorial.Title" + Chr(34) + "," + Chr(34) + "editorial.title" + Chr(34) + "," + Chr(34) + "editorial.Description" + Chr(34) + "," + Chr(34) + "editorial.Actors" + Chr(34) + "," + Chr(34) + "editorial.Categories" + Chr(34) + "," + Chr(34) + "editorial.Rating" + Chr(34) + "," + Chr(34) + "editorial.episodeNumber" + Chr(34) + "," + Chr(34) + "editorial.PromoImages" + Chr(34) + "," + Chr(34) + "technical.Definition" + Chr(34) + "," + Chr(34) + "technical.media" + Chr(34) + "," + Chr(34) + "product.price" + Chr(34) + "," + Chr(34) + "product.type" + Chr(34) + "," + Chr(34) + "product.nodeRefs" + Chr(34) + "," + Chr(34) + "product.startPurchase" + Chr(34) + "," + Chr(34) + "product.endPurchase" + Chr(34) + "," + Chr(34) + "product.startValidity" + Chr(34) + "," + Chr(34) + "product.endValidity" + Chr(34) + "," + Chr(34) + "editorial.seriesRef" + Chr(34) + "," + Chr(34) + "voditem.nodeRefs" + Chr(34) + "]&sort=[[" + Chr(34) + "editorial.title" + Chr(34) + ",1]]&limit=10&offset=0" ).Execute()["editorials"]  ' '.Execute()["total_records"]  '
            print "URL **************************************"; "https://213.244.195.170/metadata/delivery/CMS4X/vod/editorials?&filter={" + Chr(34) + "technical.deviceType" + Chr(34) + ":"  + Chr(34) + "Browser" + Chr(34) + ","  + Chr(34) + "editorial.seriesRef"  + Chr(34) + Chr(58) + Chr(34) +  kindFav.contentId + Chr(34) +  "}&fields=[" + Chr(34) + "editorial._id" + Chr(34) + "," + Chr(34) + "editorial.Title" + Chr(34) + "," + Chr(34) + "editorial.title" + Chr(34) + "," + Chr(34) + "editorial.Description" + Chr(34) + "," + Chr(34) + "editorial.Actors" + Chr(34) + "," + Chr(34) + "editorial.Categories" + Chr(34) + "," + Chr(34) + "editorial.Rating" + Chr(34) + "," + Chr(34) + "editorial.episodeNumber" + Chr(34) + "," + Chr(34) + "editorial.PromoImages" + Chr(34) + "," + Chr(34) + "technical.Definition" + Chr(34) + "," + Chr(34) + "technical.media" + Chr(34) + "," + Chr(34) + "product.price" + Chr(34) + "," + Chr(34) + "product.type" + Chr(34) + "," + Chr(34) + "product.nodeRefs" + Chr(34) + "," + Chr(34) + "product.startPurchase" + Chr(34) + "," + Chr(34) + "product.endPurchase" + Chr(34) + "," + Chr(34) + "product.startValidity" + Chr(34) + "," + Chr(34) + "product.endValidity" + Chr(34) + "," + Chr(34) + "editorial.seriesRef" + Chr(34) + "," + Chr(34) + "voditem.nodeRefs" + Chr(34) + "]&sort=[[" + Chr(34) + "editorial.title" + Chr(34) + ",1]]&limit=10&offset=0"
        else
            objContent = NewRequest("https://213.244.195.170/metadata/delivery/CMS4X/vod/editorials?&filter={" + Chr(34) + "technical.deviceType" + Chr(34) + ":"  + Chr(34) + "Browser" + Chr(34) + ","  + Chr(34) + "editorial.id"  + Chr(34) + Chr(58) + Chr(34) +  kindFav.contentId + Chr(34) +  "}&fields=[" + Chr(34) + "editorial._id" + Chr(34) + "," + Chr(34) + "editorial.Title" + Chr(34) + "," + Chr(34) + "editorial.title" + Chr(34) + "," + Chr(34) + "editorial.Description" + Chr(34) + "," + Chr(34) + "editorial.Actors" + Chr(34) + "," + Chr(34) + "editorial.Categories" + Chr(34) + "," + Chr(34) + "editorial.Rating" + Chr(34) + "," + Chr(34) + "editorial.episodeNumber" + Chr(34) + "," + Chr(34) + "editorial.PromoImages" + Chr(34) + "," + Chr(34) + "technical.Definition" + Chr(34) + "," + Chr(34) + "technical.media" + Chr(34) + "," + Chr(34) + "product.price" + Chr(34) + "," + Chr(34) + "product.type" + Chr(34) + "," + Chr(34) + "product.nodeRefs" + Chr(34) + "," + Chr(34) + "product.startPurchase" + Chr(34) + "," + Chr(34) + "product.endPurchase" + Chr(34) + "," + Chr(34) + "product.startValidity" + Chr(34) + "," + Chr(34) + "product.endValidity" + Chr(34) + "," + Chr(34) + "editorial.seriesRef" + Chr(34) + "," + Chr(34) + "voditem.nodeRefs" + Chr(34) + "]&sort=[[" + Chr(34) + "editorial.title" + Chr(34) + ",1]]&limit=10&offset=0" ).Execute()["editorials"]  ' '.Execute()["total_records"]  '
            print "URL **************************************"; "https://213.244.195.170/metadata/delivery/CMS4X/vod/editorials?&filter={" + Chr(34) + "technical.deviceType" + Chr(34) + ":"  + Chr(34) + "Browser" + Chr(34) + ","  + Chr(34) + "editorial.id"  + Chr(34) + Chr(58) + Chr(34) +  kindFav.contentId + Chr(34) +  "}&fields=[" + Chr(34) + "editorial._id" + Chr(34) + "," + Chr(34) + "editorial.Title" + Chr(34) + "," + Chr(34) + "editorial.title" + Chr(34) + "," + Chr(34) + "editorial.Description" + Chr(34) + "," + Chr(34) + "editorial.Actors" + Chr(34) + "," + Chr(34) + "editorial.Categories" + Chr(34) + "," + Chr(34) + "editorial.Rating" + Chr(34) + "," + Chr(34) + "editorial.episodeNumber" + Chr(34) + "," + Chr(34) + "editorial.PromoImages" + Chr(34) + "," + Chr(34) + "technical.Definition" + Chr(34) + "," + Chr(34) + "technical.media" + Chr(34) + "," + Chr(34) + "product.price" + Chr(34) + "," + Chr(34) + "product.type" + Chr(34) + "," + Chr(34) + "product.nodeRefs" + Chr(34) + "," + Chr(34) + "product.startPurchase" + Chr(34) + "," + Chr(34) + "product.endPurchase" + Chr(34) + "," + Chr(34) + "product.startValidity" + Chr(34) + "," + Chr(34) + "product.endValidity" + Chr(34) + "," + Chr(34) + "editorial.seriesRef" + Chr(34) + "," + Chr(34) + "voditem.nodeRefs" + Chr(34) + "]&sort=[[" + Chr(34) + "editorial.title" + Chr(34) + ",1]]&limit=10&offset=0"
        end if
        print "COUNT ************ ";objContent.Count()
        
        for each kind in objContent
                print "KIND ******************"; kind
                itemContentPoster = contentPoster.createChild("ContentNode")
                itemContentPoster.Id = kind.Id
                itemContentPoster.HDGRIDPOSTERURL = kind.PromoImages[0]
                itemContentPoster.SDGRIDPOSTERURL = kind.PromoImages[0]
                itemContentPoster.shortdescriptionline1 = kind.Title
                itemContentPoster.shortdescriptionline2 = kind.Description
                
                itemContentPoster.title = kind.Title

                itemContentPoster.title = kind.Title
                itemContentPoster.Description = kind.Description
                if (kind.Actors<>invalid) then
                    itemContentPoster.ReleaseDate = kind.Actors[0] '+ "            " +kind.Rating.Title '+ "            " + kind.Categories[0]
                else
                    itemContentPoster.ReleaseDate = ""
                end if
                itemContentPoster.Rating = kind.Rating.Title + "            " + kind.Categories[0] + "            " + kind.Technicals[0].Definition
                itemContentPoster.Stream = kind.Technicals[0].media.AV_ClearTS.fileName

                Result = CreateObject("roArray", 10, true)
                ResultIds = CreateObject("roArray", 10, true)
                contentIdRecord = ""
                cont = 0
                 for each kindTechnical in kind.Technicals
                    if (kindTechnical.media.AV_ClearTS.comment = "Youtube") then 
                        Record = kindTechnical.media.AV_ClearTS.id.Split("=")                        
                        if (Record<>invalid) 
                            contentIdRecord = Record[1]
                        else
                            contentIdRecord = "invalid" 
                        end if
                     else
                        Record = kindTechnical.media.AV_ClearTS.id.Split("=")                        
                        if (Record<>invalid) 
                            contentIdRecord = Record[Record.Count()-1]
                        else
                            contentIdRecord = "invalid" 
                        end if

                     end if
                    Result.push(kindTechnical.media.AV_ClearTS.fileName)
                    ResultIds.push(kindTechnical.media.AV_ClearTS.comment.ToStr() + "_" + contentIdRecord  + "_" + kind.id)
                    cont = cont + 1
                 end for
                itemContentPoster.Streams = Result'subSubItemContent
                itemContentPoster.StreamUrls = Result'subSubItemContent
                itemContentPoster.StreamContentIDs = ResultIds
                itemContentPoster.StreamQualities=Result
                itemContentPoster.Id = kind.id
                print "STREAMSSSSSSSSSSSSS"; kind.id
                itemContentPoster.url = kind.Technicals[0].media.AV_ClearTS.fileName
                itemContentPoster.streamFormat = kind.Technicals[0].media.AV_ClearTS.format
                itemContentPoster.HDPosterUrl = kind.PromoImages[0]
                itemContentPoster.SDPosterUrl= kind.PromoImages[0]
                                       
               print "itemContentPoster *********";itemContentPoster 
                
        end for            

    end for
                                 
    m.top.content = content
    m.top.contentPoster = contentPoster
    playlist.push(content)
    return content
end function
function ReminderContentNode() as object
    content = createObject("roSGNode", "ContentNode")
    print "ConvertToContentNode................."      
    playlist = CreateObject("roArray", 10, true)
    contentPoster = createObject("roSGNode", "ContentNode")
    itemContent = contentPoster.createChild("ContentNode")
    itemContent.title = "Reminder"   
    
    objContentFav = NewRequestFavs("http://ssolab1.nagra.com/net/useractivityvault/v1/clientdata/account/TQMG/reminders/?token="+m.global.Token,m.top.requestOption,m.top.Body).Execute()
    print "total de reminder ";objContentFav.totalRecords
    for each kindFav in objContentFav.reminders
        print "LEFT *****";Left(kindFav.contentId, 3)
        contId = Left(kindFav.contentId, 3)                    
            objContent = NewRequest("https://213.244.195.170/metadata/delivery/CMS4X/btv/programmes?&fields=[" + Chr(34) + "Description" + Chr(34) + "," + Chr(34) + "PromoImages" + Chr(34) + "," + Chr(34) + "Rating" + Chr(34) + "," + Chr(34) + "Title" + Chr(34) + "," + Chr(34) + "id" + Chr(34) + "," + Chr(34) + "serviceRef" + Chr(34) + "," + Chr(34) + "period.start" + Chr(34) + "]&filter={" + Chr(34) + "id" + Chr(34) + ":" + Chr(34) + kindFav.contentId + Chr(34) + "}&sort=[[" + Chr(34) + "period.start" + Chr(34) + ",1]]&limit=10&offset=0").Execute()["programmes"]
                      print "COUNT ************ ";objContent.Count()
                      print "https://213.244.195.170/metadata/delivery/CMS4X/btv/programmes?&fields=[" + Chr(34) + "Description" + Chr(34) + "," + Chr(34) + "PromoImages" + Chr(34) + "," + Chr(34) + "Rating" + Chr(34) + "," + Chr(34) + "Title" + Chr(34) + "," + Chr(34) + "id" + Chr(34) + "," + Chr(34) + "serviceRef" + Chr(34) + "," + Chr(34) + "period.start" + Chr(34) + "]&filter={" + Chr(34) + "id" + Chr(34) + ":" + Chr(34) + kindFav.contentId + Chr(34) + "}&sort=[[" + Chr(34) + "period.start" + Chr(34) + ",1]]&limit=10&offset=0"  
        for each kind in objContent
                print "KIND ******************"; kind        
                itemContentPoster = contentPoster.createChild("ContentNode")
                itemContentPoster.Id = kind.id
                itemContentPoster.HDGRIDPOSTERURL = kind.PromoImages[0]
                itemContentPoster.SDGRIDPOSTERURL = kind.PromoImages[0]
                itemContentPoster.shortdescriptionline1 = kind.Title
                itemContentPoster.shortdescriptionline2 = kind.Description
                
                itemContentPoster.title = kind.Title

                itemContentPoster.title = kind.Title
                itemContentPoster.Description = kind.Description
                
                strPeriodStart = kind.period.start
                dtps = CreateObject ("roDateTime")
                dtps.fromSeconds(strPeriodStart)
                print "dts *****";dtps.ToISOString()
                itemContentPoster.ReleaseDate =dtps.ToISOString() 
                itemContentPoster.StreamContentIDs = kindFav.id
                itemContentPoster.Rating = kind.Rating.Title
                itemContentPoster.Stream = kindFav.metadata.channel
                itemContentPoster.url = kindFav.metadata.channel
                itemContentPoster.streamFormat = "hls"
                itemContentPoster.HDPosterUrl = kind.PromoImages[0]
                itemContentPoster.SDPosterUrl= kind.PromoImages[0]
                                       
               print "itemContentPoster *********";itemContentPoster 
                
        end for            

    end for
                                 
    m.top.content = content
    m.top.contentPoster = contentPoster
    playlist.push(content)
    return content
end function
function GuideContentNode() as object
    content = createObject("roSGNode", "ContentNode")
    print "URL **************************************"; "https://213.244.195.170/metadata/delivery/CMS4X/btv/services?&filter={" + Chr(34) + "deviceType" + Chr(34) + ":"  + Chr(34) + "Browser"  + Chr(34) + "}&fields=[" + Chr(34) + "editorial.PromoImages" + Chr(34) + "," + Chr(34) + "editorial.tvChannel" + Chr(34) + "," + Chr(34) + "editorial.PromoImages" + Chr(34) + "," + Chr(34) + "technical.Title" + Chr(34) + "," + Chr(34) + "technical.NetworkLocation" + Chr(34) + "]&sort=[[" + Chr(34) + "editorial.Title" + Chr(34) + ",1]]"
    objContentServices = NewRequest("https://213.244.195.170/metadata/delivery/CMS4X/btv/services?&filter={" + Chr(34) + "deviceType" + Chr(34) + ":"  + Chr(34) + "Browser"  + Chr(34) + "}&fields=[" + Chr(34) + "editorial.PromoImages" + Chr(34) + "," + Chr(34) + "editorial.tvChannel" + Chr(34) + "," + Chr(34) + "editorial.PromoImages" + Chr(34) + "," + Chr(34) + "technical.Title" + Chr(34) + "," + Chr(34) + "technical.NetworkLocation" + Chr(34) + "]&sort=[[" + Chr(34) + "editorial.Title" + Chr(34) + ",1]]" ).Execute()["services"]  ' '.Execute()["total_records"]  '
    print "URL **************************************"; "https://213.244.195.170/metadata/delivery/CMS4X/btv/services?&filter={" + Chr(34) + "deviceType" + Chr(34) + ":"  + Chr(34) + "Browser"  + Chr(34) + "}&fields=[" + Chr(34) + "editorial.PromoImages" + Chr(34) + "," + Chr(34) + "editorial.tvChannel" + Chr(34) + "," + Chr(34) + "editorial.PromoImages" + Chr(34) + "," + Chr(34) + "technical.Title" + Chr(34) + "," + Chr(34) + "technical.NetworkLocation" + Chr(34) + "]&sort=[[" + Chr(34) + "editorial.Title" + Chr(34) + ",1]]"
    
    playlist = CreateObject("roArray", 10, true)
    for each kindServices in objContentServices
            itemContent = content.createChild("ContentNode")
            itemContent.id = kindServices.editorial.id
            itemContent.title = kindServices.technical.title
            
            dt = CreateObject ("roDateTime")
        print "Date: ";dt.asSeconds().ToStr()
        ms = dt.AsSeconds ().ToStr ()
        print "first phase :";ms
        iMs = ms.ToInt()
        print "iMs *****";iMs.ToStr()
        print "VARS"; kindServices.editorial.id.ToStr(); " - "
            print "VARS2"; kindServices.editorial.id.ToStr(); " - "
            'objContent = NewRequest("https://213.244.195.170/metadata/delivery/CMS4X/vod/editorials?&filter={" + Chr(34) + "technical.deviceType" + Chr(34) + ":"  + Chr(34) + "Browser" + Chr(34) + ","  + Chr(34) + "editorial.episodeNumber"  + Chr(34) + Chr(58) + "{" + Chr(34) +  "$exists" + Chr(34) + Chr(58) + "false}," + Chr(34) + "editorial.Categories" + Chr(34) + Chr(58) +  Chr(34) + "Action"  + Chr(34) + "}&fields=[" + Chr(34) + "editorial._id" + Chr(34) + "," + Chr(34) + "editorial.Title" + Chr(34) + "," + Chr(34) + "editorial.title" + Chr(34) + "," + Chr(34) + "editorial.Description" + Chr(34) + "," + Chr(34) + "editorial.Actors" + Chr(34) + "," + Chr(34) + "editorial.Categories" + Chr(34) + "," + Chr(34) + "editorial.Rating" + Chr(34) + "," + Chr(34) + "editorial.episodeNumber" + Chr(34) + "," + Chr(34) + "editorial.PromoImages" + Chr(34) + "," + Chr(34) + "technical.Definition" + Chr(34) + "," + Chr(34) + "technical.media" + Chr(34) + "," + Chr(34) + "product.price" + Chr(34) + "," + Chr(34) + "product.type" + Chr(34) + "," + Chr(34) + "product.nodeRefs" + Chr(34) + "," + Chr(34) + "product.startPurchase" + Chr(34) + "," + Chr(34) + "product.endPurchase" + Chr(34) + "," + Chr(34) + "product.startValidity" + Chr(34) + "," + Chr(34) + "product.endValidity" + Chr(34) + "," + Chr(34) + "editorial.seriesRef" + Chr(34) + "," + Chr(34) + "voditem.nodeRefs" + Chr(34) + "]&sort=[[" + Chr(34) + "editorial.title" + Chr(34) + ",1]]&limit=10&offset=0" ).Execute()["editorials"]  ' '.Execute()["total_records"]  '
            print "URL **************************************"; "https://213.244.195.170/metadata/delivery/CMS4X/btv/programmes?&filter={" + Chr(34) + "serviceRef" + Chr(34) + ":"  + Chr(34) +  kindServices.editorial.id.ToStr() + Chr(34) + ","  + Chr(34) + "period.start"  + Chr(34) +  ":{" + Chr(34) +  "$gt"  + Chr(34) +  ":" +  iMs.ToStr()  + "}}&fields=[" + Chr(34) + "id" + Chr(34) + "," + Chr(34) + "Title" + Chr(34) + "," + Chr(34) + "PromoImages" + Chr(34) + "," + Chr(34) + "Description" + Chr(34) + "," + Chr(34) + "Sinopsis" + Chr(34) + "," + Chr(34) + "Year" + Chr(34) + "," + Chr(34) + "serviceRef" + Chr(34) + "," + Chr(34) + "period.start" + Chr(34) + "," + Chr(34) + "period.end" + Chr(34) + "," + Chr(34) + "Rating.Title" + Chr(34)  + "]&sort=[[" + Chr(34) + "period.start"  + Chr(34) + ",1]] &limit=10&offset=0"
                                        objContent = NewRequest("https://213.244.195.170/metadata/delivery/CMS4X/btv/programmes?&filter={" + Chr(34) + "serviceRef" + Chr(34) + ":"  + Chr(34) +  kindServices.editorial.id.ToStr() + Chr(34) + ","  + Chr(34) + "period.start"  + Chr(34) +  ":{" + Chr(34) +  "$gt"  + Chr(34) +  ":" +  iMs.ToStr()  + "}}&fields=[" + Chr(34) + "id" + Chr(34) + "," + Chr(34) + "Title" + Chr(34) + "," + Chr(34) + "PromoImages" + Chr(34) + "," + Chr(34) + "Description" + Chr(34) + "," + Chr(34) + "Sinopsis" + Chr(34) + "," + Chr(34) + "Year" + Chr(34) + "," + Chr(34) + "serviceRef" + Chr(34) + "," + Chr(34) + "period.start" + Chr(34) + "," + Chr(34) + "period.end" + Chr(34) + "," + Chr(34) + "Rating.Title" + Chr(34)  + "]&sort=[[" + Chr(34) + "period.start"  + Chr(34) + ",1]] &limit=10&offset=0" ).Execute()["programmes"]  ' '.Execute()["total_records"]  '
            'print "URL **************************************"; "https://213.244.195.170/metadata/delivery/CMS4X/btv/programmes?&filter={" + Chr(34) + "serviceRef" + Chr(34) + ":"  + Chr(34) +  kindServices.editorial.id + Chr(34) + ","  + Chr(34) + "period.start"  + Chr(34) + Chr(58) + "{" + Chr(34) +  "$gt"  + "}" +  Chr(58) +  timer.totalmilliseconds()  + "}}&fields=[ " + Chr(34) +id + Chr(34) + "," + Chr(34) +Title + Chr(34) + Chr(34) + "," + Chr(34) +PromoImages + Chr(34) + "," + Chr(34) +Description + Chr(34) + "," + Chr(34) +Sinopsis + Chr(34) + "," + Chr(34) +Year + Chr(34) + "," + Chr(34) +period.start + Chr(34) + "," + Chr(34) +period.end + Chr(34) + "," + Chr(34) +Rating.Title + Chr(34) + "," + Chr(34) + "]&sort=[[" + Chr(34) + "period.start"  + Chr(34) + ",1]] &limit=10&offset=0"
            contentVideo = createObject("roSGNode", "ContentNode")            
            for each kind in objContent
                    print kind
                    subItemContent = itemContent.createChild("ContentNode")
                    itemContentVideo = contentVideo.createChild("ContentNode")
                    subItemContent.id = kind.id
                    subItemContent.title = kind.Title
                    subItemContent.HDPosterUrl = kind.PromoImages[0]
                    subItemContent.Description = kind.Description
                    Result = CreateObject("roArray", 10, true)

                     Result.push({url: kindServices.technical.NetworkLocation, contentid: kindServices.technical.id})
                     itemContentVideo.Streams = Result'subSubItemContent
                     itemContentVideo.id = kind.id
                     strPeriodStart = kind.period.start
                     dtps = CreateObject ("roDateTime")
                     dtps.fromSeconds(strPeriodStart)
                     print "dts *****";dtps.ToISOString()
                     subItemContent.ReleaseDate =dtps.ToISOString() 
                     'subItemContent.StreamUrls = Result'subSubItemContent
                     'itemContentVidep.StreamContentIDs = ResultIds
'                            'subItemContent.StreamQualities=Result
'                            'subItemContent.Id = kind.id
'                            print "STREAMSSSSSSSSSSSSS"; kind.id
                    subItemContent.url = kindServices.technical.NetworkLocation
                    subItemContent.streamFormat = "hls"
'                            subItemContent.HDPosterUrl = kind.PromoImages[0]
'                            subItemContent.SDPosterUrl= kind.PromoImages[0]
            end for
    end for                        
    m.top.content = content
    m.top.contentPoster = contentVideo
    playlist.push(content)
    'return playlist
    return content
end function

sub BuildContentNode(objContentTemp as Object, strTitle as string)
           itemContent = content.createChild("ContentNode")
           itemContent.title = strTitle
           for each kind in objContentTemp
                        print kind
                    subItemContent = itemContent.createChild("ContentNode")
                    subItemContent.title = kind.Title
                    subItemContent.Description = kind.Description
                    subItemContent.ReleaseDate = kind.Actors[0] + "            " +kind.Rating.Title + "            " + kind.Categories[0]
                    subItemContent.Rating = kind.Technicals[0].Definition
                    subItemContent.Stream = kind.Technicals[0].media.AV_ClearTS.fileName
                    subItemContent.HDPosterUrl = kind.PromoImages[0]
                    subItemContent.SDPosterUrl= kind.PromoImages[0] 

           end for
end sub

REM ******************************************************
REM Customize your HTTP requests here: add headers, setup
REM TLS, set a URL prefix, etc.
REM ******************************************************
Function SetUpUrlTransferObject(obj As Object)
    ' di = CreateObject("roDeviceInfo")
    ' obj.AddHeader("User-Agent", "ShowyouRoku/1.0 (" + di.GetModel() + "; " + di.GetVersion() + ") Roku")

    ' if obj.GetUrl().Left(4) <> "http"
    '     obj.SetUrl("http://showyou.com/api/" + obj.GetUrl())
    ' endif
End Function

REM ******************************************************
REM Create a new HTTP request. Pass a URL string or an
REM already-existing roUrlTransfer object.
REM ******************************************************
Function NewRequest(url As Object) as Object
    obj = CreateObject("roAssociativeArray")

    if type(url) = "roUrlTransfer" then
        print("Entra a RoURLTRANSFER")
        obj.Wrapped = url
    else
        print("Entra a SINO RoURLTRANSFER")
        ut = CreateObject("roUrlTransfer")
        ut.SetPort(CreateObject("roMessagePort"))
        ut.SetUrl(url.EncodeUri())
        ut.EnableEncodings(true)
    ut.AddHeader("Authorization", "Basic <BASE 64 ENCODED SEGMENT WRITE KEY>")
    ut.AddHeader("Accept", "application/json")
    ut.AddHeader("Content-Type", "application/json")
    ut.EnablePeerVerification(false)
    ut.EnableHostVerification(false)
    ut.RetainBodyOnError(true)
    ut.SetCertificatesFile("common:/certs/ca-bundle.crt")
    ut.InitClientCertificates()
        SetUpUrlTransferObject(ut)
    
        obj.Wrapped = ut
    endif

    obj.Params = {}
    obj.Body = invalid
    obj.ContentType = invalid
    obj.Type = "GET"

    obj.AddParam       = request_add_param
    obj.SetType        = request_set_type
    obj.SetBody        = request_set_body
    obj.GetQueryString = request_get_query_string
    obj.Execute        = request_execute
    obj.Start          = request_start
    obj.GetResponse    = request_get_response
'    print("RESPUESTA")
'    print(obj)
    return obj
End Function

Function NewRequestFavs(url As Object, tipe As String, body As String) as Object
    obj = CreateObject("roAssociativeArray")
    if type(url) = "roUrlTransfer" then
        obj.Wrapped = url
    else
        ut = CreateObject("roUrlTransfer")
        ut.SetPort(CreateObject("roMessagePort"))
        ut.SetUrl(url)
        ut.EnableEncodings(true)
        
        ut.AddHeader("Authorization", "Basic <BASE 64 ENCODED SEGMENT WRITE KEY>")
        
        ut.AddHeader("Accept", "application/json")
        
        'ut.AddHeader("Content-Type", "application/json")
        ut.EnablePeerVerification(false)
        ut.EnableHostVerification(false)
        ut.RetainBodyOnError(true)
        ut.SetCertificatesFile("common:/certs/ca-bundle.crt")
        ut.InitClientCertificates()
        
        SetUpUrlTransferObject(ut)

        obj.Wrapped = ut
    endif
    
    obj.Params = {}
    if(body="invalid")then
        obj.Body = invalid
        obj.ContentType = invalid
    else
        obj.Body = m.top.Body
       ' obj.Body = FormatJson(m.top.Body)
        print obj.Body
        'obj.ContentType = "application/json"
    end if
    obj.ContentType = invalid
 
    obj.Type = tipe
    print tipe
    obj.AddParam       = request_add_param
    obj.SetType        = request_set_type
    obj.SetBody        = request_set_body
    obj.GetQueryString = request_get_query_string
    obj.Execute        = request_execute
    obj.Start          = request_start1
    obj.GetResponse    = request_get_response
    return obj
End Function


REM ******************************************************
REM Execute all the given requests concurrently. The
REM requests must be given in a hash. The responses will
REM be given back in a new hash with the same keys.
REM Multiple levels are okay; the response hash will
REM mirror the input structure.
REM ******************************************************
Function ExecuteRequests(requests) As Object
    'Start them all off
    start_requests(requests)

    'And grab all the results
    return get_responses(requests)
End Function

Function start_requests(requests)
    for each key in requests
        req = requests[key]

        if type(req.Wrapped) <> "roUrlTransfer"
            ' This isn't a request, it's a nested hash; recurse.
            start_requests(req)
        else
            ' The real nut-meat; start the request!
            req.Start()
        endif
    end for
End Function

Function get_responses(requests) As Object
    results = {}

    for each key in requests
        req = requests[key]

'        if type(req.Wrapped) <> "roUrlTransfer"
'            ' This isn't a request, it's a nested hash; recurse.
'            results[key] = get_responses(req)
'        else
            ' The real nut-meat; get the response!
            results[key] = req.GetResponse()
'        endif 
    end for

    return results
End Function

REM ******************************************************
REM Add a parameter to the request. The parameter is added
REM to the query string for a GET and as
REM "application/x-www-form-urlencoded" to the body for
REM all other request types.
REM ******************************************************
Function request_add_param(key As String, val As String) As Object
    m.Params[key] = val
    return m
End Function

REM ******************************************************
REM Set the HTTP request type. GET by default.
REM ******************************************************
Function request_set_type(theType As String) As Object
    m.Type = UCase(theType)
    return m
End Function

REM ******************************************************
REM Set the HTTP request body and Content-Type. This
REM forces any parameters to be ignored for POST requests.
REM The body is ignored if this is a HEAD or GET request.
REM ******************************************************
Function request_set_body(body As String, contentType as String) As Object
    m.Body = body
    m.ContentType = contentType
    return m
End Function

REM ******************************************************
REM Get the current parameters URL encoded.
REM ******************************************************
Function request_get_query_string() As String
    qs = ""
    first = true

    for each key in m.Params
        if not first
            qs = qs + "&"
        end if

        qs = qs + m.Wrapped.Escape(key) + "=" + m.Wrapped.Escape(m.Params[key])

        first = false
    end for

    return qs
End Function

REM ******************************************************
REM Start the request asyncronously.
REM ******************************************************
Function request_start()
    if m.Type = "GET"
        if m.Params.Count() > 0
            qs = m.GetQueryString()
            url = m.Wrapped.GetUrl()

            if url.Instr(0, "?") > -1
                m.Wrapped.SetUrl(url + "&" + qs)
            else
                m.Wrapped.SetUrl(url + "?" + qs)
            endif

            m.Params = {}
        endif

        return m.Wrapped.AsyncGetToString()
    else  if m.Type = "HEAD"
        return m.Wrapped.AsyncHead()
    else
        if m.Type <> "POST"
            m.SetRequest(req.Type)
        endif

        body = invalid
        contentType = invalid

        if m.Body <> invalid
            body = m.Body
            contentType = m.ContentType
        else if m.Params.Count() > 0
            body = m.GetQueryString()
            contentType = "application/x-www-form-urlencoded"
        endif

        if body <> invalid and contentType <> invalid
            m.Wrapped.AddHeader("Content-Type", contentType)
            return m.Wrapped.AsyncPostFromString(body)
        endif
        
        return m.Wrapped.AsyncPostFromString("")
    endif
End Function
Function request_start1()
     if m.Type = "GET"
        if m.Params.Count() > 0
            qs = m.GetQueryString()
            url = m.Wrapped.GetUrl()

            if url.Instr(0, "?") > -1
                m.Wrapped.SetUrl(url + "&" + qs)
            else
                m.Wrapped.SetUrl(url + "?" + qs)
            endif

            m.Params = {}
        endif

        return m.Wrapped.AsyncGetToString()
    else if m.Type = "HEAD"
        return m.Wrapped.AsyncHead()
    else
        if m.Type <> "POST"
            'print ("request "+m.top.requestOption)
            m.Wrapped.SetRequest(m.Type)
        endif

        body = invalid
        contentType = invalid

        if m.Body <> invalid
            body = m.Body
            contentType ="application/json"
        else if m.Params.Count() > 0
            body = m.GetQueryString()
            contentType = "application/x-www-form-urlencoded"
        endif

        if body <> invalid and contentType <> invalid
            m.Wrapped.AddHeader("Content-Type", contentType)
            return m.Wrapped.AsyncPostFromString(body)
        endif
        
        return m.Wrapped.AsyncPostFromString("")
    endif
End Function

REM ******************************************************
REM Wait for the response to come back. Remember to call
REM Start() first!
REM ******************************************************
Function request_get_response()
    event = wait(10000, m.Wrapped.GetPort())
    if type(event) = "roUrlEvent"
        ct = event.GetResponseHeaders()["Content-Type"]
        print "codigo :";event.GetResponseCode()
        
        if ct <> invalid and ct.Instr(0, "application/json") > -1
            res = ParseJson(event.GetString())
            print "res: ";res
            if res = invalid
                return invalid
            endif

            return res
        else
            return event.GetString()
        endif
    else if event = invalid
        m.Wrapped.AsyncCancel()
        return invalid
    endif
End Function

REM ******************************************************
REM A handy way to execute only the current request.
REM ******************************************************
Function request_execute() As Object
    m.Start()
    return m.GetResponse()
End Function


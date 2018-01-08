
function ContentList2Node(contentList as Object) as Object
    result = createObject("roSGNode","ContentNode")
   
    for each itemAA in contentList
    
        item = createObject("roSGNode", "ContentNode")
        item.SetFields(itemAA)
        result.appendChild(item)
        
    end for
    
    return result
end function
function GetContet() as object
    'm.Token = CallApi("http://ssolab1.nagra.com/net/qsp/gateway/http/js/signonService/signonByUser?arg0=FAB&arg1=1234")
    m.Token="title"
    content = CreateObject("roSGNode", "ContentNode")
    'content.title = m.Token.token
    content.title="title"
    Movies = content.CreateChild("ContentNode")
    Movies.title = "Movies"    
    item = Movies.CreateChild("database_component")
    'item.content = MoviesContentNode()
    Series = content.CreateChild("ContentNode")
    Series.title = "Series"    
    'item = Series.CreateChild("database_component")
    'item.content = SeriesContentNode()
    Guide = content.CreateChild("ContentNode")
    Guide.title = "Guide"    
    'item = Guide.CreateChild("database_component")
    'item.content = GuideContentNode()
    Favourites = content.CreateChild("ContentNode")
    Favourites.title = "Favourites"    
    'item = Favourites.CreateChild("database_component")
    'item.content = FavoritesContentNode()
    Histories = content.CreateChild("ContentNode")
    Histories.title = "Histories"    
    'item = Histories.CreateChild("database_component")
    'item.content = HistorialContentNode()
    Reminders = content.CreateChild("ContentNode")
    Reminders.title = "Reminders"    
    'item = Reminders.CreateChild("database_component")
    'item.content = ReminderContentNode()
    stop
    return content        
end function

function GuideContentNode() as object
    content = createObject("roSGNode", "ContentNode")
    objContentServices = CallApi("https://213.244.195.170/metadata/delivery/CMS4X/btv/services?&filter={" + Chr(34) + "deviceType" + Chr(34) + ":"  + Chr(34) + "Browser"  + Chr(34) + "}&fields=[" + Chr(34) + "editorial.PromoImages" + Chr(34) + "," + Chr(34) + "editorial.tvChannel" + Chr(34) + "," + Chr(34) + "editorial.PromoImages" + Chr(34) + "," + Chr(34) + "technical.Title" + Chr(34) + "," + Chr(34) + "technical.NetworkLocation" + Chr(34) + "]&sort=[[" + Chr(34) + "editorial.Title" + Chr(34) + ",1]]" )
    for each kindServices in objContentServices.services
        itemContent = content.createChild("ContentNode")
        itemContent.id = kindServices.editorial.id
        itemContent.title = kindServices.technical.title
        dt = CreateObject ("roDateTime")
        ms = dt.AsSeconds ().ToStr ()
        iMs = ms.ToInt()-604800
        objContent = CallApi("https://213.244.195.170/metadata/delivery/CMS4X/btv/programmes?&filter={" + Chr(34) + "serviceRef" + Chr(34) + ":"  + Chr(34) +  kindServices.editorial.id.ToStr() + Chr(34) + ","  + Chr(34) + "period.start"  + Chr(34) +  ":{" + Chr(34) +  "$gt"  + Chr(34) +  ":" +  iMs.ToStr()  + "}}&fields=[" + Chr(34) + "id" + Chr(34) + "," + Chr(34) + "Title" + Chr(34) + "," + Chr(34) + "PromoImages" + Chr(34) + "," + Chr(34) + "Description" + Chr(34) + "," + Chr(34) + "Sinopsis" + Chr(34) + "," + Chr(34) + "Year" + Chr(34) + "," + Chr(34) + "serviceRef" + Chr(34) + "," + Chr(34) + "period.start" + Chr(34) + "," + Chr(34) + "period.end" + Chr(34) + "," + Chr(34) + "Rating.Title" + Chr(34)  + "]&sort=[[" + Chr(34) + "period.start"  + Chr(34) + ",1]] &limit=10&offset=0" )  ' '.Execute()["total_records"]  '
        contentVideo = createObject("roSGNode", "ContentNode")            
        for each kind in objContent.programmes
            subItemContent = itemContent.createChild("SimpleRowListItemData")
                    
            subItemContent.posterUrl = kind.PromoImages[0]
            subItemContent.labelText = kind.Title
            subItemContent.strTitle = kind.Title
            subItemContent.strDescription = kind.Description
                    
            itemContentVideo = contentVideo.createChild("ContentNode")
            subItemContent.id = kind.id
            subItemContent.title = kind.Title
            subItemContent.HDPosterUrl = kind.PromoImages[0]
            subItemContent.Description = kind.Description
            Result = CreateObject("roArray", 10, true)
            Result.push({url: kindServices.technical.NetworkLocation, contentid: kindServices.technical.id})
            itemContentVideo.Streams = Result
            itemContentVideo.id = kind.id
            strPeriodStart = kind.period.start
            dtps = CreateObject ("roDateTime")
            dtps.fromSeconds(strPeriodStart)
            subItemContent.ReleaseDate =dtps.ToISOString() 
            subItemContent.url = kindServices.technical.NetworkLocation
            subItemContent.streamFormat = "hls"
        end for
    end for                        
    return content
end function
function FavoritesContentNode() as object
    content = createObject("roSGNode", "ContentNode")
    objContentFav = CallApi("http://ssolab1.nagra.com/net/useractivityvault/v1/clientdata/account/TQMG/favouriteslists/2551c3c0-e316-11e6-a12c-218dd48cc1a1?token="+m.Token.token)  
    count=0

    for each kindFav in objContentFav.favourites
        if(count=0 or count = 6 or count=12 or count=18)then
        itemContent = content.createChild("ContentNode")
        itemContent.title = "Favorites"+count.ToStr()
        end if
        contId = Left(kindFav.contentId, 3)
        if (contId <> "CNT") then
            objContent = CallApi("https://213.244.195.170/metadata/delivery/CMS4X/vod/editorials?&filter={" + Chr(34) + "technical.deviceType" + Chr(34) + ":"  + Chr(34) + "Browser" + Chr(34) + ","  + Chr(34) + "editorial.seriesRef"  + Chr(34) + Chr(58) + Chr(34) +  kindFav.contentId + Chr(34) +  "}&fields=[" + Chr(34) + "editorial._id" + Chr(34) + "," + Chr(34) + "editorial.Title" + Chr(34) + "," + Chr(34) + "editorial.title" + Chr(34) + "," + Chr(34) + "editorial.Description" + Chr(34) + "," + Chr(34) + "editorial.Actors" + Chr(34) + "," + Chr(34) + "editorial.Categories" + Chr(34) + "," + Chr(34) + "editorial.Rating" + Chr(34) + "," + Chr(34) + "editorial.episodeNumber" + Chr(34) + "," + Chr(34) + "editorial.PromoImages" + Chr(34) + "," + Chr(34) + "technical.Definition" + Chr(34) + "," + Chr(34) + "technical.media" + Chr(34) + "," + Chr(34) + "product.price" + Chr(34) + "," + Chr(34) + "product.type" + Chr(34) + "," + Chr(34) + "product.nodeRefs" + Chr(34) + "," + Chr(34) + "product.startPurchase" + Chr(34) + "," + Chr(34) + "product.endPurchase" + Chr(34) + "," + Chr(34) + "product.startValidity" + Chr(34) + "," + Chr(34) + "product.endValidity" + Chr(34) + "," + Chr(34) + "editorial.seriesRef" + Chr(34) + "," + Chr(34) + "voditem.nodeRefs" + Chr(34) + "]&sort=[[" + Chr(34) + "editorial.title" + Chr(34) + ",1]]&limit=10&offset=0" )  ' '.Execute()["total_records"]  '
            'print "URL **************************************"; "https://213.244.195.170/metadata/delivery/CMS4X/vod/editorials?&filter={" + Chr(34) + "technical.deviceType" + Chr(34) + ":"  + Chr(34) + "Browser" + Chr(34) + ","  + Chr(34) + "editorial.seriesRef"  + Chr(34) + Chr(58) + Chr(34) +  kindFav.contentId + Chr(34) +  "}&fields=[" + Chr(34) + "editorial._id" + Chr(34) + "," + Chr(34) + "editorial.Title" + Chr(34) + "," + Chr(34) + "editorial.title" + Chr(34) + "," + Chr(34) + "editorial.Description" + Chr(34) + "," + Chr(34) + "editorial.Actors" + Chr(34) + "," + Chr(34) + "editorial.Categories" + Chr(34) + "," + Chr(34) + "editorial.Rating" + Chr(34) + "," + Chr(34) + "editorial.episodeNumber" + Chr(34) + "," + Chr(34) + "editorial.PromoImages" + Chr(34) + "," + Chr(34) + "technical.Definition" + Chr(34) + "," + Chr(34) + "technical.media" + Chr(34) + "," + Chr(34) + "product.price" + Chr(34) + "," + Chr(34) + "product.type" + Chr(34) + "," + Chr(34) + "product.nodeRefs" + Chr(34) + "," + Chr(34) + "product.startPurchase" + Chr(34) + "," + Chr(34) + "product.endPurchase" + Chr(34) + "," + Chr(34) + "product.startValidity" + Chr(34) + "," + Chr(34) + "product.endValidity" + Chr(34) + "," + Chr(34) + "editorial.seriesRef" + Chr(34) + "," + Chr(34) + "voditem.nodeRefs" + Chr(34) + "]&sort=[[" + Chr(34) + "editorial.title" + Chr(34) + ",1]]&limit=10&offset=0"
        else
            objContent = CallApi("https://213.244.195.170/metadata/delivery/CMS4X/vod/editorials?&filter={" + Chr(34) + "technical.deviceType" + Chr(34) + ":"  + Chr(34) + "Browser" + Chr(34) + ","  + Chr(34) + "editorial.id"  + Chr(34) + Chr(58) + Chr(34) +  kindFav.contentId + Chr(34) +  "}&fields=[" + Chr(34) + "editorial._id" + Chr(34) + "," + Chr(34) + "editorial.Title" + Chr(34) + "," + Chr(34) + "editorial.title" + Chr(34) + "," + Chr(34) + "editorial.Description" + Chr(34) + "," + Chr(34) + "editorial.Actors" + Chr(34) + "," + Chr(34) + "editorial.Categories" + Chr(34) + "," + Chr(34) + "editorial.Rating" + Chr(34) + "," + Chr(34) + "editorial.episodeNumber" + Chr(34) + "," + Chr(34) + "editorial.PromoImages" + Chr(34) + "," + Chr(34) + "technical.Definition" + Chr(34) + "," + Chr(34) + "technical.media" + Chr(34) + "," + Chr(34) + "product.price" + Chr(34) + "," + Chr(34) + "product.type" + Chr(34) + "," + Chr(34) + "product.nodeRefs" + Chr(34) + "," + Chr(34) + "product.startPurchase" + Chr(34) + "," + Chr(34) + "product.endPurchase" + Chr(34) + "," + Chr(34) + "product.startValidity" + Chr(34) + "," + Chr(34) + "product.endValidity" + Chr(34) + "," + Chr(34) + "editorial.seriesRef" + Chr(34) + "," + Chr(34) + "voditem.nodeRefs" + Chr(34) + "]&sort=[[" + Chr(34) + "editorial.title" + Chr(34) + ",1]]&limit=10&offset=0" )  ' '.Execute()["total_records"]  '
            'print "URL **************************************"; "https://213.244.195.170/metadata/delivery/CMS4X/vod/editorials?&filter={" + Chr(34) + "technical.deviceType" + Chr(34) + ":"  + Chr(34) + "Browser" + Chr(34) + ","  + Chr(34) + "editorial.id"  + Chr(34) + Chr(58) + Chr(34) +  kindFav.contentId + Chr(34) +  "}&fields=[" + Chr(34) + "editorial._id" + Chr(34) + "," + Chr(34) + "editorial.Title" + Chr(34) + "," + Chr(34) + "editorial.title" + Chr(34) + "," + Chr(34) + "editorial.Description" + Chr(34) + "," + Chr(34) + "editorial.Actors" + Chr(34) + "," + Chr(34) + "editorial.Categories" + Chr(34) + "," + Chr(34) + "editorial.Rating" + Chr(34) + "," + Chr(34) + "editorial.episodeNumber" + Chr(34) + "," + Chr(34) + "editorial.PromoImages" + Chr(34) + "," + Chr(34) + "technical.Definition" + Chr(34) + "," + Chr(34) + "technical.media" + Chr(34) + "," + Chr(34) + "product.price" + Chr(34) + "," + Chr(34) + "product.type" + Chr(34) + "," + Chr(34) + "product.nodeRefs" + Chr(34) + "," + Chr(34) + "product.startPurchase" + Chr(34) + "," + Chr(34) + "product.endPurchase" + Chr(34) + "," + Chr(34) + "product.startValidity" + Chr(34) + "," + Chr(34) + "product.endValidity" + Chr(34) + "," + Chr(34) + "editorial.seriesRef" + Chr(34) + "," + Chr(34) + "voditem.nodeRefs" + Chr(34) + "]&sort=[[" + Chr(34) + "editorial.title" + Chr(34) + ",1]]&limit=10&offset=0"
        end if 
        
        for each kind in objContent.editorials
                itemContentPoster =itemContent.createChild("SimpleRowListItemData")
            
                itemContentPoster.posterUrl = kind.PromoImages[0]
                itemContentPoster.labelText = kind.Title
                itemContentPoster.strTitle = kind.Title
                itemContentPoster.strDescription = kind.Description
            
                itemContentPoster.Id = kind.Id
                itemContentPoster.HDGRIDPOSTERURL = kind.PromoImages[0]
                itemContentPoster.SDGRIDPOSTERURL = kind.PromoImages[0]
                itemContentPoster.shortdescriptionline1 = kind.Title
                itemContentPoster.shortdescriptionline2 = kind.Description
                
                itemContentPoster.title = kind.Title

                itemContentPoster.title = kind.Title
                itemContentPoster.Description = kind.Description
                'itemContentPoster.ReleaseDate = kind.Actors[0] '+ "            " +kind.Rating.Title '+ "            " + kind.Categories[0]
                itemContentPoster.Rating = kind.Rating.Title + "            " + kind.Categories[0] + "            " + kind.Technicals[0].Definition
                itemContentPoster.Stream = kind.Technicals[0].media.AV_ClearTS.fileName

                Result = CreateObject("roArray", 10, true)
                ResultIds = CreateObject("roArray", 10, true)
                contentIdRecord = ""
               
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
                    
                 end for
                itemContentPoster.Streams = Result'subSubItemContent
                itemContentPoster.StreamUrls = Result'subSubItemContent
                itemContentPoster.StreamContentIDs = ResultIds
                itemContentPoster.StreamQualities=Result
                itemContentPoster.Id = kind.id
                'print "STREAMSSSSSSSSSSSSS"; kind.id
                itemContentPoster.url = kind.Technicals[0].media.AV_ClearTS.fileName
                itemContentPoster.streamFormat = kind.Technicals[0].media.AV_ClearTS.format
                itemContentPoster.HDPosterUrl = kind.PromoImages[0]
                itemContentPoster.SDPosterUrl= kind.PromoImages[0]
                                       
               'print "itemContentPoster *********";itemContentPoster 
                
        end for            
        count=count+1       
    end for
    return content
end function
function FavoritesContentNode2() as object
    content = createObject("roSGNode", "ContentNode")
    objContentFav = CallApi("http://ssolab1.nagra.com/net/useractivityvault/v1/clientdata/account/TQMG/favouriteslists/2551c3c0-e316-11e6-a12c-218dd48cc1a1?token="+m.Token.token)  
    count=0

    Ids=""
    for each kindFav in objContentFav.favourites
        
        contId = Left(kindFav.contentId, 3)
        
        if (contId <> "CNT") then
        else
            'print "lenght";Ids.len().ToStr()
            if(Ids.len()<>0) then
                Ids+="," + Chr(34) + ""+kindFav.contentId+"" + Chr(34) + ""
            else
                Ids+="" + Chr(34) + ""+kindFav.contentId+"" + Chr(34) + ""
            end if
        end if 
     end for            
        objContent = CallApi("https://213.244.195.170/metadata/delivery/CMS4X/vod/editorials?&filter={" + Chr(34) + "technical.deviceType" + Chr(34) + ":"  + Chr(34) + "Browser" + Chr(34) + ","  + Chr(34) + "editorial.id"  + Chr(34) +  ":{" + Chr(34) +  "$in"  + Chr(34) +  ":[" +  Ids + "]}}&fields=[" + Chr(34) + "editorial._id" + Chr(34) + "," + Chr(34) + "editorial.Title" + Chr(34) + "," + Chr(34) + "editorial.title" + Chr(34) + "," + Chr(34) + "editorial.Description" + Chr(34) + "," + Chr(34) + "editorial.Actors" + Chr(34) + "," + Chr(34) + "editorial.Categories" + Chr(34) + "," + Chr(34) + "editorial.Rating" + Chr(34) + "," + Chr(34) + "editorial.episodeNumber" + Chr(34) + "," + Chr(34) + "editorial.PromoImages" + Chr(34) + "," + Chr(34) + "technical.Definition" + Chr(34) + "," + Chr(34) + "technical.media" + Chr(34) + "," + Chr(34) + "product.price" + Chr(34) + "," + Chr(34) + "product.type" + Chr(34) + "," + Chr(34) + "product.nodeRefs" + Chr(34) + "," + Chr(34) + "product.startPurchase" + Chr(34) + "," + Chr(34) + "product.endPurchase" + Chr(34) + "," + Chr(34) + "product.startValidity" + Chr(34) + "," + Chr(34) + "product.endValidity" + Chr(34) + "," + Chr(34) + "editorial.seriesRef" + Chr(34) + "," + Chr(34) + "voditem.nodeRefs" + Chr(34) + "]&sort=[[" + Chr(34) + "editorial.title" + Chr(34) + ",1]]&limit=10&offset=0" )  ' '.Execute()["total_records"]  '
            
        for each kind in objContent.editorials
                if(count=0 or count = 6 or count=12 or count=18 or count=24 or count=30 or count=36 or count=42 or count=48 or count=54 or count=60)then
                itemContent = content.createChild("ContentNode")
                itemContent.title = "Favorites"+count.ToStr()
                end if
                itemContentPoster =itemContent.createChild("SimpleRowListItemData")
            
                itemContentPoster.posterUrl = kind.PromoImages[0]
                itemContentPoster.labelText = kind.Title
                itemContentPoster.strTitle = kind.Title
                itemContentPoster.strDescription = kind.Description
            
                itemContentPoster.Id = kind.Id
                itemContentPoster.HDGRIDPOSTERURL = kind.PromoImages[0]
                itemContentPoster.SDGRIDPOSTERURL = kind.PromoImages[0]
                itemContentPoster.shortdescriptionline1 = kind.Title
                itemContentPoster.shortdescriptionline2 = kind.Description
                
                itemContentPoster.title = kind.Title

                itemContentPoster.title = kind.Title
                itemContentPoster.Description = kind.Description
                'itemContentPoster.ReleaseDate = kind.Actors[0] '+ "            " +kind.Rating.Title '+ "            " + kind.Categories[0]
                itemContentPoster.Rating = kind.Rating.Title + "            " + kind.Categories[0] + "            " + kind.Technicals[0].Definition
                itemContentPoster.Stream = kind.Technicals[0].media.AV_ClearTS.fileName

                Result = CreateObject("roArray", 10, true)
                ResultIds = CreateObject("roArray", 10, true)
                contentIdRecord = ""
               
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
                    
                 end for
                itemContentPoster.Streams = Result'subSubItemContent
                itemContentPoster.StreamUrls = Result'subSubItemContent
                itemContentPoster.StreamContentIDs = ResultIds
                itemContentPoster.StreamQualities=Result
                itemContentPoster.Id = kind.id
                'print "STREAMSSSSSSSSSSSSS"; kind.id
                itemContentPoster.url = kind.Technicals[0].media.AV_ClearTS.fileName
                itemContentPoster.streamFormat = kind.Technicals[0].media.AV_ClearTS.format
                itemContentPoster.HDPosterUrl = kind.PromoImages[0]
                itemContentPoster.SDPosterUrl= kind.PromoImages[0]
                                       
               'print "itemContentPoster *********";itemContentPoster 
               count=count+1   
        end for            
            
    
    return content
end function
function HistorialContentNode() as object
    content = createObject("roSGNode", "ContentNode")
    objContentFav = CallApi("http://ssolab1.nagra.com/net/useractivityvault/v1/clientdata/account/TQMG/history?limit=60&token="+m.Token.token)
    count=0
    Ids=""
    for each kindFav in objContentFav.histories        
       contId = Left(kindFav.contentId, 3) 
        if (contId <> "CNT") then

        else
            'print "lenght";Ids.len().ToStr()
            if(Ids.len()<>0) then
                Ids+="," + Chr(34) + ""+kindFav.contentId+"" + Chr(34) + ""
            else
                Ids+="" + Chr(34) + ""+kindFav.contentId+"" + Chr(34) + ""
            end if
        end if 
    end for
    objContent = CallApi("https://213.244.195.170/metadata/delivery/CMS4X/vod/editorials?&filter={" + Chr(34) + "technical.deviceType" + Chr(34) + ":"  + Chr(34) + "Browser" + Chr(34) + ","  + Chr(34) + "editorial.id"  + Chr(34) +  ":{" + Chr(34) +  "$in"  + Chr(34) +  ":[" +  Ids + "]}}&fields=[" + Chr(34) + "editorial._id" + Chr(34) + "," + Chr(34) + "editorial.Title" + Chr(34) + "," + Chr(34) + "editorial.title" + Chr(34) + "," + Chr(34) + "editorial.Description" + Chr(34) + "," + Chr(34) + "editorial.Actors" + Chr(34) + "," + Chr(34) + "editorial.Categories" + Chr(34) + "," + Chr(34) + "editorial.Rating" + Chr(34) + "," + Chr(34) + "editorial.episodeNumber" + Chr(34) + "," + Chr(34) + "editorial.PromoImages" + Chr(34) + "," + Chr(34) + "technical.Definition" + Chr(34) + "," + Chr(34) + "technical.media" + Chr(34) + "," + Chr(34) + "product.price" + Chr(34) + "," + Chr(34) + "product.type" + Chr(34) + "," + Chr(34) + "product.nodeRefs" + Chr(34) + "," + Chr(34) + "product.startPurchase" + Chr(34) + "," + Chr(34) + "product.endPurchase" + Chr(34) + "," + Chr(34) + "product.startValidity" + Chr(34) + "," + Chr(34) + "product.endValidity" + Chr(34) + "," + Chr(34) + "editorial.seriesRef" + Chr(34) + "," + Chr(34) + "voditem.nodeRefs" + Chr(34) + "]&sort=[[" + Chr(34) + "editorial.title" + Chr(34) + ",1]]&limit=10&offset=0" )  ' '.Execute()["total_records"]  '            
    for each kind in objContent.editorials
    if(count=0 or count = 6 or count=12 or count=18 or count=24 or count=30 or count=36 or count=42 or count=48 or count=54 or count=60)then
        itemContent = content.createChild("ContentNode")
        itemContent.title = "Histories"+count.ToStr()
        end if    
    

                itemContentPoster =itemContent.createChild("SimpleRowListItemData")
            
                itemContentPoster.posterUrl = kind.PromoImages[0]
                itemContentPoster.labelText = kind.Title
                itemContentPoster.strTitle = kind.Title
                itemContentPoster.strDescription = kind.Description
                
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

                itemContentPoster.url = kind.Technicals[0].media.AV_ClearTS.fileName
                itemContentPoster.streamFormat = kind.Technicals[0].media.AV_ClearTS.format
                itemContentPoster.HDPosterUrl = kind.PromoImages[0]
                itemContentPoster.SDPosterUrl= kind.PromoImages[0]
                                       

                
           

        'count=count+1  
    end for
    return content
end function
function ReminderContentNode() as object
    content = createObject("roSGNode", "ContentNode")
    objContentFav = CallApi("http://ssolab1.nagra.com/net/useractivityvault/v1/clientdata/account/TQMG/reminders/?token="+m.Token.token)
    count=0
    for each kindFav in objContentFav.reminders
        if(count=0 or count = 6 or count=12 or count=18)then
            itemContent = content.createChild("ContentNode")
            itemContent.title = "Reminders"+count.ToStr()
        end if
        contId = Left(kindFav.contentId, 3)                    
        objContent = CallApi("https://213.244.195.170/metadata/delivery/CMS4X/btv/programmes?&fields=[" + Chr(34) + "Description" + Chr(34) + "," + Chr(34) + "PromoImages" + Chr(34) + "," + Chr(34) + "Rating" + Chr(34) + "," + Chr(34) + "Title" + Chr(34) + "," + Chr(34) + "id" + Chr(34) + "," + Chr(34) + "serviceRef" + Chr(34) + "," + Chr(34) + "period.start" + Chr(34) + "]&filter={" + Chr(34) + "id" + Chr(34) + ":" + Chr(34) + kindFav.contentId + Chr(34) + "}&sort=[[" + Chr(34) + "period.start" + Chr(34) + ",1]]&limit=10&offset=0")
        'print "https://213.244.195.170/metadata/delivery/CMS4X/btv/programmes?&fields=[" + Chr(34) + "Description" + Chr(34) + "," + Chr(34) + "PromoImages" + Chr(34) + "," + Chr(34) + "Rating" + Chr(34) + "," + Chr(34) + "Title" + Chr(34) + "," + Chr(34) + "id" + Chr(34) + "," + Chr(34) + "serviceRef" + Chr(34) + "," + Chr(34) + "period.start" + Chr(34) + "]&filter={" + Chr(34) + "id" + Chr(34) + ":" + Chr(34) + kindFav.contentId + Chr(34) + "}&sort=[[" + Chr(34) + "period.start" + Chr(34) + ",1]]&limit=10&offset=0"  
        for each kind in objContent.programmes
                itemContentPoster =itemContent.createChild("SimpleRowListItemData")
            
                itemContentPoster.posterUrl = kind.PromoImages[0]
                itemContentPoster.labelText = kind.Title
                itemContentPoster.strTitle = kind.Title
                itemContentPoster.strDescription = kind.Description
                
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
                'print "dts *****";dtps.ToISOString()
                itemContentPoster.ReleaseDate =dtps.ToISOString() 
                itemContentPoster.StreamContentIDs = kindFav.id
                itemContentPoster.Rating = kind.Rating.Title
                itemContentPoster.Stream = kindFav.metadata.channel
                itemContentPoster.url = kindFav.metadata.channel
                itemContentPoster.streamFormat = "hls"
                itemContentPoster.HDPosterUrl = kind.PromoImages[0]
                itemContentPoster.SDPosterUrl= kind.PromoImages[0]
                                       
               'print "itemContentPoster *********";itemContentPoster 
                
        end for            
        count=count+1  
    end for
    return content
end function

function CallApi(url As Object) as Object
   'print
    ut = CreateObject("roUrlTransfer")
    'print url.EncodeUri()
    ut.SetUrl(url.EncodeUri())
    ut.EnableEncodings(true)
    ut.EnablePeerVerification(false)
    ut.EnableHostVerification(false)
    ut.RetainBodyOnError(true)
    ut.SetCertificatesFile("common:/certs/ca-bundle.crt")
    ut.InitClientCertificates()
    'SetUpUrlTransferObject(ut)
    res = ParseJson(ut.GetToString())
    'res = ParseJson(ut.GetToString())
    'print "Movies " ; res.editorials
    return res
end function 


sub FillArrayProducto()
      subItemContent.strProducto[0]=subItemContent.strId
      subItemContent.strProducto[1]=subItemContent.strTitle
      subItemContent.strProducto[2]=subItemContent.strDescription
      subItemContent.strProducto[3]=subItemContent.strRating
      subItemContent.strProducto[4]=subItemContent.strCategories
      subItemContent.strProducto[5]=subItemContent.stream
      subItemContent.strProducto[6]=subItemContent.strName
      subItemContent.strProducto[7]=subItemContent.strValue
      subItemContent.strProducto[8]=subItemContent.strActors  
      subItemContent.strProducto[9]=subItemContent.strProducto         
end sub

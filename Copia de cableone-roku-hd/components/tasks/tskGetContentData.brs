sub init()
        ?"TASK INIT"
         
        m.top.domain    = "157.97.103.217"
        m.top.url       = "/metadata/delivery/CMS4X/vod/ACTION?"
        m.top.device    = Chr(34) + "technical.deviceType" + Chr(34) + ":"  + Chr(34) + "Browser" + Chr(34)  
        ?m.top.device   
        m.top.permissionfilter = Chr(34) + "editorial.Rating.code"  + Chr(34) + ":{"  + Chr(34) + "$lte"  + Chr(34) + ":"  + Chr(34) + "RATING_LEVEL"  + Chr(34) + "}"
        
    end sub
    
    function setFunctionName()
    ?"setfunctionname init"
     if m.top.mediaType="movie" or m.top.mediaType="MOVIES" then
     ?"setfunctioname Movies"
        m.top.functionName = "getMovies"
     else
        if m.top.mediaType="serie" or m.top.mediaType="Series" then
            ?"series"
            m.top.functionName="getSeries"
        else
            m.top.functionName="getSeasons"
        end if
     end if       
    end function
    
    
    sub getMovies()
    ?"getMOVIES init"
        'filtro Device - Constante
        'filtro por proveedor
        strProviders=""
        if(m.top.provider.Count()>0) then
            For Each provider in m.top.provider
                strProviders=strProviders + Chr(34) + provider + Chr(34) + ","
            end For
            strProviders = strProviders + Chr(34) +Chr(34)
            provider_filter = "" + Chr(34) + "voditem.nodeRefs" + Chr(34) + ":{" + Chr(34) + "$in" + Chr(34) + ":[" + strProviders + "]}"
        end if
        
          
        'If movie content
        movie_filter = Chr(34) +"editorial.episodeNumber"+ Chr(34)+":{" + Chr(34) + "$exists"+ Chr(34)+":false}"
        
        'permission level
        permission_filter = m.top.permissionfilter.replace("RATING_LEVEL",m.top.permission)
        
        m.top.url = m.top.url.replace("ACTION","editorials")
        
        'Fields
        fields = "&fields=[" + Chr(34) + "editorial._id" + Chr(34) + "," + Chr(34) + "editorial.Title" + Chr(34) + "," + Chr(34) + "editorial.title" + Chr(34) + "," + Chr(34) + "editorial.Description" + Chr(34) + "," + Chr(34) + "editorial.Actors" + Chr(34) + "," + Chr(34) + "editorial.Categories" + Chr(34) + "," + Chr(34) + "editorial.Rating" + Chr(34) + "," + Chr(34) + "editorial.episodeNumber" + Chr(34) + "," + Chr(34) + "editorial.PromoImages" + Chr(34) + "," + Chr(34) + "technical.Definition" + Chr(34) + "," + Chr(34) + "technical.media" + Chr(34) + "," + Chr(34) + "product.price" + Chr(34) + "," + Chr(34) + "product.type" + Chr(34) + "," + Chr(34) + "product.nodeRefs" + Chr(34) + "," + Chr(34) + "product.startPurchase" + Chr(34) + "," + Chr(34) + "product.endPurchase" + Chr(34) + "," + Chr(34) + "product.startValidity" + Chr(34) + "," + Chr(34) + "product.endValidity" + Chr(34) + "," + Chr(34) + "editorial.seriesRef" + Chr(34) + "," + Chr(34) + "voditem.nodeRefs" + Chr(34) + "]"
        
        device = m.top.device
        
        limit = "&limit=" + m.top.limit
        
        offset = "&offset=" + m.top.offset
        
        strCategories = ""
        category_filter=""
        content = createObject("roSGNode", "ContentNode")'Nodo principal
        content.TITLE = m.top.mediaType
        arreglo = []
        if(m.top.categories.Count()>0) then
        ?m.top.categories.Count()
            For Each category in m.top.categories
                
                nodeCategory = content.createChild("ContentNode")
                nodeCategory.title = category
            
                category_filter = "," + Chr(34) + "editorial.Categories" +  Chr(34) + ":" +  Chr(34)  + category + Chr(34)  
                               
                    'Filter
                filter = "filter={" +  device  + "," + permission_filter + ","+ provider_filter + "," + movie_filter + category_filter +"}"              
                url = m.top.protocol + m.top.domain + m.top.url + filter + fields + limit + offset
                
                
                ?"CONSULTANDO: " + url
                result = CallApi(url)
                
                convertirANodo(result,nodeCategory)
                
                ?"Category node"
                ?nodeCategory
    
            end for
            
           
        end if
        arreglo.push(content)
         m.top.result = arreglo
            m.top.index=1
        
        
    end sub
   
   sub getSeries()
    ?"getSeries init"
      
        
        m.top.url = m.top.url.replace("ACTION","series")    
        
        'If serie content
        serie_filter =  Chr(34) + "PrivateMetadata"  + Chr(34) + ":"  + Chr(34) + "isParent:true"  + Chr(34) + ""
        
        'permission level
        permission_filter = m.top.permissionfilter.replace("RATING_LEVEL",m.top.permission)
        
        
        'Fields
        fields = "&fields=[" + Chr(34) + "id" + Chr(34) + "," + Chr(34) + "Title" + Chr(34) + "," + Chr(34) + "title" + Chr(34) + "," + Chr(34) + "Description" + Chr(34) + ","  + Chr(34) + "Categories" + Chr(34) + "," + Chr(34) + "Rating" + Chr(34) + ","  + Chr(34) + "PromoImages" + Chr(34) +  "]"
        
        device = m.top.device
        
        limit = "&limit=" + m.top.limit
        
        offset = "&offset=" + m.top.offset
        
        strCategories = ""
        category_filter=""
        content = createObject("roSGNode", "ContentNode")'Nodo principal
        content.TITLE = m.top.mediaType
        arreglo = []
        if(m.top.categories.Count()>0) then
        ?m.top.categories.Count()
            For Each category in m.top.categories
                
                nodeCategory = content.createChild("ContentNode")
                nodeCategory.title = category
            
                category_filter = "," + Chr(34) + "Categories" +  Chr(34) + ":" +  Chr(34)  + category + Chr(34)  
                               
                    'Filter
                filter = "filter={" + serie_filter + category_filter +"}"              
                url = m.top.protocol + m.top.domain + m.top.url + filter + fields + limit + offset
                
                
                ?"CONSULTANDO: " + url
                result = CallApi(url)
                
                serieANodo(result,nodeCategory)
                
                ?"Category node"
                ?nodeCategory
                
                
                
    
            end for
            
           
        end if
        arreglo.push(content)
         m.top.result = arreglo
            m.top.index=1
        
        
    end sub
   sub getSeasons()
    ?"getSeasons init"
        content = createObject("roSGNode", "ContentNode")'Nodo principal
        
        content.title = "season"
        
        m.top.url = m.top.url.replace("ACTION","series")    
        
        'If serie content
        season_filter =  Chr(34) + "PrivateMetadata"  + Chr(34) + ":{"  + Chr(34) + "$regex" + Chr(34) + ":" + Chr(34) + m.top.serieid  + Chr(34) + "}"
        
        'Fields
        fields = "&fields=[" + Chr(34) + "id" + Chr(34) + "," + Chr(34) + "Title" + Chr(34) + "," + Chr(34) + "title" + Chr(34) + "," + Chr(34) + "Description" + Chr(34) + ","  + Chr(34) + "Categories" + Chr(34) + "," + Chr(34) + "Rating" + Chr(34) + ","  + Chr(34) + "PromoImages" + Chr(34) +  "]"
        sort = "&sort=[[" + chr(34) + "id" + chr(34) + ",1]]"
        content = createObject("roSGNode", "ContentNode")'Nodo principal
        content.TITLE = m.top.mediaType
        arreglo = []
       
        filter = "filter={" + season_filter +"}"              
        url = m.top.protocol + m.top.domain + m.top.url + filter + fields+ sort
                

        ?"CONSULTANDO temporadas: " + url
        result = CallApi(url)
        
        seasonANodo(result,content)
        
        arreglo.push(content)
        m.top.result = arreglo
        m.top.index=1
        
        
    end sub   
    sub convertirANodo(objeto as Object, nodeCategory as Object )
        for each editorial in objeto.editorials
            
                nodeContent = nodeCategory.createChild("SimpleRowListItemData")
                nodeContent.mediaType = "movie"
                nodeContent.posterUrl = editorial.PromoImages[0]
                nodeContent.labelText = editorial.Title
                nodeContent.strTitle = editorial.Title
                nodeContent.strDescription = editorial.Description
                nodeContent.id = editorial.id
                nodeContent.title = editorial.Title
                nodeContent.Description = editorial.Description
                nodeContent.strDescription=editorial.Description
                nodeContent.Rating = editorial.Rating.Title + "            " + editorial.Categories[0] + "            " + editorial.Technicals[0].Definition
                nodeContent.Stream = editorial.Technicals[0].media.AV_ClearTS.fileName
                nodeContent.strRating = editorial.Rating.Title
                strCategories=""
                for each category in editorial.Categories
                    strCategories = strCategories + category + " "
                end for
                nodeContent.strCategories = strCategories
                
                strActors =""
                for each actor in editorial.Actors
                    strActors = strActors + actor + " "
                end for
                nodeContent.strActors = strActors
                
                data = CreateObject("roSGNode", "ContentNode")
                datawrapper = CreateObject("roArray", 1, true)
                for each kindTechnical in editorial.Technicals
                    dataItem = data.CreateChild("contentProducts")
                    dataItem.posterUrl = "pkg:/images/LogosChannels/" + kindTechnical.products[0].voditems[0].nodeRefs[0] + ".png"
                    dataItem.labelProvider = kindTechnical.products[0].voditems[0].nodeRefs[0]
                    dataItem.labelDefinition = kindTechnical.Definition
                    
                    dataItem.labelPrice = Str(kindTechnical.products[0].price.value) + " " + kindTechnical.products[0].price.currency
                        dataItem.streamUrl = kindTechnical.media.AV_ClearTS.fileName
                end for
                datawrapper.push(data)
                nodeContent.strProducto = datawrapper
        
        end for
    end sub
    sub serieANodo(objeto as Object, nodeCategory as Object )
    
        for each serie in objeto.series
            
                nodeContent = nodeCategory.createChild("SimpleRowListItemData")
               ' nodeContent.posterUrl = serie.PromoImages[0]
                nodeContent.labelText = serie.Title
                nodeContent.strTitle = serie.Title
                nodeContent.mediaType = "serie"
                nodeContent.strDescription = serie.Description
                nodeContent.id = serie.id
                nodeContent.title = serie.Title
                nodeContent.Description = serie.Description
                nodeContent.strDescription=serie.Description
                nodeContent.strRating = serie.Rating.Title
                strCategories=""
                for each category in serie.Categories
                    strCategories = strCategories + category + " "
                end for
                nodeContent.strCategories = strCategories
                
               'Obtener imagen
                img_editorial = CallApi(m.top.protocol + m.top.domain + m.top.url + "&filter={"  +Chr(34) + "id" + Chr(34) +":"+ Chr(34) + serie.id + "_Season1" + Chr(34) +"}&fields=["  + Chr(34) + "PromoImages"  + Chr(34) + "]")
               
               if img_editorial.series.Count()>0 then
                nodeContent.posterUrl = img_editorial.series[0].PromoImages[0]
               else
                nodeContent.posterUrl = "pkg:/images/dummy_pic.png"
               end if
                'result = img_editorial.editoriales.
                
                data = CreateObject("roSGNode", "ContentNode")
                datawrapper = CreateObject("roArray", 1, true)
                
                datawrapper.push(data)
                nodeContent.strProducto = datawrapper
        
        end for
    end sub
    sub seasonANodo(objeto as Object, nodeCategory as Object )
    
        for each serie in objeto.series
            
                nodeContent = nodeCategory.createChild("SimpleRowListItemData")
                nodeContent.labelText = serie.Title
                nodeContent.strTitle = serie.Title
                nodeContent.mediaType = "season"
                nodeContent.strDescription = serie.Description
                nodeContent.id = serie.id
                nodeContent.title = serie.Title
                nodeContent.Description = serie.Description
                nodeContent.strDescription=serie.Description
                nodeContent.strRating = serie.Rating.Title
                strCategories=""
                for each category in serie.Categories
                    strCategories = strCategories + category + " "
                end for
                nodeContent.strCategories = strCategories
                
               'Obtener imagen
               
               if serie.PromoImages.Count()>0 then
                nodeContent.posterUrl = serie.PromoImages[0]
               else
                nodeContent.posterUrl = "pkg:/images/dummy_pic.png"
               end if
                'result = img_editorial.editoriales.

                getEpisodes(nodeContent)
                
                
               
        
        end for
    end sub
        sub episodioANodo(objeto as Object, nodeCategory as Object )
        
        for each editorial in objeto.editorials
            
                nodeContent = nodeCategory.createChild("SimpleRowListItemData")
                nodeContent.mediaType = "episode"
                nodeContent.posterUrl = editorial.PromoImages[0]
                nodeContent.labelText = editorial.Title
                nodeContent.strTitle = editorial.Title
                nodeContent.strDescription = editorial.Description
                nodeContent.id = editorial.id
                nodeContent.title = editorial.Title
                nodeContent.Description = editorial.Description
                nodeContent.strDescription=editorial.Description
                nodeContent.Rating = editorial.Rating.Title + "            " + editorial.Categories[0] + "            " + editorial.Technicals[0].Definition
                nodeContent.Stream = editorial.Technicals[0].media.AV_ClearTS.fileName
                nodeContent.strRating = editorial.Rating.Title
                nodeContent.episodeNumber = editorial.episodeNumber
                strCategories=""
                for each category in editorial.Categories
                    strCategories = strCategories + category + " "
                end for
                nodeContent.strCategories = strCategories
                
                strActors =""
                
                'for each actor in editorial.Actors
                '    strActors = strActors + actor + " "
                'end for
                nodeContent.strActors = strActors
                
                data = CreateObject("roSGNode", "ContentNode")
                datawrapper = CreateObject("roArray", 1, true)
                
                for each kindTechnical in editorial.Technicals
                    dataItem = data.CreateChild("contentProducts")
                    dataItem.posterUrl = "pkg:/images/LogosChannels/" + kindTechnical.products[0].voditems[0].nodeRefs[0] + ".png"
                    dataItem.labelProvider = kindTechnical.products[0].voditems[0].nodeRefs[0]
                    dataItem.labelDefinition = kindTechnical.Definition
                    
                    dataItem.labelPrice = Str(kindTechnical.products[0].price.value) + " " + kindTechnical.products[0].price.currency
                        dataItem.streamUrl = kindTechnical.media.AV_ClearTS.fileName
                end for
                datawrapper.push(data)
                nodeContent.strProducto = datawrapper
        
        end for
    end sub
    sub getEpisodes(temporada as object)
         
        strProviders=""
        provider_filter=""
        if(m.top.provider.Count()>0) then
            For Each provider in m.top.provider
                strProviders=strProviders + Chr(34) + provider + Chr(34) + ","
            end For
            strProviders = strProviders + Chr(34) +Chr(34)
            provider_filter = "" + Chr(34) + "voditem.nodeRefs" + Chr(34) + ":{" + Chr(34) + "$in" + Chr(34) + ":[" + strProviders + "]},"
        end if
        
          
        'If movie content
        'movie_filter = Chr(34) +"editorial.episodeNumber"+ Chr(34)+":{" + Chr(34) + "$exists"+ Chr(34)+":true}"
        episode_filter = chr(34) + "editorial.seriesRef" + chr(34) + ":" + chr(34) + temporada.id + chr(34)        
        'permission level
        permission_filter = m.top.permissionfilter.replace("RATING_LEVEL",m.top.permission) + ","
        
        'TODO se equita el filtro de device porque no muestra episodis, error de backend
        'filter = "filter={" +  m.top.device  + "," + permission_filter + ","+ provider_filter + "," + episode_filter + "}"
        
        filter = "filter={"  + permission_filter +  provider_filter +  episode_filter + "}"
        sort = "&sort=[[" + chr(34) + "editorial.episodeNumber" + chr(34) + ",1]]" 
        m.top.url = m.top.url.replace("series","editorials")    
              
        'Fields
        fields = "&fields=[" + Chr(34) + "editorial._id" + Chr(34) + "," + Chr(34) + "editorial.Title" + Chr(34) + "," + Chr(34) + "editorial.title" + Chr(34) + "," + Chr(34) + "editorial.Description" + Chr(34) + "," + Chr(34) + "editorial.Actors" + Chr(34) + "," + Chr(34) + "editorial.Categories" + Chr(34) + "," + Chr(34) + "editorial.Rating" + Chr(34) + "," + Chr(34) + "editorial.episodeNumber" + Chr(34) + "," + Chr(34) + "editorial.PromoImages" + Chr(34) + "," + Chr(34) + "technical.Definition" + Chr(34) + "," + Chr(34) + "technical.media" + Chr(34) + "," + Chr(34) + "product.price" + Chr(34) + "," + Chr(34) + "product.type" + Chr(34) + "," + Chr(34) + "product.nodeRefs" + Chr(34) + "," + Chr(34) + "product.startPurchase" + Chr(34) + "," + Chr(34) + "product.endPurchase" + Chr(34) + "," + Chr(34) + "product.startValidity" + Chr(34) + "," + Chr(34) + "product.endValidity" + Chr(34) + "," + Chr(34) + "editorial.seriesRef" + Chr(34) + "," + Chr(34) + "voditem.nodeRefs" + Chr(34) + "]"
        'content = createObject("roSGNode", "ContentNode")'Nodo principal
        'content.TITLE = temporada.title
        temporada.CONTENTTYPE ="SECTION"
        
        arreglo = []

        url = m.top.protocol + m.top.domain + m.top.url + filter + fields+ sort
                

        ?"CONSULTANDO EPISODIOS: " + url
        result = CallApi(url)
        
        episodioANodo(result,temporada)
        
        arreglo.push(temporada)
        m.top.result = arreglo
        
    end sub
    
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
       ' ?res
        return res
    end function 
    
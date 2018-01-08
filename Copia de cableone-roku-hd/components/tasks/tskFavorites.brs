    sub init()
        ?"TASK INIT"
         m.top.functionName=""
          
    end sub
    
    function setFunctionName()
    ?"setfunctionname init"
     if m.top.action="add"  then
     ?"add"
        m.top.functionName = "add"
     else
        if m.top.mediaType="list" then
            ?"list"
            m.top.functionName="list"
        end if
     end if       
    end function
    
    
    sub add()
    ?"add init"
        m.simpleTask = CreateObject("roSGNode", "tskGetToken")
        m.simpleTask.user = "FAB"
        m.simpleTask.password = "1234"
        m.simpleTask.ObserveField("index", addToFav)
        m.simpleTask.control = "RUN"
    end sub
   
    sub addToFav()
        token = m.simpleTask.token
        'url = 
        'result = CallApi(url)
    end sub
    
    sub list()
    ?"list init"
      
        
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
    
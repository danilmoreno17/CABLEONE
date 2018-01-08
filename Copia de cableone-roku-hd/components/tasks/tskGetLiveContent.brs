sub init()
        ?"TASK INIT"
         
        m.top.domain    = "213.244.195.170"
        m.top.url       = "/metadata/delivery/CMS4X/btv/services?"
        m.top.device    = Chr(34) + "deviceType" + Chr(34) + ":"  + Chr(34) + "Browser" + Chr(34)  
       
    end sub
    
    function setFunctionName()
     m.top.functionName = "getProgrammes"
    
    end function
    
    
    sub getProgrammes()
    ?"getProgrammes init"
               arreglo = []
        'Fields
        device = m.top.device
        content = createObject("roSGNode", "ContentNode")'Nodo principal
        content.TITLE = m.top.mediaType
        
        filter = "filter={" +  device   +"}"              
        url = m.top.protocol + m.top.domain + m.top.url + filter +   "&limit=10"         
                
        ?"CONSULTANDO: " + url
        nagra = CallApi(url)
        
        for each service in nagra.services
            nodeService = content.createChild("ContentNode")
            nodeService.title = service.editorial.title
            content.HDPosterUrl = service.editorial.PromoImages[0]
            content.SDPosterUrl = service.editorial.PromoImages[0]
            
            url = m.top.protocol + m.top.domain + "/metadata/delivery/CMS4X/btv/programmes?filter={" + chr(34) + "serviceRef" + chr(34) + ":" + chr(34) + service.editorial.id + chr(34) + "}"
            nagra = CallApi(url)
            for each programme in nagra.programmes
                nodeProgramme = nodeService.createChild("contentProgrammes")
                nodeProgramme.HDPosterUrl = programme.PromoImages[0]
                nodeProgramme.SDPosterUrl = programme.PromoImages[0]
                nodeProgramme.posterUrl = programme.PromoImages[0]
                nodeProgramme.labelTitle = programme.Title
                nodeProgramme.labelDescription = programme.Synopsis
                'TODO agrega horario al programa
                'nodeProgramme.labelSchedule
                nodeProgramme.Stream = service.technical.NetworkLocation
               nodeProgramme.streamUrl = service.technical.NetworkLocation
            end for
             
 
        end for
        
        
        
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
    
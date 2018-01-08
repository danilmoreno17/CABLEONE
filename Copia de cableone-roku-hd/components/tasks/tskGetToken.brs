    sub init()
        ?"TASK INIT"
         m.top.functionName="getToken"
          
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
    
    sub getToken()
    ?"getToken init" 
    
        url = m.top.url + "arg0=" + m.top.user + "&amp;arg1=" + m.top.password
        result = CallApi(url)          
        m.top.token = arreglo.token
        stop
        m.top.index=1
 
    end sub
   
   
# EndsMeet
Develop web application with MVC framework in B4X using B4J IDE

<img src="https://github.com/pyhoon/EndsMeet/blob/main/Preview/01.png?raw=true" width="330" /><img src="https://github.com/pyhoon/EndsMeet/blob/main/Preview/02.png?raw=true" width="330" /><img src="https://github.com/pyhoon/EndsMeet/blob/main/Preview/03.png?raw=true" width="330" />

# Example using HTMX

IndexView:
```basic
Public Sub Render
    Dim strHtml As String = $"<center>   
        <button hx-put="/demo/messages" style="padding: 10px">
            Put To Messages
        </button>
        <p>
        <input type="text" name="q"
        hx-get="/demo/trigger_delay"
        hx-trigger="keyup changed delay:500ms"
        hx-target="#search-results"
        placeholder="Search...">
        <div id="search-results" style="margin-top: 60px">No result</div>
        </p>
        </center>
        
        <script src="https://unpkg.com/htmx.org@2.0.0" integrity="sha384-wS5l5IKJBvK6sPTKa2WZ1js3d947pvWXbPJ1OmWfEuxLgeHcEbjUUA5i9V5ZkpCw" crossorigin="anonymous"></script>
        "$
    EndsMeetUtils.ReturnHtml(strHtml, Response)
End Sub
```

WebHandler:
```basic
Dim Controller As String = RequestMap.Get("Controller")
Select Controller
    Case "hello"
        Dim Hello As HelloController
        Hello.Initialize(Request, Response)
        Hello.RouteWeb
        Return
    Case "messages"
        DateTime.DateFormat = "dd/MM/yyyy HH:mm:ssa"
        Response.Write(DateTime.Date(DateTime.Now))
        Return
    Case "trigger_delay"
        Dim q As String = Request.GetParameter("q")
        If q = "" Then
            Response.Write("No result")
        Else
            Response.Write(q)
        End If
        Return
End Select
```

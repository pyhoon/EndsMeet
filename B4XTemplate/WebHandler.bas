B4J=true
Group=App\Handlers
ModulesStructureVersion=1
Type=Class
Version=9.8
@EndOfDesignText@
Sub Class_Globals
	Private Request As ServletRequest
	Private Response As ServletResponse
End Sub

Public Sub Initialize

End Sub

Sub Handle (req As ServletRequest, resp As ServletResponse)
	Request = req
	Response = resp
	ProcessRequest
End Sub

Private Sub ProcessRequest
	Log($"[${Request.Method}] ${Request.RequestURI}"$)	
	If EndsMeetUtils.isWebRequest(Request.RequestURI, Main.BaseElements) = False Then
		Response.SendError(400, "Bad Request")
		Return
	End If
	
	Dim RequestMap As Map = EndsMeetUtils.GetRequestElements(Request.RequestURI, Main.BaseElements)
	Dim Path As String = RequestMap.Get("Path")
	If Path.EqualsIgnoreCase(Main.BaseElements.Path.Element) = False Then
		Response.SendError(400, "Bad Request")
		Return
	End If
	
	Select RequestMap.Size
		Case 1 ' root
			Log(RequestMap)
		Case 2 ' path (demo)
			Dim Index As IndexView
			Index.Initialize(Request, Response)
			Index.Render
			Return
		Case Else
			Dim Controller As String = RequestMap.Get("Controller")
			Select Controller
				Case "hello"
					Dim Hello As HelloController
					Hello.Initialize(Request, Response)
					Hello.RouteWeb
					Return
			End Select
	End Select
	Response.SendError(400, "Bad Request")
End Sub
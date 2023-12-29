B4J=true
Group=App\Handlers
ModulesStructureVersion=1
Type=Class
Version=9.8
@EndOfDesignText@
Sub Class_Globals
	Private Request As ServletRequest
	Private Response As ServletResponse
	Private HRM As HttpResponseMessage
End Sub

Public Sub Initialize
	HRM.Initialize
	HRM.SimpleResponse = Main.SimpleResponse
End Sub

Sub Handle (req As ServletRequest, resp As ServletResponse)
	Request = req
	Response = resp
	ProcessRequest
End Sub

Private Sub ProcessRequest
	Log($"[${Request.Method}] ${Request.RequestURI}"$)
	If EndsMeetUtils.isApiRequest(Request.RequestURI, Main.BaseElements) = False Then
		EndsMeetUtils.ReturnBadRequest(HRM, Response)
		Return
	End If
	
	Dim RequestMap As Map = EndsMeetUtils.GetRequestElements(Request.RequestURI, Main.BaseElements)
	Dim Controller As String = RequestMap.Get("Controller")
	Select Controller
		Case "hello"
			Dim Hello As HelloController
			Hello.Initialize(Request, Response)
			Hello.RouteApi
			Return
	End Select
	EndsMeetUtils.ReturnBadRequest(HRM, Response)
End Sub
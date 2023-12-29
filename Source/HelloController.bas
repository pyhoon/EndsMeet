B4J=true
Group=Controllers
ModulesStructureVersion=1
Type=Class
Version=10
@EndOfDesignText@
Sub Class_Globals
	Private Request As ServletRequest 'ignore
	Private Response As ServletResponse
	Private HRM As HttpResponseMessage
	Private Model As HelloModel
	Private View As HelloView
End Sub

Public Sub Initialize (req As ServletRequest, resp As ServletResponse)
	Request = req
	Response = resp
	HRM.Initialize
	HRM.SimpleResponse = Main.SimpleResponse
	Model.Initialize(Request, Response)
	View.Initialize(Request, Response)
End Sub

Public Sub RouteWeb
	Model.Name = "Hello EndsMeet!"
	View.Render(Model)
End Sub

Public Sub RouteApi
	Select Request.Method
		Case "GET"
			GetJSON
		Case Else
			Log("Unsupported method: " & Request.Method)
			EndsMeetUtils.ReturnMethodNotAllow(HRM, Response)
	End Select
End Sub

Private Sub GetJSON
	#region Documentation
	' #Version = v1
	' #Desc = Return items
	#End region
	Model.Name = "Hello EndsMeet API!"
	Model.ReturnJsonApi
End Sub
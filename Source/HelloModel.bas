B4J=true
Group=Models
ModulesStructureVersion=1
Type=Class
Version=10
@EndOfDesignText@
Sub Class_Globals
	Private Request As ServletRequest 'ignore
	Private Response As ServletResponse
	Private HRM As HttpResponseMessage
	Private gName As String
	Private Items As List = Array("Item 1", "Item 2", "Item 3", "Item 4")
End Sub

Public Sub Initialize (req As ServletRequest, resp As ServletResponse)
	Request = req
	Response = resp
	HRM.Initialize
	HRM.SimpleResponse = Main.SimpleResponse
End Sub

Public Sub getName As String
	Return gName
End Sub

Public Sub setName (mName As String)
	gName = mName
End Sub

Public Sub ReturnJsonApi
	Dim m1 As Map
	m1.Initialize
	m1.Put("name", getName)
	m1.Put("items", Items)
	HRM.ResponseObject = m1
	EndsMeetUtils.ReturnHttpResponse(HRM, Response)
End Sub
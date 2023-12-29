B4J=true
Group=Views
ModulesStructureVersion=1
Type=Class
Version=10
@EndOfDesignText@
Sub Class_Globals
	'Private Request As ServletRequest
	Private Response As ServletResponse
End Sub

Public Sub Initialize (req As ServletRequest, resp As ServletResponse)
	'Request = req
	Response = resp
End Sub

Public Sub Render
	Dim strHtml As String = $"<center>
		<a href="${Main.ROOT_PATH}hello">Go to Hello page</a><br/>
		<p><a href="${Main.ROOT_PATH}api/v1/hello">Get Hello API</a></p>
		</center>"$
	EndsMeetUtils.ReturnHtml(strHtml, Response)
End Sub
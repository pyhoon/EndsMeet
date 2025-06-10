B4J=true
Group=Filters
ModulesStructureVersion=1
Type=Class
Version=10.2
@EndOfDesignText@
'Https Filter class
Sub Class_Globals

End Sub

Public Sub Initialize
	
End Sub

'Return True to allow the request to proceed.
Public Sub Filter (req As ServletRequest, resp As ServletResponse) As Boolean
	If req.Secure Then
		Return True
	Else
		Dim app As EndsMeet = Main.app
		resp.SendRedirect(req.FullRequestURI.Replace("http:", "https:") _
       .Replace(app.Port, app.SslPort))
		Return False
	End If
End Sub
B4J=true
Group=Filters
ModulesStructureVersion=1
Type=Class
Version=10.2
@EndOfDesignText@
' Https Filter
' Version 4.00
Sub Class_Globals

End Sub

Public Sub Initialize
	
End Sub

'Return True to allow the request to proceed.
Public Sub Filter (req As ServletRequest, resp As ServletResponse) As Boolean
	If req.Secure Then
		Return True
	Else
		Dim Location As String = req.FullRequestURI
		Location = Location.Replace("http:", "https:")
		Location = Location.Replace(Main.App.Port, Main.App.ssl.Port)
		resp.SendRedirect(Location)
		Return False
	End If
End Sub
B4J=true
Group=Handlers
ModulesStructureVersion=1
Type=Class
Version=10.2
@EndOfDesignText@
Sub Class_Globals

End Sub

Public Sub Initialize
	
End Sub

Sub Handle (req As ServletRequest, resp As ServletResponse)
	resp.Write($"<title>Inti</title>
	<h1>Hello B4X!</h1>"$)
End Sub
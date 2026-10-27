B4J=true
Group=Filters
ModulesStructureVersion=1
Type=Class
Version=10.7
@EndOfDesignText@
' Cors Filter
' Version 4.02
Sub Class_Globals

End Sub

Public Sub Initialize

End Sub

' This filter acts as a normal handler to inject CORS response headers
'<code>resp.SetHeader("Access-Control-Allow-Origin", "*")</code>
'<code>resp.SetHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS, PUT, DELETE")</code>
'<code>resp.SetHeader("Access-Control-Allow-Headers", "Content-Type, Authorization, X-Requested-With")</code>
Public Sub Filter (req As ServletRequest, resp As ServletResponse) As Boolean
	If Main.App.cors.IsInitialized Then
		If Main.App.cors.AllowedOrigin <> "" Then resp.SetHeader("Access-Control-Allow-Origin", Main.App.cors.AllowedOrigin)
		If Main.App.cors.AllowedMethods <> "" Then resp.SetHeader("Access-Control-Allow-Methods", Main.App.cors.AllowedMethods)
		If Main.App.cors.AllowedHeaders <> "" Then resp.SetHeader("Access-Control-Allow-Headers", Main.App.cors.AllowedHeaders)
	End If
    
	' If it's a preflight request, respond immediately with 200 OK and stop the chain
	If req.Method.ToUpperCase = "OPTIONS" Then
		resp.Status = 200
		Return False
	End If
    
	Return True ' Continue processing the request chain
End Sub
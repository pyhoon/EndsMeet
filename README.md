# EndsMeet
Quick Example:
```basic
Sub Process_Globals
	Public App As EndsMeet
End Sub

' <link>Open in browser|http://127.0.0.1:8080</link>
Sub AppStart (Args() As String)
	App.Initialize
	App.LoadConfig
	App.LoadDotEnv	
	App.Get("", "Index")
	App.Start
	StartMessageLoop
End Sub
```

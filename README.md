# EndsMeet
Create a server app with 3 lines of code:
```basic
Sub Process_Globals
	Public app As EndsMeet
End Sub

' <link>Open in browser|http://127.0.0.1:8080</link>
Sub AppStart (Args() As String)
	app.Initialize
	app.Route("", "Index")
	app.Start
	StartMessageLoop
End Sub
```

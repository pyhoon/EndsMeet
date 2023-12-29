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

Public Sub Render (model As HelloModel)
	Dim strHTML As String = $"<center>
	<h1>${model.Name}</h1>
	<p id="counter">0</p>
	<button onclick="increment()">Click Me</button>
	<br/><br/>
	<button onclick="history.back()">Go Back</button>
	</center>"$
	Dim strJavaScript As String = $"<script>
	const counter = document.getElementById("counter")
	let value = 0
	
	function increment() {
		value = value + 1
		counter.innerHTML = value
	}
	</script>"$
	strHTML = strHTML & strJavaScript
	EndsMeetUtils.ReturnHtml(strHTML, Response)
End Sub
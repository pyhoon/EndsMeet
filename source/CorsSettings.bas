B4J=true
Group=Classes
ModulesStructureVersion=1
Type=Class
Version=10.7
@EndOfDesignText@
' Cors Settings
' Version 4.01
Sub Class_Globals
	Private mEnabled As Boolean
	Private mSingleThread As Boolean
	Private mAllowedOrigin As String
	Private mAllowedMethods As String
	Private mAllowedHeaders As String
End Sub

Public Sub Initialize
	
End Sub

'<code>App.cors.Enabled = True</code>
Public Sub getEnabled As Boolean
	Return mEnabled
End Sub

Public Sub setEnabled (Value As Boolean)
	mEnabled = Value
End Sub

'Add CorsFilter as single thread
'<code>App.cors.SingleThread = False</code>
Public Sub getSingleThread As Boolean
	Return mSingleThread
End Sub

Public Sub setSingleThread (Value As Boolean)
	mSingleThread = Value
End Sub

'Set Access-Control-Allow-Origin for CORS
'<code>resp.SetHeader("Access-Control-Allow-Origin", "*")</code>
Public Sub getAllowedOrigin As String
	Return mAllowedOrigin
End Sub

Public Sub setAllowedOrigin (Origin As String)
	mAllowedOrigin = Origin
End Sub

'Set Access-Control-Allow-Methods for CORS
'<code>resp.SetHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS, PUT, DELETE")</code>
Public Sub getAllowedMethods As String
	Return mAllowedMethods
End Sub

Public Sub setAllowedMethods (Methods As String)
	mAllowedMethods = Methods
End Sub

'Set Access-Control-Allow-Headers for CORS
'<code>resp.SetHeader("Access-Control-Allow-Headers", "Content-Type, Authorization, X-Requested-With")</code>
Public Sub getAllowedHeaders As String
	Return mAllowedHeaders
End Sub

Public Sub setAllowedHeaders (Headers As String)
	mAllowedHeaders = Headers
End Sub
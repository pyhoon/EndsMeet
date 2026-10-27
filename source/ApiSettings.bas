B4J=true
Group=Classes
ModulesStructureVersion=1
Type=Class
Version=10.7
@EndOfDesignText@
' Api Settings
' Version 4.00
Sub Class_Globals
	Private mName As String
	Private mEnableHelp As Boolean
	Private mVerboseMode As Boolean
	Private mVersioning As Boolean
	Private mPayloadType As String
	Private mContentType As String
End Sub

Public Sub Initialize
	mName = "api"
	mEnableHelp = False
	mVerboseMode = True
	mVersioning = False
	mPayloadType = "application/json"
	mContentType = "application/json"
End Sub

'<code>App.api.Name = "api"</code>
Public Sub getName As String
	Return mName
End Sub

Public Sub setName (Folder As String)
	mName = Folder
End Sub

'<code>App.api.EnableHelp = True</code>
Public Sub getEnableHelp As Boolean
	Return mEnableHelp
End Sub

Public Sub setEnableHelp (Value As Boolean)
	mEnableHelp = Value
End Sub

'<code>App.api.VerboseMode = True</code>
Public Sub getVerboseMode As Boolean
	Return mVerboseMode
End Sub

Public Sub setVerboseMode (Value As Boolean)
	mVerboseMode = Value
End Sub

'<code>App.api.Versioning = False</code>
Public Sub getVersioning As Boolean
	Return mVersioning
End Sub

Public Sub setVersioning (Value As Boolean)
	mVersioning = Value
End Sub

'<code>App.api.PayloadType = "application/json"</code>
Public Sub getPayloadType As String
	Return mPayloadType
End Sub

Public Sub setPayloadType (Value As String)
	mPayloadType = Value
End Sub

'<code>App.api.ContentType = "application/json"</code>
Public Sub getContentType As String
	Return mContentType
End Sub

Public Sub setContentType (Value As String)
	mContentType = Value
End Sub
B4J=true
Group=Classes
ModulesStructureVersion=1
Type=Class
Version=10.7
@EndOfDesignText@
' Ssl Settings
' Version 4.03
Sub Class_Globals
	Private mPort As String
	Private mEnabled As Boolean
	Private mShowLog As Boolean
	Private mSingleThread As Boolean
	Private mKeystoreDir As String
	Private mKeystoreFile As String
	Private mKeystorePassword As String
End Sub

Public Sub Initialize
	
End Sub

'<code>App.ssl.Enabled = True</code>
Public Sub getEnabled As Boolean
	Return mEnabled
End Sub

Public Sub setEnabled (Value As Boolean)
	mEnabled = Value
End Sub

'<code>App.ssl.ShowLog = True</code>
Public Sub getShowLog As Boolean
	Return mShowLog
End Sub

Public Sub setShowLog (Value As Boolean)
	mShowLog = Value
End Sub

'Add HttpsFilter as single thread
'<code>App.ssl.SingleThread = False</code>
Public Sub getSingleThread As Boolean
	Return mSingleThread
End Sub

Public Sub setSingleThread (Value As Boolean)
	mSingleThread = Value
End Sub

'<code>App.ssl.Port = 443</code>
Public Sub getPort As String
	Return mPort
End Sub

Public Sub setPort (Port As String)
	mPort = Port
End Sub

'<code>App.ssl.KeystoreDir = ""</code>
Public Sub getKeystoreDir As String
	Return mKeystoreDir
End Sub

Public Sub setKeystoreDir (KeystoreDir As String)
	mKeystoreDir = KeystoreDir
End Sub

'<code>App.ssl.KeystoreFile = ""</code>
Public Sub getKeystoreFile As String
	Return mKeystoreFile
End Sub

Public Sub setKeystoreFile (KeystoreFile As String)
	mKeystoreFile = KeystoreFile
End Sub

'<code>App.ssl.KeystorePassword = ""</code>
Public Sub getKeystorePassword As String
	Return mKeystorePassword
End Sub

Public Sub setKeystorePassword (Password As String)
	mKeystorePassword = Password
End Sub
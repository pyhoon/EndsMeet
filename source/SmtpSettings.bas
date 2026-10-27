B4J=true
Group=Classes
ModulesStructureVersion=1
Type=Class
Version=10.7
@EndOfDesignText@
' Smtp Settings
' Version 4.03
Sub Class_Globals
	Private mPort As String
	Private mEnabled As Boolean
	Private mShowLog As Boolean
	Private mSingleThread As Boolean
	Private mUseSsl As Boolean
	Private mUserName As String
	Private mPassword As String
	Private mServer As String
End Sub

Public Sub Initialize
	
End Sub

'<code>App.smtp.Enabled = True</code>
Public Sub getEnabled As Boolean
	Return mEnabled
End Sub

Public Sub setEnabled (Value As Boolean)
	mEnabled = Value
End Sub

'<code>App.smtp.ShowLog = True</code>
Public Sub getShowLog As Boolean
	Return mShowLog
End Sub

Public Sub setShowLog (Value As Boolean)
	mShowLog = Value
End Sub

'Add HttpsFilter as single thread
'<code>App.smtp.SingleThread = False</code>
Public Sub getSingleThread As Boolean
	Return mSingleThread
End Sub

Public Sub setSingleThread (Value As Boolean)
	mSingleThread = Value
End Sub

'<code>App.smtp.UseSsl = True</code>
Public Sub getUseSsl As Boolean
	Return mUseSsl
End Sub

Public Sub setUseSsl (Value As Boolean)
	mUseSsl = Value
End Sub

'<code>App.smtp.Port = 465</code>
Public Sub getPort As String
	Return mPort
End Sub

Public Sub setPort (Port As String)
	mPort = Port
End Sub

'<code>App.smtp.mUserName = "yourname@gmail.com"</code>
Public Sub getUserName As String
	Return mUserName
End Sub

Public Sub setUserName (UserName As String)
	mUserName = UserName
End Sub

'<code>App.smtp.Password = "16-character-Google-App-Password"</code>
Public Sub getPassword As String
	Return mPassword
End Sub

Public Sub setPassword (Password As String)
	mPassword = Password
End Sub

'<code>App.smtp.Server = "smtp.google.com"</code>
Public Sub getServer As String
	Return mServer
End Sub

Public Sub setServer (Password As String)
	mServer = Password
End Sub
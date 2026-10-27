B4J=true
Group=Classes
ModulesStructureVersion=1
Type=Class
Version=10.3
@EndOfDesignText@
' Product:  EndsMeet
' Version:  4.02
' License:  MIT License
' Author:   Poon Yip Hoon (Aeric)
' GitHub:   https://github.com/pyhoon/EndsMeet
' Donation: PayPal (https://paypal.me/aeric80/)
Sub Class_Globals
	Public ctx 						As Map
	Public env 						As Map
	Public srvr 					As Server
	Public api 						As ApiSettings
	Public ssl 						As SslSettings
	Public cors 					As CorsSettings
	Public smtp 					As SmtpSettings
	Public staticfiles 				As StaticFilesSettings
	Public routes					As List
	Private mVersion				As String
	Private mRootUrl 				As String
	Private mRootPath 				As String
	Private mServerUrl 				As String
	Private mConfigFile				As String
	Private mStartupMessage			As String
	Private mHidePort				As Boolean
	Private mRemoveUnusedConfig		As Boolean
	Private Const COLOR_RED 		As Int = 0xFFFF0000
	Private Const COLOR_BLUE 		As Int = 0xFF0000FF
	Type Route (Method As String, Path As String, Class As String)
End Sub

Public Sub Initialize
	api.Initialize
	ctx.Initialize
	ssl.Initialize
	cors.Initialize
	smtp.Initialize
	routes.Initialize
	staticfiles.Initialize
	srvr.Initialize("")
	mVersion = "4.02"
	mConfigFile = "config.ini"
	mRootUrl = "http://127.0.0.1"
	mRemoveUnusedConfig = True
	ApplyConfig
	LoadDotEnv
End Sub

'<code>App.AssetsFolder = File.Combine(File.DirApp, "assets")</code>
' Default "www" inside File.DirApp
Public Sub getAssetsFolder As String
	Return staticfiles.AssetsFolder
End Sub

Public Sub setAssetsFolder (Folder As String)
	staticfiles.AssetsFolder = Folder
	srvr.StaticFilesFolder = staticfiles.AssetsFolder
End Sub

Public Sub getAssetsFolderBrowsable As Boolean
	Return staticfiles.Options.GetDefault("dirAllowed", False)
End Sub

Public Sub setAssetsFolderBrowsable (Allowed As Boolean)
	staticfiles.Options = CreateMap("dirAllowed": Allowed)
	srvr.SetStaticFilesOptions(staticfiles.Options)
End Sub

' Add path and class which allows GET method 
Public Sub Get (Path As String, Class As String)
	AddRouteIfNotAvailable("GET", Path, Class)
End Sub

' Add path and class which allows POST method 
Public Sub Post (Path As String, Class As String)
	AddRouteIfNotAvailable("POST", Path, Class)
End Sub

' Add path and class which allows PUT method 
Public Sub Put (Path As String, Class As String)
	AddRouteIfNotAvailable("PUT", Path, Class)
End Sub

' Add path and class which allows PATCH method 
Public Sub Patch (Path As String, Class As String)
	AddRouteIfNotAvailable("PATCH", Path, Class)
End Sub

' Add path and class which allows DELETE method 
Public Sub Delete (Path As String, Class As String)
	AddRouteIfNotAvailable("DELETE", Path, Class)
End Sub

' Add path and class for RESTful methods (GET, POST, PUT, DELETE)
Public Sub Rest (Path As String, Class As String)
	For Each Method As String In Array As String("GET", "POST", "PUT", "PATCH", "DELETE")
		AddRouteIfNotAvailable(Method, Path, Class)
	Next
End Sub

' Add path and class for the list of methods
Public Sub Route (Path As String, Class As String, Methods As List)
	For Each Method As String In Methods
		AddRouteIfNotAvailable(Method, Path, Class)
	Next
End Sub

Private Sub AddRouteIfNotAvailable (Method As String, Path As String, Class As String)
	If RouteAdded("ANY", Path, Class) = False Then
		srvr.AddHandler(Path, Class, False)
	'Else
	'	LogColor($"Already added: ${Path} (${Method})"$, COLOR_RED)
	End If
	If RouteAdded(Method, Path, Class) = False Then
		routes.Add(CreateRoute(Method, Path, Class))
	End If
End Sub

' Checks route is added for a specific method
' Method: specify ANY to ignore
Private Sub RouteAdded (Method As String, Path As String, Class As String) As Boolean
	For Each rt As Route In routes
		If Method.ToUpperCase = "ANY" Then ' Already added for at least one method
			If rt.Path.EqualsIgnoreCase(Path) And _
				rt.Class.EqualsIgnoreCase(Class) Then
				Return True
			End If
		Else
			If rt.Path.EqualsIgnoreCase(Path) And _
				rt.Class.EqualsIgnoreCase(Class) And _
				rt.Method.EqualsIgnoreCase(Method) Then
				Return True
			End If
		End If
	Next
	Return False
End Sub

' Check http method allowed for the given path and class name
Public Sub MethodAvailable (Method As String, Path As String, Class As String) As Boolean
	For Each rt As Route In routes
		If rt.Method.EqualsIgnoreCase(Method) And _
			rt.Class.EqualsIgnoreCase(Class) Then
			If rt.Path.Contains("/*") Then
				Dim TrimmedPath As String = rt.Path.SubString2(0, rt.Path.IndexOf("/*"))
				If Path.StartsWith(TrimmedPath) Then
					Return True
				End If
			Else
				If rt.Path.EqualsIgnoreCase(Path) Then
					Return True
				End If
			End If
		End If
	Next
	Return False
End Sub

' Check http method allowed for the given path and class object (e.g by passing Me as Class)
Public Sub MethodAvailable2 (Method As String, Path As String, Class As Object) As Boolean
	Dim jo As JavaObject
	jo.InitializeStatic("anywheresoftware.b4a.BA")
	Dim PackageName As String = jo.GetField("packageName")
	Dim Handler As String = GetType(Class).Replace(PackageName & ".", "")
	Return MethodAvailable(Method, Path, Handler)
End Sub

' Load and apply settings from .env file in assets
' SSL: SSL_PORT, SSL_ENABLED, SSL_KEYSTORE_DIR, SSL_KEYSTORE_FILE, SSL_KEYSTORE_PASSWORD
' SMTP: SMTP_PORT, SMTP_ENABLED, SMTP_USESSL, SMTP_SERVER, SMTP_USERNAME, SMTP_PASSWORD
Private Sub LoadDotEnv
	Try
		env = File.ReadMap(File.DirAssets, ".env")
		If env.ContainsKey("SSL_PORT") Then ssl.Port = env.Get("SSL_PORT")
		If env.ContainsKey("SSL_ENABLED") Then ssl.Enabled = env.Get("SSL_ENABLED").As(String).EqualsIgnoreCase("True")
		If env.ContainsKey("SSL_KEYSTORE_DIR") Then ssl.KeystoreDir = env.Get("SSL_KEYSTORE_DIR")
		If env.ContainsKey("SSL_KEYSTORE_FILE") Then ssl.KeystoreFile = env.Get("SSL_KEYSTORE_FILE")
		If env.ContainsKey("SSL_KEYSTORE_PASSWORD") Then ssl.KeystorePassword = env.Get("SSL_KEYSTORE_PASSWORD")
		If env.ContainsKey("SMTP_PORT") Then smtp.Port = env.Get("SMTP_PORT")
		If env.ContainsKey("SMTP_ENABLED") Then smtp.Enabled = env.Get("SMTP_ENABLED").As(String).EqualsIgnoreCase("True")
		If env.ContainsKey("SMTP_USESSL") Then smtp.UseSsl = env.Get("SMTP_USESSL").As(String).EqualsIgnoreCase("True")
		If env.ContainsKey("SMTP_SERVER") Then smtp.Server = env.Get("SMTP_SERVER")
		If env.ContainsKey("SMTP_USERNAME") Then smtp.UserName = env.Get("SMTP_USERNAME")
		If env.ContainsKey("SMTP_PASSWORD") Then smtp.Password = env.Get("SMTP_PASSWORD")
	Catch
		File.WriteString(File.DirAssets, ".env", "")
	End Try
End Sub

' Load and apply settings from config file
' Server: PORT, ROOT_URL, ROOT_PATH, HIDE_PORT
' Api: API_NAME, API_VERSIONING, API_VERBOSE_MODE
Public Sub ApplyConfig
	If File.Exists(File.DirApp, mConfigFile) Then
		ctx = File.ReadMap(File.DirApp, mConfigFile)
		If ctx.ContainsKey("PORT") Then srvr.Port = ctx.Get("PORT")
		If ctx.ContainsKey("ROOT_URL") Then mRootUrl = ctx.Get("ROOT_URL")
		If ctx.ContainsKey("ROOT_PATH") Then mRootPath = ctx.Get("ROOT_PATH")
		If ctx.ContainsKey("HIDE_PORT") Then mHidePort = ctx.Get("HIDE_PORT").As(String).EqualsIgnoreCase("True")
		If ctx.ContainsKey("API_NAME") Then api.Name = ctx.Get("API_NAME")
		If ctx.ContainsKey("API_VERSIONING") Then api.Versioning = ctx.Get("API_VERSIONING").As(String).EqualsIgnoreCase("True")
		If ctx.ContainsKey("API_VERBOSE_MODE") Then api.VerboseMode = ctx.Get("API_VERBOSE_MODE").As(String).EqualsIgnoreCase("True")
	End If
End Sub

' Starts the server
Public Sub Start
	' Remove unused keys
	If mRemoveUnusedConfig Then
		ctx.Remove("PORT")
		ctx.Remove("HIDE_PORT")
		ctx.Remove("API_NAME")
		ctx.Remove("API_VERSIONING")
		ctx.Remove("API_VERBOSE_MODE")
	End If
	' Update useful keys
	ctx.Put("ROOT_URL", mRootUrl)
	ctx.Put("ROOT_PATH", mRootPath)	
	If ssl.Enabled Then
		If ssl.KeystoreFile = "" Then
			ssl.Enabled = False
			If ssl.ShowLog Then	LogColor("Ssl KeystoreFile is not set", COLOR_RED)
		Else
			If ssl.KeystoreDir = "" Then
				ssl.KeystoreDir = File.DirApp
			End If
			If File.Exists(ssl.KeystoreDir, ssl.KeystoreFile) = False Then
				ssl.Enabled = False
				If ssl.ShowLog Then	LogColor("Ssl KeystoreFile is not found", COLOR_RED)
			Else
				Dim sc As SslConfiguration
				sc.Initialize
				sc.SetKeyStorePath(ssl.KeystoreDir, ssl.KeystoreFile)
				sc.KeyStorePassword = ssl.KeystorePassword
				srvr.SetSslConfiguration(sc, ssl.Port)
			End If
		End If
		If ssl.ShowLog Then LogColor("SSL is " & IIf(ssl.Enabled, "enabled", "disabled"), COLOR_BLUE)
		' Add filter to redirect all traffic from http to https (optional)
		srvr.AddFilter("/*", "HttpsFilter", ssl.SingleThread)
		mRootUrl = mRootUrl.Replace("http:", "https:")
		mServerUrl = mRootUrl
		If ssl.Port <> 443 And mHidePort = False Then
			mServerUrl = mRootUrl & ":" & ssl.Port
		End If
	Else
		mServerUrl = mRootUrl
		If srvr.Port <> 80 And mHidePort = False Then
			mServerUrl = mServerUrl & ":" & srvr.Port
		End If
	End If
	If mRootPath <> "" Then
		If mRootPath.StartsWith("/") = False Then mRootPath = "/" & mRootPath
		If mRootPath.EndsWith("/") = True Then mRootPath = mRootPath.SubString2(0, mRootPath.Length)
		mServerUrl = mServerUrl & mRootPath
	End If
	ctx.Put("ROOT_PATH", mRootPath)
	ctx.Put("SERVER_URL", mServerUrl)
	If cors.Enabled Then
		srvr.AddFilter("/*", "CorsFilter", cors.SingleThread)
	End If
	mStartupMessage = $"EndsMeet server (version = ${mVersion}) is running on port ${srvr.Port}"$
	If ssl.Enabled Then mStartupMessage = mStartupMessage & $" (redirected to port ${ssl.Port})"$
	srvr.Start
End Sub

Public Sub getStartupMessage As String
	Return mStartupMessage
End Sub

Public Sub setStartupMessage (Message As String)
	mStartupMessage = Message
End Sub

Public Sub getVersion As String
	Return mVersion
End Sub

Public Sub getPort As Int
	Return srvr.Port
End Sub

Public Sub setPort (Port As Int)
	srvr.Port = Port
End Sub

Public Sub getRootUrl As String
	Return mRootUrl
End Sub

Public Sub setRootUrl (RootUrl As String)
	mRootUrl = RootUrl
End Sub

Public Sub getRootPath As String
	Return mRootPath
End Sub

Public Sub setRootPath (RootPath As String)
	mRootPath = RootPath
End Sub

Public Sub getServerUrl As String
	Return mServerUrl
End Sub

' Hide Port number in ServerUrl (except for 80, 443)
' Set to True if using Nginx Reverse Proxy. Default=False
Public Sub getHidePort As Boolean
	Return mHidePort
End Sub

Public Sub setHidePort (Hide As Boolean)
	mHidePort = Hide
End Sub

' Remove unused config keys in ctx
Public Sub getRemoveUnusedConfig As Boolean
	Return mRemoveUnusedConfig
End Sub

Public Sub setRemoveUnusedConfig (Enabled As Boolean)
	mRemoveUnusedConfig = Enabled
End Sub

' Set config file name
Public Sub getConfigFile As String
	Return mConfigFile
End Sub

Public Sub setConfigFile (FileName As String)
	mConfigFile = FileName
End Sub

Public Sub CreateRoute (Method As String, Path As String, Class As String) As Route
	Dim t1 As Route
	t1.Initialize
	t1.Method = Method.ToUpperCase
	t1.Path = Path
	t1.Class = Class
	Return t1
End Sub

Public Sub WriteHtml (response As ServletResponse, content As String)
	response.ContentType = "text/html"
	response.Write(content)
End Sub

Public Sub WriteHtml2 (response As ServletResponse, content As String, context As Map)
	response.ContentType = "text/html"
	response.Write(ReplaceMap(content, context))
End Sub

#Region Code from WebUtils
Public Sub EscapeHtml (Raw As String) As String
   Dim sb As StringBuilder
   sb.Initialize
   For i = 0 To Raw.Length - 1
     Dim C As Char = Raw.CharAt(i)
     Select C
       Case QUOTE
         sb.Append("&quot;")
       Case "'"
         sb.Append("&#39;")
       Case "<"
         sb.Append("&lt;")
       Case ">"
         sb.Append("&gt;")
       Case "&"
         sb.Append("&amp;")
       Case Else
         sb.Append(C)
     End Select
   Next
   Return sb.ToString
End Sub

Public Sub ReplaceMap (Base As String, Replacements As Map) As String
	Dim pattern As StringBuilder
	pattern.Initialize
	For Each k As String In Replacements.Keys
		If pattern.Length > 0 Then pattern.Append("|")
		pattern.Append("\$").Append(k).Append("\$")
	Next
	Dim m As Matcher = Regex.Matcher(pattern.ToString, Base)
	Dim result As StringBuilder
	result.Initialize
	Dim lastIndex As Int
	Do While m.Find
		result.Append(Base.SubString2(lastIndex, m.GetStart(0)))
		Dim replace As String = Replacements.Get(m.Match.SubString2(1, m.Match.Length - 1))
		If m.Match.ToLowerCase.StartsWith("$h_") Then replace = EscapeHtml(replace)
		result.Append(replace)
		lastIndex = m.GetEnd(0)
	Loop
	If lastIndex < Base.Length Then result.Append(Base.SubString(lastIndex))
	Return result.ToString
End Sub
#End Region
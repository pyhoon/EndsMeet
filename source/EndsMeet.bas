B4J=true
Group=App
ModulesStructureVersion=1
Type=Class
Version=10.2
@EndOfDesignText@
Sub Class_Globals
	Public ctx 			As Map
	Public srvr 		As Server
	Public conf 		As ServerConfigurations
	Private mMessage 	As String
	Private mPort 		As Int
	Private mSslPort 	As Int
	Private mSslEnabled As Boolean
	Private mRedirect 	As Boolean
	Private Const COLOR_RED 	As Int = -65536
	Private Const COLOR_BLUE 	As Int = -16776961
	Private Const VERSION_NAME	As String = "0.90"
End Sub

Public Sub Initialize
	srvr.Initialize("")
	InitConfig
	InitContext
	conf.Initialize
	conf.Version = VERSION_NAME
	conf.StaticFilesFolder = File.Combine(File.DirApp, "www")
	conf.Port = ctx.GetDefault("ServerPort", 8080)
	conf.SSLPort = ctx.GetDefault("SSLPort", 0)
	conf.RootUrl = ctx.GetDefault("ROOT_URL", "http://127.0.0.1")
	conf.RootPath = ctx.GetDefault("ROOT_PATH", "")
	conf.ServerUrl = conf.RootUrl
	conf.ApiName = ctx.GetDefault("API_NAME", "api")
	conf.ApiVersioning = ctx.GetDefault("API_VERSIONING", "False").As(String).EqualsIgnoreCase("True")
	conf.SslKeystoreDir = ctx.GetDefault("SSL_KEYSTORE_DIR", "")
	conf.SslKeystoreFile = ctx.GetDefault("SSL_KEYSTORE_FILE", "")
	conf.SslKeystorePassword = ctx.GetDefault("SSL_KEYSTORE_PASSWORD", "")
	Configurable
	ConfigurePort
	ConfigureStaticFiles
End Sub

Private Sub InitConfig
	If File.Exists(File.DirApp, "config.ini") = False Then
		File.Copy(File.DirAssets, "config.example", File.DirApp, "config.ini")
	End If
End Sub

Public Sub InitContext
	ctx = File.ReadMap(File.DirApp, "config.ini")
	ctx.Put("VERSION", VERSION_NAME)
End Sub

Public Sub Route (Path As String, Class As String)
	srvr.AddHandler(Path, Class, False)
End Sub

Public Sub Start
	srvr.Start
End Sub

Public Sub setMessage (Message As String)
	mMessage = Message
End Sub

Public Sub ShowLog
	If mMessage = "" Then mMessage = $"EndsMeet server (version = ${conf.Version}) is running on port ${srvr.Port}${IIf(srvr.SslPort > 0, $" (redirected to port ${srvr.SslPort})"$, "")}"$
	Log(mMessage)
End Sub

Public Sub getPort As Int
	Return mPort
End Sub

Public Sub setPort (Port As Int)
	mPort = Port
End Sub

Public Sub getSslPort As Int
	Return mSslPort
End Sub

Public Sub setSslPort (SslPort As Int)
	mSslPort = SslPort
End Sub

Public Sub getSslEnabled As Boolean
	Return mSslEnabled
End Sub

Public Sub setSslEnabled (Enabled As Boolean)
	mSslEnabled = Enabled
End Sub

Public Sub setRedirectToHttps (Enabled As Boolean)
	mRedirect = Enabled
End Sub

' Additional Configuration
Private Sub Configurable
	conf.StaticFilesBrowsable = False
End Sub

' Configure Keystore and SSL Port
Private Sub ConfigurePort
	If mPort = 0 Then
		mPort = srvr.Port
		LogColor($"Server Port is not set (default to ${mPort})"$, COLOR_RED)
	Else
		srvr.Port = mPort
	End If
	If mSslEnabled Then
		If conf.SSLPort = 0 Then
			LogColor("SSL Port is not set (SSL is disabled)", COLOR_RED)
			If conf.Port <> 80 Then
				conf.ServerUrl = conf.RootUrl & ":" & conf.Port
			End If
			If conf.RootPath <> "" Then
				If conf.RootPath.StartsWith("/") = False Then conf.RootPath = "/" & conf.RootPath
				If conf.RootPath.EndsWith("/") = True Then conf.RootPath = conf.RootPath.SubString2(0, conf.RootPath.Length)
				conf.ServerUrl = conf.ServerUrl & conf.RootPath
				ctx.Put("ROOT_PATH", conf.RootPath)
			End If
			ctx.Put("SERVER_URL", conf.ServerUrl)
			Return
		End If
		If conf.SslKeystoreDir = "" Then
			conf.SslKeystoreDir = File.DirApp
		End If
		If conf.SslKeystoreFile = "" Then
			LogColor("SslKeystoreFile is not set (SSL is disabled)", COLOR_RED)
			Return
		End If
		If File.Exists(conf.SslKeystoreDir, conf.SslKeystoreFile) = False Then
			LogColor("SslKeystoreFile is found (SSL is disabled)", COLOR_RED)
			Return
		End If
		
		Dim ssl As SslConfiguration
		ssl.Initialize
		ssl.SetKeyStorePath(conf.SslKeystoreDir, conf.SslKeystoreFile)
		ssl.KeyStorePassword = conf.SslKeystorePassword
		srvr.SetSslConfiguration(ssl, conf.SSLPort)
		If mRedirect Then
			'add filter to redirect all traffic from http to https (optional)
			srvr.AddFilter("/*", "HttpsFilter", False)
			conf.RootUrl = conf.RootUrl.Replace("http:", "https:")
		End If
		ctx.Put("ROOT_URL", conf.RootUrl)
		If conf.SSLPort <> 443 Then
			conf.ServerUrl = conf.RootUrl & ":" & conf.SSLPort
		End If
		LogColor("SSL is enabled", COLOR_BLUE)
	Else
		If conf.Port <> 80 Then
			conf.ServerUrl = conf.RootUrl & ":" & conf.Port
		End If
		LogColor("SSL is disabled", COLOR_BLUE)
	End If
	If conf.RootPath <> "" Then
		If conf.RootPath.StartsWith("/") = False Then conf.RootPath = "/" & conf.RootPath
		If conf.RootPath.EndsWith("/") = True Then conf.RootPath = conf.RootPath.SubString2(0, conf.RootPath.Length)
		ctx.Put("ROOT_PATH", conf.RootPath)
		conf.ServerUrl = conf.ServerUrl & conf.RootPath
	End If
	ctx.Put("SERVER_URL", conf.ServerUrl)
End Sub

' Configure permission for browsing static files folder
Private Sub ConfigureStaticFiles
	srvr.StaticFilesFolder = conf.StaticFilesFolder
	srvr.SetStaticFilesOptions(CreateMap("dirAllowed": conf.StaticFilesBrowsable))
End Sub
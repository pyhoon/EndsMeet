B4J=true
Group=Classes
ModulesStructureVersion=1
Type=Class
Version=10.2
@EndOfDesignText@
Sub Class_Globals
	Public ctx 						As Map
	Public srvr 					As Server
	Private mPort 					As Int
	Private mSslPort 				As Int
	Private mCorsPath				As List
	Private mCorsSettings			As Map
	Private mRootUrl 				As String
	Private mRootPath 				As String
	Private mServerUrl 				As String
	Private mApiName 				As String
	Private mMessage 				As String
	Private mVersion				As String
	Private mStaticFilesDir 		As String
	Private mSslKeystoreDir			As String
	Private mSslKeystoreFile		As String
	Private mSslKeystorePassword 	As String
	Private mRedirect 				As Boolean
	Private mLogEnabled 			As Boolean
	Private mSslEnabled 			As Boolean
	Private mCORSEnabled 			As Boolean
	Private mHelpEnabled 			As Boolean
	Private mApiVersioning 			As Boolean
	Private mUseConfigFile			As Boolean
	Private mStaticFilesBrowsable	As Boolean
	Private Const COLOR_RED 		As Int = -65536
	Private Const COLOR_BLUE 		As Int = -16776961
End Sub

Public Sub Initialize
	ctx.Initialize
	srvr.Initialize("")
	mVersion = "0.90"
	mStaticFilesDir = File.Combine(File.DirApp, "www")
End Sub

Public Sub Route (Path As String, Class As String)
	srvr.AddHandler(Path, Class, False)
End Sub

Public Sub Start
	If mUseConfigFile Then
		If File.Exists(File.DirApp, "config.ini") = False Then
			File.Copy(File.DirAssets, "config.example", File.DirApp, "config.ini")
		End If
		ctx = File.ReadMap(File.DirApp, "config.ini")
		If ctx.ContainsKey("Version") = False Then ctx.Put("Version", mVersion)
		If ctx.ContainsKey("StaticFilesFolder") = False Then ctx.Put("Version", mVersion)
		mPort = ctx.GetDefault("ServerPort", 8080)
		mSslPort = ctx.GetDefault("SSLPort", 0)
		mRootUrl = ctx.GetDefault("ROOT_URL", "http://127.0.0.1")
		mRootPath = ctx.GetDefault("ROOT_PATH", "")
		mApiName = ctx.GetDefault("API_NAME", "api")
		mApiVersioning = ctx.GetDefault("API_VERSIONING", "False").As(String).EqualsIgnoreCase("True")
		mSslKeystoreDir = ctx.GetDefault("SSL_KEYSTORE_DIR", "")
		mSslKeystoreFile = ctx.GetDefault("SSL_KEYSTORE_FILE", "")
		mSslKeystorePassword = ctx.GetDefault("SSL_KEYSTORE_PASSWORD", "")
		mServerUrl = mRootUrl
	End If
	If mPort <> 0 Then
		srvr.Port = mPort
	Else
		mPort = srvr.Port
		If mLogEnabled Then	LogColor($"Server Port is not set (default to ${mPort})"$, COLOR_RED)
	End If
	If mSslPort = 0 Then
		mSslEnabled = False
		'If mLogEnabled Then	LogColor("SSL Port is not set (SSL is disabled)", COLOR_RED)
		ctx.Put("SERVER_URL", mServerUrl)
	End If
	If mSslEnabled Then
		If mSslKeystoreFile = "" Then
			mSslEnabled = False
			If mLogEnabled Then	LogColor("SslKeystoreFile is not set (SSL is disabled)", COLOR_RED)
		Else
			If mSslKeystoreDir = "" Then
				mSslKeystoreDir = File.DirApp
			End If
			If File.Exists(mSslKeystoreDir, mSslKeystoreFile) = False Then
				mSslEnabled = False
				If mLogEnabled Then	LogColor("SslKeystoreFile is found (SSL is disabled)", COLOR_RED)
			Else
				Dim ssl As SslConfiguration
				ssl.Initialize
				ssl.SetKeyStorePath(mSslKeystoreDir, mSslKeystoreFile)
				ssl.KeyStorePassword = mSslKeystorePassword
				srvr.SetSslConfiguration(ssl, mSslPort)
				If mRedirect Then
					'add filter to redirect all traffic from http to https (optional)
					srvr.AddFilter("/*", "HttpsFilter", False)
					mRootUrl = mRootUrl.Replace("http:", "https:")
					ctx.Put("ROOT_URL", mRootUrl)
				End If
				If mPort <> 443 Then
					mServerUrl = mRootUrl & ":" & mSslPort
					ctx.Put("SERVER_URL", mServerUrl)
				End If
				If mLogEnabled Then	LogColor("SSL is enabled", COLOR_BLUE)
			End If
		End If
	Else
		If mPort <> 80 Then
			mServerUrl = mRootUrl & ":" & mPort
			ctx.Put("SERVER_URL", mServerUrl)
		End If
		If mLogEnabled Then	LogColor("SSL is disabled", COLOR_BLUE)
	End If
	If mRootPath <> "" Then
		If mRootPath.StartsWith("/") = False Then mRootPath = "/" & mRootPath
		If mRootPath.EndsWith("/") = True Then mRootPath = mRootPath.SubString2(0, mRootPath.Length)
		mServerUrl = mServerUrl & mRootPath
		ctx.Put("ROOT_PATH", mRootPath)
		ctx.Put("SERVER_URL", mServerUrl)
	End If
	If Initialized(mCorsPath) And Initialized(mCorsSettings) Then
		For Each path As String In mCorsPath
			Me.As(JavaObject).RunMethod("addFilter", Array As Object(srvr.As(JavaObject).GetField("context"), path, mCorsSettings))
		Next
		If mLogEnabled Then	LogColor("CORS is enabled", COLOR_BLUE)
	End If
	srvr.StaticFilesFolder = mStaticFilesDir
	srvr.SetStaticFilesOptions(CreateMap("dirAllowed": mStaticFilesBrowsable))
	srvr.Start
End Sub

Public Sub getMessage As String
	Return mMessage
End Sub

Public Sub setMessage (Message As String)
	mMessage = Message
End Sub

Public Sub getVersion As String
	Return mVersion
End Sub

Public Sub setVersion (Version As String)
	mVersion = Version
End Sub

Public Sub getStaticFilesFolder As String
	Return mStaticFilesDir
End Sub

Public Sub setStaticFilesFolder (StaticFilesFolder As String)
	mStaticFilesDir = StaticFilesFolder
End Sub

Public Sub getStaticFilesBrowsable As Boolean
	Return mStaticFilesBrowsable
End Sub

Public Sub setStaticFilesBrowsable (StaticFilesBrowsable As Boolean)
	mStaticFilesBrowsable = StaticFilesBrowsable
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

Public Sub getRootPath As String
	Return mRootPath
End Sub

Public Sub setRootPath (RootPath As String)
	mRootPath = RootPath
End Sub

Public Sub getRootUrl As String
	Return mRootUrl
End Sub

Public Sub setRootUrl (RootUrl As String)
	mRootUrl = RootUrl
End Sub

Public Sub getServerUrl As String
	Return mServerUrl
End Sub

Public Sub getCorsPath As List
	Return mCorsPath
End Sub

Public Sub setCorsPath (CorsPath As List)
	mCorsPath = CorsPath
End Sub

Public Sub getCorsSettings As Map
	Return mCorsSettings
End Sub

' Sample settings: <code>
' CreateMap( _
' "allowedOrigins": "*", _
' "allowedHeaders": "*", _
' "allowedMethods": "POST,PUT,DELETE", _
' "allowCredentials": "true", _
' "preflightMaxAge": 1800, _
' "chainPreflight": "false")</code>
Public Sub setCorsSettings (CorsSettings As Map)
	mCorsSettings = CorsSettings
End Sub

Public Sub getApiName As String
	Return mApiName
End Sub

Public Sub setApiName (ApiName As String)
	mApiName = ApiName
End Sub

Public Sub getApiVersioning As Boolean
	Return mApiVersioning
End Sub

Public Sub setApiVersioning (ApiVersioning As Boolean)
	mApiVersioning = ApiVersioning
End Sub

Public Sub getCORSEnabled As Boolean
	Return mCORSEnabled
End Sub

Public Sub setCORSEnabled (Enabled As Boolean)
	mCORSEnabled = Enabled
End Sub

Public Sub getHelpEnabled As Boolean
	Return mHelpEnabled
End Sub

Public Sub setHelpEnabled (Enabled As Boolean)
	mHelpEnabled = Enabled
End Sub

Public Sub getSslEnabled As Boolean
	Return mSslEnabled
End Sub

Public Sub setSslEnabled (Enabled As Boolean)
	mSslEnabled = Enabled
End Sub

Public Sub getLogEnabled As Boolean
	Return mLogEnabled
End Sub

Public Sub setLogEnabled (Enabled As Boolean)
	mLogEnabled = Enabled
End Sub

Public Sub getUseConfigFile As Boolean
	Return mUseConfigFile
End Sub

Public Sub setUseConfigFile (Enabled As Boolean)
	mUseConfigFile = Enabled
End Sub

Public Sub setRedirectToHttps (Enabled As Boolean)
	mRedirect = Enabled
End Sub

Public Sub ShowLog
	If mMessage = "" Then mMessage = $"EndsMeet server (version = ${mVersion}) is running on port ${mPort}${IIf(mSslPort > 0, $" (redirected to port ${mSslPort})"$, "")}"$
	Log(mMessage)
End Sub

#If JAVA
import java.util.EnumSet;
import java.util.HashMap;
import java.util.Map.Entry;
import jakarta.servlet.DispatcherType;
import jakarta.servlet.Filter;
import org.eclipse.jetty.servlet.ServletContextHandler;
import org.eclipse.jetty.servlet.FilterHolder;
import anywheresoftware.b4a.objects.collections.Map.MyMap;

public void addFilter (ServletContextHandler context, String path, MyMap settings) throws Exception {
    FilterHolder fh = new FilterHolder((Class<? extends Filter>) Class.forName("org.eclipse.jetty.servlets.CrossOriginFilter"));
    if (settings != null) {
        HashMap<String,String> m = new HashMap<String, String>();
        copyMyMap(settings, m, true); //integerNumbersOnly!
        fh.setInitParameters(m);
    }
    context.addFilter(fh, path, EnumSet.of(DispatcherType.REQUEST));
}

private void copyMyMap (MyMap m, java.util.Map<String, String> o, boolean integerNumbersOnly) {
    for (Entry<Object, Object> e : m.entrySet()) {
        String value;
        if (integerNumbersOnly && e.getValue() instanceof Number) {
            value = String.valueOf(((Number)e.getValue()).longValue());
        } else {
            value = String.valueOf(e.getValue());
            o.put(String.valueOf(e.getKey()), value);
        }
    }
}
#End If
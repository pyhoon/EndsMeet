B4J=true
Group=Classes
ModulesStructureVersion=1
Type=Class
Version=10.7
@EndOfDesignText@
' Static Files Settings
' Version 4.01
Sub Class_Globals
	Private mOptions As Map
	Private mAssetsFolder As String
End Sub

Public Sub Initialize
	
End Sub

'<code>App.AssetsFolder = File.Combine(File.DirApp, "assets")"</code>
Public Sub getAssetsFolder As String
	Return mAssetsFolder
End Sub

Public Sub setAssetsFolder (Folder As String)
	mAssetsFolder = Folder
End Sub

'<code>Main.App.Options = Options</code>
Public Sub getOptions As Map
	Return mOptions
End Sub

Public Sub setOptions (Options As Map)
	mOptions = Options
End Sub
B4J=true
Group=App\Classes
ModulesStructureVersion=1
Type=StaticCode
Version=10
@EndOfDesignText@
' EndsMeet Core
Sub Process_Globals
	Private const CONTENT_TYPE_JSON As String = "application/json"
	Private const CONTENT_TYPE_HTML As String = "text/html"
	Type HttpResponseMessage (ResponseCode As Int, ResponseString As String, ResponseData As List, ResponseObject As Map, ResponseMessage As String, ResponseError As Object, ResponseType As String, ContentType As String, SimpleResponse As SimpleResponse)
	Type ApiElement (Index As Int, Name As String, Element As String, Controller As Element, Versioning As Boolean)
	Type WebElement (Index As Int, Name As String, Element As String, Controller As Element)
	Type ControllerElement (Api As Element, Web As Element)
	Type Element (Index As Int, Name As String, Element As String)
	Type BaseElements (Root As Element, Path As Element, Api As ApiElement, Web As WebElement, Controller As ControllerElement, First As Element, Second As Element, Third As Element)
	Type SimpleResponse (Enable As Boolean, Format As String, DataKey As String)
End Sub

Public Sub GetRequestElements (Uri As String, BaseElements As BaseElements) As Map
	Dim Element() As String = Regex.Split("\/", Uri)
	Dim RequestElement As Map
	RequestElement.Initialize
	If Element.Length > 0 Then
		RequestElement.Put("Root", Element(0))
	End If
	If Element.Length > 1 Then
		RequestElement.Put("Path", Element(1))
	End If
	If Element.Length > 2 Then
		If Element(2).EqualsIgnoreCase(BaseElements.Api.Element) Then
			RequestElement.Put("Api", Element(2))
			If Element.Length > 3 Then
				If BaseElements.Api.Versioning Then
					RequestElement.Put("Version", Element(3))
					If Element.Length > 4 Then
						RequestElement.Put("Controller", Element(4))
						If Element.Length > 5 Then
							RequestElement.Put("First", Element(5))
							If Element.Length > 6 Then
								RequestElement.Put("Second", Element(6))
								If Element.Length > 7 Then
									RequestElement.Put("Third", Element(7))
								End If
							End If
						End If
					End If
				Else
					RequestElement.Put("Controller", Element(3))
					If Element.Length > 4 Then
						RequestElement.Put("First", Element(4))
						If Element.Length > 5 Then
							RequestElement.Put("Second", Element(5))
							If Element.Length > 6 Then
								RequestElement.Put("Third", Element(6))
							End If
						End If
					End If
				End If
			End If
		Else
			RequestElement.Put("Controller", Element(2))
			If Element.Length > 3 Then
				RequestElement.Put("First", Element(3))
				If Element.Length > 4 Then
					RequestElement.Put("Second", Element(4))
					If Element.Length > 5 Then
						RequestElement.Put("Third", Element(5))
					End If
				End If
			End If
		End If
	End If
	Return RequestElement
End Sub

Public Sub isWebRequest (Uri As String, BaseElements As BaseElements) As Boolean
	Dim UriMap As Map = GetRequestElements(Uri, BaseElements)
	Dim Path As String = UriMap.Get("Path")
	Return Path.EqualsIgnoreCase(BaseElements.Path.Element)
End Sub

Public Sub isApiRequest (Uri As String, BaseElements As BaseElements) As Boolean
	Dim UriMap As Map = GetRequestElements(Uri, BaseElements)
	Dim Path As String = UriMap.Get("Path")
	If Not(Path.EqualsIgnoreCase(BaseElements.Path.Element)) Then
		Return False
	End If
	Return UriMap.ContainsKey("Api")
End Sub

Public Sub ReturnBadRequest (mess As HttpResponseMessage, resp As ServletResponse)
	mess.ResponseCode = 400
	ReturnHttpResponse(mess, resp)
End Sub

Public Sub ReturnMethodNotAllow (mess As HttpResponseMessage, resp As ServletResponse)
	mess.ResponseCode = 405
	mess.ResponseError = "Method Not Allowed"
	ReturnHttpResponse(mess, resp)
End Sub

Public Sub ReturnHtml (str As String, resp As ServletResponse)
	resp.ContentType = CONTENT_TYPE_HTML
	resp.Write(str)
End Sub

' Remember to add the following code when initialize a Controller <code>
' HRM.Initialize
' HRM.SimpleResponse = Main.SimpleResponse</code>
Public Sub ReturnHttpResponse (mess As HttpResponseMessage, resp As ServletResponse)
	If mess.ResponseCode >= 200 And mess.ResponseCode < 300 Then ' SUCCESS
		If mess.ResponseType = "" Then mess.ResponseType = "SUCCESS"
		If mess.ResponseString = "" Then mess.ResponseString = "ok"
		If mess.ResponseMessage = "" Then mess.ResponseMessage = "Success"
		mess.ResponseError = Null
	Else ' ERROR
		If mess.ResponseCode = 0 Then mess.ResponseCode = 400
		If mess.ResponseType = "" Then mess.ResponseType = "ERROR"
		If mess.ResponseString = "" Then mess.ResponseString = "error"
		If mess.ResponseError.As(String).StartsWith("java.lang.Object") Then
			mess.ResponseError = "Bad Request"
			If mess.ResponseCode = 404 Then mess.ResponseError = "Not Found"
			If mess.ResponseCode = 405 Then mess.ResponseError = "Method Not Allowed"
			If mess.ResponseCode = 422 Then mess.ResponseError = "Unprocessable Entity"
		End If
	End If
	If mess.ContentType = "" Then mess.ContentType = CONTENT_TYPE_JSON
	resp.ContentType = mess.ContentType
	
	If mess.SimpleResponse.Enable Then
		resp.Status = mess.ResponseCode
	Else
		' Override Status Code
		If mess.ResponseCode < 200 Or mess.ResponseCode > 299 Then
			resp.Status = 200
		Else
			resp.Status = mess.ResponseCode
		End If
	End If

	If mess.SimpleResponse.Enable Then
		Select mess.SimpleResponse.Format
			Case "List"
				' force List format
				If mess.ResponseData.IsInitialized = False Then
					' Initialize an empty list
					mess.ResponseData.Initialize
					If mess.ResponseObject.IsInitialized Then
						' Add object to List
						If mess.ResponseObject.Size > 0 Then mess.ResponseData.Add(mess.ResponseObject)
					Else
						mess.ResponseObject.Initialize
					End If
				End If
				resp.Write(mess.ResponseData.As(JSON).ToString)
			Case "Map"
				' force Map format with "data" as key
				If mess.ResponseObject.IsInitialized = False Then
					' Initialize an empty map
					mess.ResponseObject.Initialize
					If mess.ResponseData.IsInitialized = False Then
						' Initialize an empty list
						mess.ResponseData.Initialize
					End If
					' Add object to Map
					If mess.SimpleResponse.DataKey = Null Then
						mess.ResponseObject.Put("data", mess.ResponseData)
					Else
						mess.ResponseObject.Put(mess.SimpleResponse.DataKey, mess.ResponseData)
					End If
				End If
				resp.Write(mess.ResponseObject.As(JSON).ToString)
			Case Else ' "Auto" or other value
				' Depends on which object is initialized
				If mess.ResponseObject.IsInitialized Then
					resp.Write(mess.ResponseObject.As(JSON).ToString)
				Else If mess.ResponseData.IsInitialized Then
					resp.Write(mess.ResponseData.As(JSON).ToString)
				Else
					' Default to an initialized List
					'mess.ResponseData.Initialize
					'resp.Write(mess.ResponseData.As(JSON).ToString)
					' or
					' Default to an initialized Map
					mess.ResponseObject.Initialize
					Select mess.ResponseType.ToUpperCase
						Case "SUCCESS"
							mess.ResponseObject.Put("message", mess.ResponseMessage)
						Case "ERROR", "FAILED"
							mess.ResponseObject.Put("error", mess.ResponseError)
					End Select
					resp.Write(mess.ResponseObject.As(JSON).ToString)
				End If
		End Select
	Else
		If Not(mess.ResponseData.IsInitialized) Then
			mess.ResponseData.Initialize
			If mess.ResponseObject.IsInitialized Then
				' Do not add an empty map
				If mess.ResponseObject.Size > 0 Then mess.ResponseData.Add(mess.ResponseObject)
			End If
		End If
		Dim Map1 As Map = CreateMap("s": mess.ResponseString, "a": mess.ResponseCode, "r": mess.ResponseData, "m": mess.ResponseMessage, "e": mess.ResponseError)
		resp.Write(Map2Json(Map1))
	End If
End Sub

Public Sub Map2Json (M As Map) As String
	Return M.As(JSON).ToString
End Sub

Public Sub ReadMapFile (FileDir As String, FileName As String) As Map
	Dim strPath As String = File.Combine(FileDir, FileName)
	Log($"Reading file (${strPath})..."$)
	Return File.ReadMap(FileDir, FileName)
End Sub

Public Sub WriteAssetFile (FileName As String, Contents As String)
	File.WriteString(File.Combine(File.DirApp, "www"), FileName, Contents)
End Sub

Public Sub DeleteAssetFile (FileName As String)
	File.Delete(File.Combine(File.DirApp, "www"), FileName)
End Sub

Public Sub AssetFileExist (FileName As String) As Boolean
	Return File.Exists(File.Combine(File.DirApp, "www"), FileName)
End Sub

Public Sub ReadTemplateFile (FileName As String) As String
	Return File.ReadString(File.Combine(File.DirApp, "templates"), FileName)
End Sub

Public Sub WriteTemplateFile (FileName As String, Contents As String)
	File.WriteString(File.Combine(File.DirApp, "templates"), FileName, Contents)
End Sub

Public Sub DeleteTemplateFile (FileName As String)
	File.Delete(File.Combine(File.DirApp, "templates"), FileName)
End Sub

Public Sub TemplateFileExist (FileName As String) As Boolean
	Return File.Exists(File.Combine(File.DirApp, "templates"), FileName)
End Sub
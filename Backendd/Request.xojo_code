#tag Class
Protected Class Request
Inherits TCPSocket
	#tag CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit)) or  (TargetIOS and (Target32Bit or Target64Bit))
	#tag Event
		Sub Connected()
		  // A connection has been made to one of the sockets.
		  // The request's data will be read, and when that's complete, the DataAvailable event will occur.
		  
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub DataAvailable()
		  // The request's data has been read and is ready for processing.
		  
		  
		  // If the app is using threads...
		  If Multithreading Then
		    
		    // Hand the request off to a RequestThread instance for processing.
		    Dim RT As New RequestThread
		    RT.Request = Self
		    RT.Run
		    
		    Return
		    
		  End If
		  
		  
		  // Process the request immediately, on the primary thread...
		  Process
		  
		  
		  
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub Error()
		  // An error  occurred when processing the request.
		  
		  
		  System.DebugLog "Socket " + SocketID.totext + " Error: " + LastErrorCode.ToText
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub SendComplete(userAborted as Boolean)
		  // The response has been sent back to the client.
		  
		  
		  // Close the socket.
		  Close
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub Constructor(ID As Integer, Multithreading As Boolean)
		  // Set the Socket's ID.
		  SocketID = ID
		  
		  // Set the Multithreading property.
		  Self.Multithreading = Multithreading
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub CookiesDictionaryCreate()
		  // Creates a dictionary representing the request cookies.
		  // The cookies are delivered as a request header, like this:
		  // Cookie: x=12; y=124
		  
		  
		  // Create the dictionary.
		  Cookies = New Xojo.Core.Dictionary
		  
		  // If no cookies were sent...
		  If Headers.HasKey("Cookie") = False Then
		    Return
		  End If
		  
		  // Get the cookie header value as a string.
		  Dim CookiesRaw As String = Headers.Value("Cookie")
		  
		  // Create an array of cookies.
		  Dim CookiesRawArray() As String = CookiesRaw.Split("; ")
		  
		  // Loop over the cookies...
		  For i As Integer = 0 To CookiesRawArray.Ubound
		    Dim ThisCookie As String = CookiesRawArray(i)
		    Dim Key As String = Backendd.URLDecode(ThisCookie.NthField("=", 1))
		    Dim Value As String = Backendd.URLDecode(ThisCookie.NthField("=", 2))
		    Cookies.Value(Key) = Value
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DataGet()
		  // Gets the request data.
		  
		  
		  Data = Data.DefineEncoding(Encodings.UTF8)
		  Data = ReadAll
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DataSplit()
		  // Splits the data to get the headers and body (Body).
		  
		  
		  Dim RequestParts() As String = Data.Split(EndOfLine.Windows + EndOfLine.Windows)
		  
		  HeadersRaw = RequestParts(0)
		  
		  If RequestParts.Ubound > 0 Then
		    Body = RequestParts(1)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Dump() As String
		  Dim HTML As String
		  
		  HTML = HTML + "<p>Method: " + Method + "</p>" + EndOfLine.Windows
		  HTML = HTML + "<p>Path: " + Path + "</p>" + EndOfLine.Windows
		  
		  HTML = HTML + "<p>Path Components: " + EndOfLine.Windows
		  HTML = HTML + "<ul>" + EndOfLine.Windows
		  If PathComponents.Ubound > -1 Then
		    For i As Integer = 0 to PathComponents.Ubound
		      HTML = HTML + "<li>" + i.ToText + ". " + PathComponents(i) + "</li>"+ EndOfLine.Windows
		    Next
		  Else
		    HTML = HTML + "<li>None</li>"+ EndOfLine.Windows
		  End If
		  HTML = HTML + "</ul>" + EndOfLine.Windows
		  HTML = HTML + "</p>" + EndOfLine.Windows
		  
		  HTML = HTML + "<p>HTTP Version: " + HTTPVersion + "</p>" + EndOfLine.Windows
		  HTML = HTML + "<p>Remote Address: " + RemoteAddress + "</p>" + EndOfLine.Windows
		  HTML = HTML + "<p>Socket ID: " + SocketID.ToText + "</p>" + EndOfLine.Windows
		  
		  HTML = HTML + "<p>Headers: " + EndOfLine.Windows
		  HTML = HTML + "<ul>" + EndOfLine.Windows
		  If Headers.Count > 0 Then
		    For Each Entry As Xojo.Core.DictionaryEntry In Headers
		      HTML = HTML + "<li>" + Entry.Key + "=" + Entry.Value + "</li>"+ EndOfLine.Windows
		    Next
		  Else
		    HTML = HTML + "<li>None</li>"+ EndOfLine.Windows
		  End If
		  HTML = HTML + "</ul>" + EndOfLine.Windows
		  HTML = HTML + "</p>" + EndOfLine.Windows
		  
		  HTML = HTML + "<p>Cookies: " + EndOfLine.Windows
		  HTML = HTML + "<ul>" + EndOfLine.Windows
		  If Cookies.Count > 0 Then
		    For Each Entry As Xojo.Core.DictionaryEntry In Cookies
		      HTML = HTML + "<li>" + Entry.Key + "=" + Entry.Value + "</li>"+ EndOfLine.Windows
		    Next
		  Else
		    HTML = HTML + "<li>None</li>"+ EndOfLine.Windows
		  End If
		  HTML = HTML + "</ul>" + EndOfLine.Windows
		  HTML = HTML + "</p>" + EndOfLine.Windows
		  
		  HTML = HTML + "<p>GET Params: " + EndOfLine.Windows
		  HTML = HTML + "<ul>" + EndOfLine.Windows
		  If GET.Count > 0 Then
		    For Each Entry As Xojo.Core.DictionaryEntry In GET
		      HTML = HTML + "<li>" + Entry.Key + "=" + Entry.Value + "</li>"+ EndOfLine.Windows
		    Next
		  Else
		    HTML = HTML + "<li>None</li>"+ EndOfLine.Windows
		  End If
		  HTML = HTML + "</ul>" + EndOfLine.Windows
		  HTML = HTML + "</p>" + EndOfLine.Windows
		  
		  HTML = HTML + "<p>POST Params: " + EndOfLine.Windows
		  HTML = HTML + "<ul>" + EndOfLine.Windows
		  If POST.Count > 0 Then
		    For Each Entry As Xojo.Core.DictionaryEntry In POST
		      HTML = HTML + "<li>" + Entry.Key + "=" + Entry.Value + "</li>"+ EndOfLine.Windows
		    Next
		  Else
		    HTML = HTML + "<li>None</li>"+ EndOfLine.Windows
		  End If
		  HTML = HTML + "</ul>" + EndOfLine.Windows
		  HTML = HTML + "</p>" + EndOfLine.Windows
		  
		  HTML = HTML + "<p>Body:<br /><br />" 
		  If Body <> "" Then
		    HTML = HTML + Body
		  Else
		    HTML = HTML + "None"
		  End If
		  HTML = HTML + Body + "</p>" + EndOfLine.Windows
		  
		  Return HTML
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GETDictionaryCreate()
		  // Creates a dictionary representing the URL params.
		  
		  
		  // Create the dictionary.
		  GET = New Xojo.Core.Dictionary
		  
		  
		  // Split the Params string into an array of strings.
		  // Example: a=123&b=456&c=999
		  Dim GETParams() As String = URLParams.Split("&")
		  
		  
		  // Loop over the URL params to create the GET dictionary.
		  For i As Integer = 0 To GETParams.Ubound
		    
		    Dim ThisParam As String = GETParams(i)
		    Dim Key As String = ThisParam.NthField("=", 1)
		    Dim Value As String = ThisParam.NthField("=", 2)
		    GET.Value(Key) = URLDecode(Value)
		    
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HeadersDictionaryCreate()
		  // Creates a dictionary representing the request headers.
		  
		  
		  // Create the dictionary.
		  Headers = New Xojo.Core.Dictionary
		  
		  
		  // Loop over the other header array elements to create the request headers dictionary.
		  // We skip element 0 because it's not really a header. It contains the method, path, etc.
		  For i As Integer = 1 To HeadersRawArray.Ubound
		    
		    Dim ThisHeader As String = HeadersRawArray(i)
		    Dim Key As String = ThisHeader.NthField(": ", 1)
		    Dim Value As String = ThisHeader.NthField(": ", 2)
		    Headers.Value(Key) = Value
		    
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HTTPVersionGet()
		  // Get the HTP version from the first HeadersRawArray element.
		  // Example: POST /?a=123&b=456&c=999 HTTP/1.1
		  
		  
		  // Get the first header.
		  Dim Header As String = HeadersRawArray(0)
		  
		  // Get the HTTP version that was used to make the request.
		  HTTPVersion = Header.NthField(" ", 3).NthField("/", 2)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Initialize()
		  // Initializes the request.
		  // Note that this initialization is done here, instead of in the Constructor,
		  // so that it can be done after the Request has been assigned to a RequestThread
		  // and moved from the main thread.
		  
		  
		  // Get the request data.
		  DataGet
		  
		  // Split the request data into headers and body (RequestBody).
		  DataSplit
		  
		  // Split the headers into an array of strings.
		  HeadersRawArray = HeadersRaw.Split(EndOfLine.Windows)
		  
		  // Get the method.
		  MethodGet
		  
		  // Get the path.
		  PathGet
		  
		  // Get the path components.
		  PathComponentsGet
		  
		  // Get the URL params.
		  URLParamsGet
		  
		  // Get the HTTP version.
		  HTTPVersionGet
		  
		  // Create the headers dictionary.
		  HeadersDictionaryCreate
		  
		  // Create the cookies dictionary.
		  CookiesDictionaryCreate
		  
		  // Create the GET dictionary.
		  GETDictionaryCreate
		  
		  // Create the POST Dictionary.
		  POSTDictionaryCreate
		  
		  // Create a response instance.
		  Response = New Response
		  
		  // Evaluate the request to determine if the response content should be compressed.
		  ResponseCompressDefault
		  
		  // Set the default resources folder and index filenames.
		  // These are used by the "MapToFile" method.
		  StaticPath = GetFolderItem("").Parent.Child("htdocs")
		  IndexFilenames = Array("index.html", "index.htm")
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit)) or  (TargetIOS and (Target32Bit or Target64Bit))
		Sub MapToFile()
		  // Attempts to map a request to a static file.
		  
		  
		  // Assume that the requested resource will not be found.
		  Response.Set404Response(Headers, Path)
		  
		  
		  // Create a folder item based on the location of the static files.
		  Dim FI As FolderItem = StaticPath
		  
		  
		  // Create a folder item for the file that was requested...
		  For Each PathComponent As String In PathComponents
		    
		    // If this is a blank component...
		    // This might happen if the request is for a subfolder.
		    // Example: http://127.0.0.1:64003/sub/
		    If PathComponent = "" Then
		      Exit
		    End If
		    
		    // Add the URL-decoded path component.
		    FI = FI.Child(DecodeURLComponent(PathComponent))
		    
		    // If the path is no longer valid...
		    If FI = Nil Then
		      Return
		    End If
		    
		  Next
		  
		  
		  // If the requested resource is a directory...
		  If FI.Directory Then
		    
		    // Loop over the index filenames to see if any exist...
		    For Each IndexFilename As String In IndexFilenames
		      
		      // Add this index document to the FolderItem...
		      FI = FI.Child(IndexFilename)
		      
		      // If the FolderItem exists...
		      If FI.Exists Then
		        Exit
		      End If
		      
		      // Remove the default document from the FolderItem.
		      FI = FI.Parent
		      
		    Next
		    
		  End If
		  
		  
		  // If the folder item exists and it is not a directory...
		  If FI.Exists and FI.Directory = False Then
		    
		    // Update the response status.
		    Response.Status = "200"
		    
		    // Get the file's contents.
		    Response.Content = FileRead(FI)
		    
		    // Set the encoding of the content.
		    Response.Content = Response.Content.DefineEncoding(Encodings.UTF8)
		    
		    // Get the file's extension.
		    Dim Extension As String = NthField(FI.Name, ".", CountFields(FI.Name, "."))
		    
		    // Map the file extension to a mime type, and use that as the content type.
		    Response.Headers.Value("Content-Type") = MimeTypeGet(Extension)
		    
		  End If
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub MethodGet()
		  // Get the method from the first HeadersRawArray element.
		  // Example: POST /?a=123&b=456&c=999 HTTP/1.1
		  
		  
		  // Get the first header.
		  Dim Header As String = HeadersRawArray(0)
		  
		  // Get the request method.
		  Method = Header.NthField(" ", 1)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub PathComponentsGet()
		  // Create the path components by splitting the Path.
		  PathComponents = Path.Split("/")
		  
		  // Remove the first component, because it's a blank that appears before the first /.
		  If PathComponents.Ubound > -1 Then
		    PathComponents.Remove(0)
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub PathGet()
		  // Get the path from the first HeadersRawArray element.
		  // Example: POST /?a=123&b=456&c=999 HTTP/1.1
		  
		  
		  // Get the first header.
		  Dim Header As String = HeadersRawArray(0)
		  
		  // Get the request path.
		  Path = Header.NthField(" ", 2).NthField("?", 1)
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub POSTDictionaryCreate()
		  // Creates a dictionary representing the POST variables that are in the request body.
		  
		  
		  // Create the dictionary.
		  POST = New Xojo.Core.Dictionary
		  
		  
		  // If there is no data in the request body...
		  If Body = "" Then
		    Return
		  End If
		  
		  
		  // Get the content type.
		  Dim ContentType As String = Headers.Lookup("Content-Type", "")
		  
		  
		  // If the content isn't form-url encoded...
		  If ContentType.Split("application/x-www-form-urlencoded").Ubound = 0 Then
		    Return
		  End If
		  
		  
		  // Split the content string into an array of strings.
		  // Example: a=123&b=456&c=999
		  Dim POSTParams() As String = Body.Split("&")
		  
		  
		  // Loop over the array to create the POST dictionary.
		  For i As Integer = 0 To POSTParams.Ubound
		    Dim ThisParam As String = POSTParams(i)
		    Dim Key As String = ThisParam.NthField("=", 1)
		    Dim Value As String = ThisParam.NthField("=", 2)
		    POST.Value(Key) = URLDecode(Value)
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Process()
		  // Processes a request.
		  // This method will be called:
		  // By a RequestThread's Run event handler, if multithreading is enabled.
		  // By the DataAvailable event handler, if multithreading is disabled.
		  
		  
		  // Initialize the request.
		  Initialize
		  
		  // Hand the request off to a RequestHandler.
		  App.RequestHandler(Self)
		  
		  // Return the response.
		  ResponseReturn
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ResponseCompressDefault()
		  // Evaluates the request to determine if the response should be compressed.
		  
		  
		  // If the request did not include an "Accept-Encoding" header.
		  If Headers.HasKey("Accept-Encoding") = False Then
		    Return
		  End If
		  
		  // Get the "Accept-Encoding" header.
		  Dim AcceptEncoding As String = Headers.Lookup("Accept-Encoding", "")
		  
		  // Split the header value to see if "gzip" is specified.
		  Dim AcceptEncodingParts() As String = AcceptEncoding.Split("gzip")
		  
		  // If gzip is accepted...
		  If AcceptEncodingParts.Ubound > 0 Then
		    // By default, the response will be compressed.
		    Response.Compress = True
		  End If
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ResponseReturn()
		  
		  // If the socket is still connected...
		  If IsConnected Then
		    
		    // Try to write the response.
		    Try
		      
		      // Return the response.
		      Write Response.Get
		      
		    Catch e As RunTimeException
		      
		      Dim TypeInfo As Xojo.Introspection.TypeInfo = Xojo.Introspection.GetType(e)
		      
		      System.DebugLog "ResponseReturn Exception: Socket " + SocketID.ToText _
		      + ", Last Error: " + LastErrorCode.ToText _
		      + ", Exception Type: " + TypeInfo.Name
		      
		    End Try
		    
		  End If
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub URLParamsGet()
		  // Get the parameters from the first HeadersRawArray element.
		  // Example: POST /?a=123&b=456&c=999 HTTP/1.1
		  
		  // Get the first header.
		  Dim Header As String = HeadersRawArray(0)
		  
		  // Get the params.
		  URLParams = Header.NthField(" ", 2).NthField("?", 2)
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Body As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Cookies As Xojo.Core.Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		Data As String
	#tag EndProperty

	#tag Property, Flags = &h0
		GET As Xojo.Core.Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		Headers As Xojo.Core.Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		HeadersRaw As String
	#tag EndProperty

	#tag Property, Flags = &h0
		HeadersRawArray() As String
	#tag EndProperty

	#tag Property, Flags = &h0
		HTTPVersion As String
	#tag EndProperty

	#tag Property, Flags = &h0
		IndexFilenames() As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Method As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Multithreading As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		Path As String
	#tag EndProperty

	#tag Property, Flags = &h0
		PathComponents() As String
	#tag EndProperty

	#tag Property, Flags = &h0
		POST As Xojo.Core.Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		Response As Backendd.Response
	#tag EndProperty

	#tag Property, Flags = &h0
		SocketID As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		StaticPath As FolderItem
	#tag EndProperty

	#tag Property, Flags = &h0
		URLParams As String
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Address"
			Visible=true
			Group="Behavior"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Body"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Data"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="HeadersRaw"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="HTTPVersion"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			Type="Integer"
			EditorType="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Method"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Multithreading"
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
			EditorType="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Path"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Port"
			Visible=true
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SocketID"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
			EditorType="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="URLParams"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass

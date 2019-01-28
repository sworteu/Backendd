#tag Class
Protected Class Request
Inherits SSLSocket
	#tag CompatibilityFlags = ( TargetConsole and ( Target32Bit or Target64Bit ) ) or ( TargetWeb and ( Target32Bit or Target64Bit ) ) or ( TargetDesktop and ( Target32Bit or Target64Bit ) ) or ( TargetIOS and ( Target32Bit or Target64Bit ) )
	#tag Event
		Sub Connected()
		  // A connection has been made to one of the sockets.
		  // The request's data will be read, and when that's complete, the DataAvailable event will occur.
		  
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub DataAvailable()
		  // Data has been received...
		  
		  // Increment the data received counter.
		  DataReceivedCount = DataReceivedCount + 1
		  
		  // Update the LastConnect timestamp.
		  // This is used to determine if a keep-alive or WebSocket connection has timed out.
		  LastConnect = New Date
		  
		  // If this socket is servicing an active Websocket...
		  If WSStatus = "Active" Then
		    
		    // Get the incoming message.
		    WSMessageGet
		    
		    // If the socket has been closed...
		    If Self.IsConnected = False Then
		      Return
		    End If
		    
		    // Hand the message off to the app's RequestHandler.
		    App.RequestHandler(Self)
		    
		    Return
		    
		  End If
		  
		  // If this is a new request...
		  If DataReceivedCount = 1 Then
		    
		    // Prepare the request for processing.
		    Prepare
		    
		    // If the content being uploaded (based on the Content-Length header)
		    // is too large...
		    If ContentLength > MaxEntitySize Then
		      Response.Status = "413 Request Entity Too Large"
		      Response.Content = "Error 413: Request Entity Too Large"
		      ResponseReturn
		      Return
		    End If
		    
		  End If
		  
		  // Get the length of the content that has been received.
		  Dim ContentReceivedLength As Integer = Lookahead.Len
		  
		  // If the content that has actually been uploaded is too large...
		  // This prevents a client from spoofing of the Content-Length header
		  // and sending large entities.
		  If ContentReceivedLength > MaxEntitySize Then
		    Response.Status = "413 Request Entity Too Large"
		    Response.Content = "Error 413: Request Entity Too Large"
		    ResponseReturn
		    Return
		  End If
		  
		  // If we haven't received all of the content...
		  If ContentReceivedLength <  ContentLength Then
		    // Continue receiving data...
		    Return
		  End If
		  
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
		  // An error occurred with the socket.
		  // Typically, this will be a 102 error, where the client has closed the connection.
		  If LastErrorCode <> 102 Then
		    System.DebugLog "Socket " + SocketID.totext + " Error: " + LastErrorCode.ToText
		  End If
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub SendComplete(UserAborted As Boolean)
		  // The response has been sent back to the client.
		  
		  // If persistent connections are disabled...
		  If KeepAlive = False Then
		    // Close the connection.
		    Close
		  End If
		  
		  // If this was a multipart form...
		  If ContentType.Split("multipart/form-data").Ubound = 1 Then
		    // Close the connection.
		    Close
		  End If
		  
		  // Reset the socket's properties.
		  Reset
		  
		  
		  
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Sub BodyGet()
		  // Gets the request body.
		  
		  // Split the data into headers and the body.
		  Dim RequestParts() As String = Data.Split(EndOfLine.Windows + EndOfLine.Windows)
		  
		  // We no longer need the data that was received, so clear it.
		  Data = ""
		  
		  // If we were unable to split the data into a header and body...
		  If RequestParts.Ubound < 0 Then
		    Return
		  End If
		  
		  // Remove the header part.
		  RequestParts.Remove(0)
		  
		  // Merge the remaining parts to form the entire request body.
		  Body = Join(RequestParts, EndOfLine.Windows + EndOfLine.Windows)
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub BodyProcess()
		  // Evaluates the request body to create dictionaries representing any POST variables 
		  // and/or files that have been sent.
		  
		  
		  // Create the POST and Files dictionaries.
		  POST = New Dictionary
		  Files = New Dictionary
		  
		  // If there is no data in the request body...
		  If Body = "" Then
		    Return
		  End If
		  
		  // Get the content type.
		  ContentType = Headers.Lookup("Content-Type", "")
		  
		  // If the content is form-url encoded...
		  If ContentType.Split("application/x-www-form-urlencoded").Ubound = 1 Then
		    URLEncodedFormHandle
		    Return
		  End If
		  
		  // If this is a multipart form...
		  If ContentType.Split("multipart/form-data").Ubound = 1 Then
		    MultipartFormHandle
		    Return
		  End If
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Close()
		  // Closes the socket and resets custom properties.
		  
		  Reset
		  
		  Path = ""
		  
		  WSStatus = "Inactive"
		  
		  Super.Close
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(Server As Backendd.Server)
		  // Associate this request (socket) with its server.
		  Self.Server = Server
		  
		  // Inherit properties from the server.
		  Multithreading = Server.Multithreading
		  Secure = Server.Secure
		  ConnectionType = Server.ConnectionType
		  CertificateFile = Server.CertificateFile
		  CertificatePassword = Server.CertificatePassword
		  MaxEntitySize = Server.MaxEntitySize
		  KeepAlive = Server.KeepAlive
		  
		  // Call the overridden superclass constructor.
		  Super.Constructor
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ContentLengthGet()
		  // Get the content-length header.
		  If Headers.HasKey("Content-Length") Then
		    ContentLength = Headers.Value("Content-Length")
		  Else
		    ContentLength = 0
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub CookiesDictionaryCreate()
		  // Creates a dictionary representing the request cookies.
		  // The cookies are delivered as a request header, like this:
		  // Cookie: x=12; y=124
		  
		  
		  // Create the dictionary.
		  Cookies = New Dictionary
		  
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
		    For Each Key As Variant in Headers.Keys
		      HTML = HTML + "<li>" + Key + "=" + Headers.Value(Key) + "</li>"+ EndOfLine.Windows
		    Next
		  Else
		    HTML = HTML + "<li>None</li>"+ EndOfLine.Windows
		  End If
		  HTML = HTML + "</ul>" + EndOfLine.Windows
		  HTML = HTML + "</p>" + EndOfLine.Windows
		  
		  HTML = HTML + "<p>Cookies: " + EndOfLine.Windows
		  HTML = HTML + "<ul>" + EndOfLine.Windows
		  If Cookies.Count > 0 Then
		    For Each Key As Variant in Cookies.Keys
		      HTML = HTML + "<li>" + Key + "=" + Cookies.Value(Key) + "</li>"+ EndOfLine.Windows
		    Next
		  Else
		    HTML = HTML + "<li>None</li>"+ EndOfLine.Windows
		  End If
		  HTML = HTML + "</ul>" + EndOfLine.Windows
		  HTML = HTML + "</p>" + EndOfLine.Windows
		  
		  HTML = HTML + "<p>GET Params: " + EndOfLine.Windows
		  HTML = HTML + "<ul>" + EndOfLine.Windows
		  If GET.Count > 0 Then
		    For Each Key As Variant in GET.Keys
		      HTML = HTML + "<li>" + Key + "=" + GET.Value(Key) + "</li>"+ EndOfLine.Windows
		    Next
		  Else
		    HTML = HTML + "<li>None</li>"+ EndOfLine.Windows
		  End If
		  HTML = HTML + "</ul>" + EndOfLine.Windows
		  HTML = HTML + "</p>" + EndOfLine.Windows
		  
		  HTML = HTML + "<p>POST Params: " + EndOfLine.Windows
		  HTML = HTML + "<ul>" + EndOfLine.Windows
		  If POST.Count > 0 Then
		    For Each Key As Variant in POST.Keys
		      HTML = HTML + "<li>" + Key + "=" + POST.Value(Key) + "</li>"+ EndOfLine.Windows
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
		  GET = New Dictionary
		  
		  
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
		  Headers = New Dictionary
		  
		  
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
		Sub KeepAliveGet()
		  // If we're willing to keep connections open...
		  If KeepAlive = True Then
		    
		    // Inspect the Connection header to determine the connection type that has been requested.
		    If Headers.Lookup("Connection", "close") = "close" Then
		      KeepAlive = False
		    Else
		      KeepAlive = True
		    End If
		    
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit)) or  (TargetIOS and (Target32Bit or Target64Bit))
		Sub MapToFile(UseETags As Boolean = True)
		  // Attempts to map a request to a static file.
		  
		  
		  // Assume that the requested resource will not be found.
		  'Response.Set404Response(Headers, Path)
		  Response.Status = "404"
		  
		  
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
		    
		    // If we're using ETags...
		    If UseETags Then
		      
		      // Generate the current Etag for the file.
		      Dim CurrentEtag As String 
		      CurrentEtag = MD5(FI.NativePath)
		      CurrentEtag = EncodeHex(CurrentEtag)
		      CurrentEtag = CurrentEtag + "-" + FI.ModificationDate.TotalSeconds.ToText
		      CurrentEtag = CurrentEtag.NthField(".", 1)
		      
		      // Get any Etag that the client sent in the request.
		      Dim ClientEtag As String = Headers.Lookup("If-None-Match", "")
		      
		      // If the client has the current resource...
		      If ClientEtag = CurrentEtag Then
		        // Return the "Not Modified" status.
		        Response.Status = "304"
		        Return
		      End If
		      
		      // Add an Etag header.
		      Response.Headers.Value("ETag") = CurrentEtag.ToText
		      
		    End If
		    
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
		    
		    // If XojoScript is enabled...
		    If XojoScriptEnabled Then
		      XojoScriptsParse
		    End If
		    
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
		Private Sub MultipartFormHandle()
		  // Split the content type at the boundary.
		  Dim ContentTypeParts() As String = ContentType.Split("boundary=")
		  
		  // If the content does not have a boundary...
		  If ContentTypeParts.Ubound < 1 Then
		    Return
		  End If
		  
		  // Get the boundary.
		  Dim Boundary As String = ContentTypeParts(1)
		  
		  // Split the content into parts based on the boundary.
		  Dim Parts() As String = Body.Split("--" + Boundary)
		  
		  // Loop over the parts, skipping the header...
		  For i As Integer = 1 To Parts.Ubound
		    
		    // Split the part into its header and content.
		    Dim PartComponents() As String = Parts(i).Split(EndOfLine.Windows + EndOfLine.Windows)
		    
		    // If this part has no content...
		    If PartComponents.Ubound < 1 Then
		      Continue
		    End If
		    
		    // Get the part content.
		    Dim PartContent As String = PartComponents(1)
		    
		    // Additional info about the part will be stored in these vars.
		    Dim Fieldname As String
		    Dim Filename As String
		    Dim FileContentType As String
		    Dim FieldIsAFile As Boolean = False
		    
		    // Split the part headers into an array.
		    // Example Header...
		    // Content-Disposition: form-data; name="file1"; filename="woot.png"
		    // Content-Type: image/png
		    Dim PartHeaders() As String = PartComponents(0).Split(EndOfLine.Windows)
		    
		    // Loop over the part headers...
		    For Each PartHeader As String In PartHeaders
		      
		      // If this part header is empty...
		      If PartHeader = "" Then
		        Continue
		      End If
		      
		      Dim HeaderName As String = PartHeader.NthField(": ", 1)
		      Dim HeaderValue As String = PartHeader.NthField(": ", 2)
		      
		      If HeaderName = "Content-Type" Then
		        FileContentType = HeaderValue
		        Continue
		      End If
		      
		      If HeaderName = "Content-Disposition" Then
		        
		        // Split the disposition into its parts.
		        Dim DispositionParts() As String = HeaderValue.Split("; ")
		        
		        // Loop over the disposition parts to get the field name and file name.
		        For Each DispPart As String In DispositionParts
		          
		          // Split the disposition part into name / value pairs.
		          Dim NameValue() As String = DispPart.Split("=")
		          
		          If NameValue.Ubound < 0 Then
		            Continue
		          End If
		          
		          // If this is a field name...
		          If NameValue(0) = "name" Then
		            Fieldname = NameValue(1).ReplaceAll("""", "")
		          End If
		          
		          // If this is a file name...
		          If NameValue(0) = "filename" Then
		            FieldIsAFile = True
		            Filename = NameValue(1).ReplaceAll("""", "")
		          End If
		          
		        Next
		        
		      End If
		      
		    Next
		    
		    // If we could not get a field name from the part...
		    If Fieldname = "" Then
		      Continue
		    End If
		    
		    // If this is a file...
		    If FieldIsAFile Then
		      Dim FileDictionary As New Dictionary
		      FileDictionary.Value("ContentType") = FileContentType
		      FileDictionary.Value("Content") = PartContent
		      FileDictionary.Value("Filename") = Filename
		      FileDictionary.Value("ContentLength") = PartContent.Len
		      Files.Value(Fieldname) = FileDictionary
		    Else
		      POST.Value(Fieldname) = PartContent
		    End If
		    
		  Next
		  
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
		Private Sub PathItemsGet()
		  // Creates a dictionary representing the path components.
		  
		  
		  // Create the dictionary.
		  PathItems = New Dictionary
		  
		  // If there are path components...
		  If PathComponents.Ubound > -1 Then
		    
		    For i As Integer = 0 To PathComponents.Ubound
		      PathItems.Value(i) = PathComponents(i)
		    Next
		    
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Prepare()
		  // Prepares a new request for processing.
		  // This is called once per request, when the first batch of data is received via the DataAvailable event.
		  
		  
		  // Split the request into two parts: headers and the request entity.
		  Dim RequestParts() As String = Lookahead.Split(EndOfLine.Windows + EndOfLine.Windows)
		  
		  // Get the headers as a string.
		  HeadersRaw = RequestParts(0)
		  
		  // Split the headers into an array of strings.
		  HeadersRawArray = HeadersRaw.Split(EndOfLine.Windows)
		  
		  // Get the method.
		  MethodGet
		  
		  // Get the path.
		  PathGet
		  
		  // Get the protocol.
		  ProtocolGet
		  
		  // Get the path components.
		  PathComponentsGet
		  
		  // Build the path item dictionary.
		  PathItemsGet
		  
		  // Get the URL params.
		  URLParamsGet
		  
		  // Get the HTTP version.
		  HTTPVersionGet
		  
		  // Create the headers dictionary.
		  HeadersDictionaryCreate
		  
		  // Get the connection type.
		  KeepAliveGet
		  
		  // Get the content-length header.
		  ContentLengthGet
		  
		  // Create the cookies dictionary.
		  CookiesDictionaryCreate
		  
		  // Create the GET dictionary.
		  GETDictionaryCreate
		  
		  // Create a response instance.
		  Response = New Response(Self)
		  
		  // Evaluate the request to determine if the response content should be compressed.
		  ResponseCompressDefault
		  
		  // Set the default resources folder and index filenames.
		  // These are used by the "MapToFile" method.
		  StaticPath = GetFolderItem("").Parent.Child("htdocs")
		  IndexFilenames = Array("index.html", "index.htm")
		  
		  // Initlialize the Custom dictionary.
		  Custom = New Dictionary
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Process()
		  // Processes a request.
		  // This method will be called:
		  // By a RequestThread's Run event handler, if multithreading is enabled.
		  // By the DataAvailable event handler, if multithreading is disabled.
		  
		  
		  // Get the request data.
		  DataGet
		  
		  // Get the body from the data.
		  BodyGet
		  
		  // Create the POST and Files dictionaries.
		  BodyProcess
		  
		  // Hand the request off to the RequestHandler.
		  App.RequestHandler(Self)
		  
		  // Return the response.
		  ResponseReturn
		  
		  // Reset the data received counter. 
		  DataReceivedCount = 0
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ProtocolGet()
		  // Get the protocol from the first HeadersRawArray element.
		  // Example: POST /?a=123&b=456&c=999 HTTP/1.1
		  
		  
		  // Get the first header.
		  Dim Header As String = HeadersRawArray(0)
		  
		  // Get the protocol that was used to make the request.
		  Protocol = Header.NthField(" ", 3).NthField("/", 1)
		  ProtocolVersion = Header.NthField(" ", 3).NthField("/", 2)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Reset()
		  // Resets socket properties after a request has been processed.
		  // Note that these properties are not reset because they are used 
		  // to service WebSockets: Custom, Path
		  
		  Body = ""
		  ContentType = ""
		  Cookies = Nil
		  Data = ""
		  Files = Nil
		  GET = Nil
		  Headers = Nil
		  HeadersRaw = ""
		  HeadersRawArray = Nil
		  Method = ""
		  PathComponents = Nil
		  POST = Nil
		  Response = Nil
		  Session = Nil
		  StaticPath = Nil
		  URLParams = ""
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ResourceNotFound()
		  // Set's the response status to 404 "Not Found" and content to the AloeExpress
		  // Standard404Content (constant) HTML.
		  
		  
		  // Set the response content.
		  Response.Content = NotFoundContent
		  Response.Content = Response.Content.ReplaceAll("[[ServerType]]", "Xojo/" + XojoVersionString + "+ AloeExpress/" + Backendd.VersionString)
		  Response.Content = Response.Content.ReplaceAll("[[Host]]", Headers.Lookup("Host", ""))
		  Response.Content = Response.Content.ReplaceAll("[[Path]]", Path)
		  
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

	#tag Method, Flags = &h0
		Sub SessionGet(AssignNewID As Boolean=True)
		  // Gets a session for the request and associates it with the Session property.
		  Session = Server.SessionEngine.SessionGet(Self, AssignNewID)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SessionTerminate()
		  If Session <> Nil Then
		    Server.SessionEngine.SessionTerminate(Session)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub URLEncodedFormHandle()
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

	#tag Method, Flags = &h21
		Private Sub URLParamsGet()
		  // Get the parameters from the first HeadersRawArray element.
		  // Example: POST /?a=123&b=456&c=999 HTTP/1.1
		  
		  // Note that it is also possible for a parameter to include a question mark in it.
		  // Example: GET /?a=1234?format%3D1500w&MaxHeight=50 HTTP/1.1
		  
		  // Get the first header.
		  Dim Header As String = HeadersRawArray(0)
		  
		  // Split the header on ?s.
		  Dim URLParamParts() As String = Header.Split("?")
		  
		  // Remove the first element, which should be the method and path.
		  URLParamParts.Remove(0)
		  
		  // Recombine the URL parameters.
		  URLParams = Join(URLParamParts, "?")
		  
		  // Split the string based on a space and get the first element.
		  // Remember that NthField is 1-based.
		  URLParams = URLParams.NthField(" ", 1)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WSConnectionClose()
		  
		  // Loop over each WebSocket connection...
		  For i As Integer = 0 to Server.WebSockets.Ubound
		    
		    Dim Socket As Backendd.Request =  Server.WebSockets(i)
		    If Socket = Self Then
		      Server.WebSockets.Remove(i)
		      Exit
		    End If
		    
		  Next
		  
		  // Close the connection.
		  Close
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WSHandshake()
		  // Performs an opening WebSocket handshake.
		  
		  // If this isn't the WebSocket version that we're supporting...
		  If Headers.Lookup("Sec-WebSocket-Version", "") <> "13" Then
		    Response.Status = "400 Bad Request"
		    Return
		  End If
		  
		  // Create the SecWebSocketKey for the response.
		  Dim SecWebSocketKey As String = Headers.Value("Sec-WebSocket-Key") 
		  SecWebSocketKey = SecWebSocketKey + "258EAFA5-E914-47DA-95CA-C5AB0DC85B11"
		  SecWebSocketKey = Crypto.Hash(SecWebSocketKey, Crypto.Algorithm.SHA1)
		  SecWebSocketKey = EncodeBase64(SecWebSocketKey, 0)
		  
		  // Return the handshake response.
		  Response.Status = "101 Switching Protocols"
		  Response.Headers.Value("Upgrade") = "WebSocket"
		  Response.Headers.Value("Connection") = "Upgrade"
		  Response.Headers.Value("Sec-WebSocket-Accept") = SecWebSocketKey
		  
		  // Update the WS status.
		  WSStatus = "Active"
		  
		  // Register the socket as a WebSocket.
		  Server.WebSockets.Append(Self)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WSMessageGet()
		  // Processes a WebSocket message.
		  
		  
		  // Get the data.
		  DataGet
		  
		  // Convert the message to a memoryblock.
		  Dim DataRaw As MemoryBlock = Data
		  DataRaw.LittleEndian = False
		  
		  // We'll use a pointer to get specific bytes from the memoryblock.
		  Dim DataPtr As Ptr = DataRaw
		  
		  // Get the first byte.
		  Dim FirstByte As UInteger = DataPtr.Byte(0)
		  
		  // Is this the last message in the series?
		  Dim FinBit As UInteger = FirstByte And &b10000000
		  
		  // Get the reserved extension bits.
		  Dim RSV1 As Integer = FirstByte And &b01000000
		  Dim RSV2 As Integer = FirstByte And &b00100000
		  Dim RSV3 As Integer = FirstByte And &b00010000
		  
		  // Get the OpCode.
		  Dim OpCode As UInteger = FirstByte And &b00001111
		  
		  // If the client is closing the connection...
		  If OpCode = 8 Then
		    WSConnectionClose
		    Return
		  End If
		  
		  // Get the second byte from the frame.
		  Dim SecondByte As UInteger = DataPtr.Byte(1)
		  
		  // Is the payload masked?
		  Dim MaskedBit As UInteger = SecondByte And &b10000000
		  
		  // Get the payload size.
		  Dim PayloadSize As UInteger = SecondByte And &b01111111
		  Dim MaskKeyStartingByte As UInteger
		  If PayloadSize < 126 Then
		    MaskKeyStartingByte = 2
		  ElseIf PayloadSize = 126 Then
		    PayloadSize = DataRaw.UInt16Value(2)
		    MaskKeyStartingByte = 4
		  ElseIf PayloadSize = 127 Then
		    PayloadSize = DataRaw.UInt64Value(2)
		    MaskKeyStartingByte = 10
		  End If
		  
		  // Get the masking key.
		  Dim MaskKey() As UInteger
		  For i As Integer = 0 to 3
		    MaskKey.Append(DataPtr.Byte(MaskKeyStartingByte + i))
		  Next
		  
		  // Determine where the data bytes start.
		  Dim DataStartingByte As UInteger = MaskKeyStartingByte + 4
		  
		  // Get the masked data...
		  Dim DataMasked() As UInteger
		  For i As Integer = 0 to PayloadSize - 1
		    DataMasked.Append(DataPtr.Byte(DataStartingByte + i))
		  Next
		  
		  // Unmask the data and store it in the Request body...
		  Body = ""
		  For i As Integer = 0 to PayloadSize - 1
		    Body = Body + Chr(DataMasked(i) XOR MaskKey(i Mod 4))
		  Next
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WSMessageSend(Message As String)
		  // Sends a WebSocket (text) message to a client.
		  
		  // Get the message length.
		  Dim MessageLength As UInteger = Len(Message)
		  
		  // If the entire message can be sent in a single frame...
		  If MessageLength < 126 Then
		    Dim Byte1 As UInteger = 129
		    Dim Byte2 As UInteger = MessageLength
		    Write ChrB(Byte1) + ChrB(Byte2) + Message
		    Return
		  End If
		  
		  // Due to its length, the message needs to be sent in multiple frames...
		  If MessageLength >= 126 and MessageLength < 65535 Then
		    Dim Byte1 As UInteger = 129
		    Dim Byte2 As UInteger = 126
		    Dim Byte3 As UInteger = Bitwise.ShiftRight(MessageLength, 8) And 255
		    Dim Byte4 As UInteger = MessageLength And 255
		    Write ChrB(Byte1) + ChrB(Byte2) + ChrB(Byte3) + ChrB(Byte4) + Message
		    Return
		  End If
		  
		  If MessageLength >= 65535 Then
		    Dim Byte1 As UInteger = 129
		    Dim Byte2 As UInteger = 127
		    Dim Byte3 As UInt64 = Bitwise.ShiftRight(MessageLength, 56) And 255
		    Dim Byte4 As UInt64 = Bitwise.ShiftRight(MessageLength, 48) And 255
		    Dim Byte5 As UInt64 = Bitwise.ShiftRight(MessageLength, 40) And 255
		    Dim Byte6 As UInt64 = Bitwise.ShiftRight(MessageLength, 32) And 255
		    Dim Byte7 As UInt64 = Bitwise.ShiftRight(MessageLength, 24) And 255
		    Dim Byte8 As UInt64 = Bitwise.ShiftRight(MessageLength, 16) And 255
		    Dim Byte9 As UInt64 = Bitwise.ShiftRight(MessageLength, 8) And 255
		    Dim Byte10 As UInt64 =  MessageLength And 255
		    Write ChrB(Byte1) + ChrB(Byte2) _
		    + ChrB(Byte3) + ChrB(Byte4) + ChrB(Byte5) + ChrB(Byte6) _
		    + ChrB(Byte7) + ChrB(Byte8) + ChrB(Byte9) + ChrB(Byte10) _
		    + Message
		    Return
		  End If
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub XojoScriptsParse()
		  // Determine the number of scripts in the content.
		  Dim Scripts() As String =Response.Content.Split("<xojoscript>")
		  
		  // If there are no scripts in the content.
		  If Scripts.Ubound = 0 Then
		    Return
		  End If
		  
		  // Create an instance of the XojoScript evaluator.
		  Dim Evaluator As New XSProcessor
		  
		  // Loop over the XojoScript blocks...
		  For x As Integer = 0 to Scripts.Ubound
		    
		    // Get the next XojoScript block.
		    Evaluator.Source = Backendd.BlockGet(Response.Content, "<xojoscript>", "</xojoscript>", 0)
		    
		    // Run the XojoScript.
		    Evaluator.Run
		    
		    // Replace the block with the result.
		    Response.Content = Backendd.BlockReplace(Response.Content, "<xojoscript>", "</xojoscript>", 0, Evaluator.Result)
		    
		  Next
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Body As String
	#tag EndProperty

	#tag Property, Flags = &h0
		ContentLength As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0
		ContentType As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Cookies As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		Custom As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		Data As String
	#tag EndProperty

	#tag Property, Flags = &h0
		DataReceivedCount As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0
		Files As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		GET As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		Headers As Dictionary
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
		KeepAlive As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		LastConnect As Date
	#tag EndProperty

	#tag Property, Flags = &h0
		MaxEntitySize As Integer = 1048576
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
		PathItems As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		POST As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		Protocol As String
	#tag EndProperty

	#tag Property, Flags = &h0
		ProtocolVersion As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Response As Backendd.Response
	#tag EndProperty

	#tag Property, Flags = &h0
		Server As Backendd.Server
	#tag EndProperty

	#tag Property, Flags = &h0
		Session As Dictionary
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

	#tag Property, Flags = &h0
		WSStatus As String = "Inactive"
	#tag EndProperty

	#tag Property, Flags = &h0
		XojoScriptEnabled As Boolean = True
	#tag EndProperty


	#tag Constant, Name = NotFoundContent, Type = String, Dynamic = False, Default = \"<!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html>\n<head>\n<title>404 Not Found</title>\n</head>\n<body>\n<h1>Not Found</h1>\n<p>The requested URL [[Path]] was not found on this server.</p>\n<hr>\n<address>[[ServerType]] at [[Host]]</address>\n</body>\n</html>", Scope = Public
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="ConnectionType"
			Visible=true
			Group="Behavior"
			InitialValue="3"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="KeepAlive"
			Visible=true
			Group="Behavior"
			InitialValue="3"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Secure"
			Visible=true
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="CertificatePassword"
			Visible=true
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SSLConnected"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SSLConnecting"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="BytesAvailable"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="BytesLeftToSend"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LastErrorCode"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
			EditorType="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			Type="Integer"
			EditorType="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
			EditorType="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Address"
			Visible=true
			Group="Behavior"
			Type="String"
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
			Name="Method"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Path"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="URLParams"
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
			Name="Body"
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
			Name="MaxEntitySize"
			Group="Behavior"
			InitialValue="1048576"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ContentType"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="DataReceivedCount"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ContentLength"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="XojoScriptEnabled"
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="WSStatus"
			Group="Behavior"
			InitialValue="Inactive"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Protocol"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ProtocolVersion"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass

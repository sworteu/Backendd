#tag Class
Protected Class Response
	#tag Method, Flags = &h0
		Sub Constructor(Request As Backendd.Request)
		  // Store the request that this response is associated with.
		  Self.Request = Request
		  
		  // Initialize the headers.
		  HeadersInit
		  
		  // Initialize the cookies.
		  Cookies = New Dictionary
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ContentCompress()
		  // Compresses the content using gzip, and adds the necessary header.
		  // Source: https://forum.xojo.com/11634-gunzip-without-a-file/0
		  
		  
		  // Compress the content.
		  Content = GZip(Content)
		  
		  
		  // Add a content-encoding header.
		  Headers.Value("Content-Encoding") = "gzip"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CookieSet(Name As String, Value As String, Expiration As Date = Nil, Domain As String = "", Path As String = "/", Secure As Boolean = False, HttpOnly As Boolean = False)
		  // Adds a cookie to the dictionary.
		  
		  
		  // Create a dictionary for the cookie's settings.
		  Dim Cookie As New Dictionary
		  Cookie.Value("Value") = Value
		  Cookie.Value("Expiration") = Expiration
		  Cookie.Value("Domain") = Domain
		  Cookie.Value("Path") = Path
		  Cookie.Value("Secure") = Secure
		  Cookie.Value("HttpOnly") = HttpOnly
		  
		  // Add / replace the cookie.
		  Cookies.Value(Name) = Cookie
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CookieSet(Name As String, Value As String, ExpirationDays As Integer = 0, ExpirationHours As Integer = 0, ExpirationMinutes As Integer = 0, ExpirationSeconds As Integer = 0, Domain As String = "", Path As String = "/", Secure As Boolean = False, HttpOnly As Boolean = False)
		  // Adds a cookie to the dictionary.
		  
		  // Create the cookie's expiration date.
		  Dim ExpirationDate As New Date
		  ExpirationDate.Day = ExpirationDate.Day + ExpirationDays
		  ExpirationDate.Hour = ExpirationDate.Hour + ExpirationHours
		  ExpirationDate.Minute = ExpirationDate.Minute + ExpirationMinutes
		  ExpirationDate.Second = ExpirationDate.Second + ExpirationSeconds
		  
		  
		  // Create a dictionary for the cookie's settings.
		  Dim Cookie As New Dictionary
		  Cookie.Value("Value") = Value
		  Cookie.Value("Expiration") = ExpirationDate
		  Cookie.Value("Domain") = Domain
		  Cookie.Value("Path") = Path
		  Cookie.Value("Secure") = Secure
		  Cookie.Value("HttpOnly") = HttpOnly
		  
		  // Add / replace the cookie.
		  Cookies.Value(Name) = Cookie
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function CookiesToHeaders() As String
		  // Converts the cookie dictionary entries into header dictionary entries.
		  
		  
		  Dim HeadersString As String
		  
		  // Loop over the dictionary entries...
		  For Each Key As Variant in Cookies.Keys
		    
		    // Get the entry's key and value.
		    Dim Name As String = Key
		    Dim Settings As Dictionary = Cookies.Value(Key)
		    
		    // Create the cookie sting.
		    Dim CookieString As String 
		    CookieString = CookieString + URLEncode(Name) + "=" + URLEncode(Settings.Value("Value")) + "; "
		    If Settings.Value("Expiration") <> Nil Then
		      Dim ExpirationDate As String = Backendd.DateToRFC1123(Settings.Value("Expiration"))
		      CookieString = CookieString + "expires=" + ExpirationDate + "; "
		    End If 
		    If Settings.Value("Domain") <> Nil Then
		      CookieString = CookieString + "domain=" + Settings.Value("Domain") + "; "
		    End If
		    If Settings.Value("Path") <> Nil Then
		      CookieString = CookieString + "path=" + Settings.Value("Path") + "; "
		    End If
		    If Settings.Value("Secure") Then
		      CookieString = CookieString + "secure; "
		    End If
		    If Settings.Value("HttpOnly") Then
		      CookieString = CookieString + "HttpOnly;"
		    End If
		    
		    // Add the string representation of the cookie to the headers string.
		    HeadersString = HeadersString _
		    + "Set-Cookie: " + CookieString + EndOfLine.Windows
		    
		  Next
		  
		  Return HeadersString
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Dump() As String
		  Dim HTML As String
		  
		  HTML = HTML + "<p>HTTP Version: " + HTTPVersion + "</p>" + EndOfLine.Windows
		  
		  HTML = HTML + "<p>Headers: " + EndOfLine.Windows
		  HTML = HTML + "<ul>" + EndOfLine.Windows
		  For Each Key As Variant in Headers.Keys
		    HTML = HTML + "<li>" + Key + "=" + Headers.Value(Key) + "</li>"+ EndOfLine.Windows
		  Next
		  HTML = HTML + "</ul>" + EndOfLine.Windows
		  HTML = HTML + "</p>" + EndOfLine.Windows
		  
		  HTML = HTML + "<p>Response Content...<br /><br />" + Content + "</p>" + EndOfLine.Windows
		  
		  Return HTML
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Get() As String
		  // Returns the response.
		  // Called by Request.ResponseReturn.
		  
		  
		  // If the content is to be compressed...
		  If Compress = True Then
		    ContentCompress
		  End If
		  
		  
		  // Return the response, including headers and content.
		  Return HeadersToString + CookiesToHeaders + EndOfLine.Windows + Content
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HeadersInit()
		  // Set default response headers.
		  Headers = New Dictionary
		  If Request.KeepAlive = True Then
		    Headers.Value("Connection") = "Keep-Alive"
		  Else 
		    Headers.Value("Connection") = "Close"
		  End If
		  Headers.Value("Content-Language") = "en"
		  Headers.Value("Content-Type") = "text/html; charset=UTF-8"
		  Headers.Value("Date") = DateToRFC1123
		  
		  // Set debug-related headers if applicable...
		  #If DebugBuild Then
		    Headers.Value("X-Aloe-Version") = Backendd.VersionString
		    Headers.Value("X-Host") = Request.Headers.Lookup("Host", "")
		    Headers.Value("X-Last-Connect") = Request.LastConnect.SQLDateTime
		    Headers.Value("X-Socket-ID") = Request.SocketID
		    Headers.Value("X-Xojo-Version") = XojoVersionString
		    Headers.Value("X-Server-Active-Conns") = Integer(Request.Server.ActiveConnections.Ubound + 1).ToText
		    Headers.Value("X-Server-Port") = Request.Server.Port
		  #Endif
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function HeadersToString() As String
		  // Converts the ResponseHeaders from a dictionary to a string
		  
		  
		  // This is the string that will be returned.
		  Dim RH As String
		  
		  // Define the encoding for the response headers.
		  RH = RH.DefineEncoding(Encodings.UTF8)
		  
		  // Add the initial header.
		  RH = "HTTP/" + HTTPVersion + " " + Status + EndOfLine.Windows
		  
		  // Specify the content length.
		  Headers.Value("Content-Length") = Content.LenB.ToText
		  
		  // Loop over the dictionary entries...
		  For Each Key As Variant in Headers.Keys
		    
		    // Add the value.
		    RH = RH + Key + ": " + Headers.Value(Key) + EndOfLine.Windows
		    
		  Next
		  
		  
		  
		  Return RH
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MetaRefresh(URL As String)
		  // Generates the HTML needed to do a Meta Refresh to a specified URL,
		  // which redirects the user to a new location.
		  
		  
		  // Update the status code.
		  Status = "200"
		  
		  
		  // Update the content.
		  Content = "<html xmlns=""http://www.w3.org/1999/xhtml"">" _
		  + "<head>" _
		  + "<title>Redirecting...</title>" _
		  + "<meta http-equiv=""refresh"" content=""0;URL='" + URL + "'"" />" _
		  + "</head>" _
		  + "<body style=""background: #fff;"">" _
		  + "</body>" _
		  + "</html>"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SecurityHeadersSet()
		  // Sets suggested security-related headers.
		  // For guidance, see:
		  // https://content-security-policy.com/
		  // https://wiki.mozilla.org/Security/Guidelines/Web_Security
		  
		  
		  Headers.Value("Content-Security-Policy") = "default-src 'none'; connect-src 'self'; frame-ancestors 'none'; img-src 'self'; script-src 'self'; style-src 'unsafe-inline' 'self';"
		  Headers.Value("Referrer-Policy") = "no-referrer, strict-origin-when-cross-origin"
		  Headers.Value("Strict-Transport-Security") = "max-age=63072000"
		  Headers.Value("X-Content-Type-Options") = "nosniff"
		  Headers.Value("X-Frame-Options") = "DENY"
		  Headers.Value("X-XSS-Protection") = "1; mode=block"
		  
		  
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Compress As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		Content As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Cookies As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		GMTOffset As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0
		Headers As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		HTTPVersion As String = "1.1"
	#tag EndProperty

	#tag Property, Flags = &h0
		Request As Backendd.Request
	#tag EndProperty

	#tag Property, Flags = &h0
		Status As String = "200 OK"
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Content"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="HTTPVersion"
			Group="Behavior"
			InitialValue="1.1"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Status"
			Group="Behavior"
			InitialValue="200 OK"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Compress"
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="GMTOffset"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass

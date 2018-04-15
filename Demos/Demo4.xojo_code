#tag Module
Protected Module Demo4
	#tag CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit)) or  (TargetIOS and (Target32Bit or Target64Bit))
	#tag Method, Flags = &h0
		Sub RequestProcess(Request As Backendd.Request)
		  
		  // By default, RequestMapper uses an "htdocs" folder to serve up content.
		  // In this example, we're using an alternate folder.
		  Request.StaticPath = GetFolderItem("").Parent.Child("htdocs").Child("demo-4")
		  
		  // If this is a request for the root...
		  If Request.Path = "/" Or Request.Path = "/index.html" Then
		    Dim Home As New Home(Request)
		  ElseIf Request.Path = "/confidential" Then
		    Dim Confidential As New Confidential(Request)
		  ElseIf Request.Path = "/login" Then
		    Dim Login As New Login(Request)
		  ElseIf Request.Path = "/logout" Then
		    Dim Logout As New Logout(Request)
		  ElseIf Request.Path = "/secret" Then
		    Dim Secret As New Secret(Request)
		  ElseIf Request.Path = "/sessions" Then
		    Dim Sessions As New Sessions(Request)
		  Else
		    
		    // Try to map the request to a file.
		    Request.MapToFile
		    
		    // If the request was mapped to a static file...
		    If Request.Response.Status = "200" Then
		      
		      // Set the Cache-Control header value so that content is cached for 1 hour.
		      Request.Response.Headers.Value("Cache-Control") = "public, max-age=3600"
		      
		    End If
		    
		  End If
		  
		  
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Module
#tag EndModule

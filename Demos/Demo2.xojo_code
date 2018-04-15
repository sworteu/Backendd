#tag Module
Protected Module Demo2
	#tag CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit)) or  (TargetIOS and (Target32Bit or Target64Bit))
	#tag Method, Flags = &h0
		Sub RequestProcess(Request As Backendd.Request)
		  // Maps requests to static files.
		  
		  
		  // By default, RequestMapper uses an "htdocs" folder to serve up content.
		  // In this example, we're using an alternate folder.
		  Request.StaticPath = GetFolderItem("").Parent.Child("htdocs").Child("demo-2")
		  
		  // Map the request to a file.
		  Request.MapToFile
		  
		  // If the request couldn't be mapped to a static file...
		  If Request.Response.Status = "404" Then
		    
		    // Use a custom 404 error handler.
		    Request.Response.Content = "<p>Oh no! That file wasn't found.</p>"
		    
		  Else
		    
		    // Set the Cache-Control header value so that content is cached for 1 hour.
		    Request.Response.Headers.Value("Cache-Control") = "public, max-age=3600"
		    
		    // Add recommended security-related headers to the response.
		    Request.Response.SecurityHeadersSet
		    
		  End If
		  
		  // Log the request.
		  // Note that the value provided by the "X-Forwarded-For" header is being used for the IPAddress,
		  // if it's available. Otherwise, the remote address is used.
		  // You would want to do this if the app is running behind a proxy server,
		  // so that the real remote IP is logged.
		  Dim Logger As New Backendd.Logger
		  Logger.Folder = GetFolderItem("").Parent.Child("logs")
		  Logger.Request = Request
		  Logger.IPAddress = Request.Headers.Lookup("X-Forwarded-For", Request.RemoteAddress)
		  Logger.Run
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
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

#tag Module
Protected Module Demo6
	#tag Method, Flags = &h0
		Sub RequestProcess(Request As Backendd.Request)
		  
		  // Route the request...
		  If Request.Path = "/" Then
		    
		    // The "x" cookie will be set with a 7 day expiration, using a Xojo.Core.Date.
		    Dim ExpirationDate As Xojo.Core.Date
		    Dim DateInterval As Xojo.Core.DateInterval = New Xojo.Core.DateInterval(0, 0, 7, 0, 0, 0)
		    ExpirationDate = Xojo.Core.Date.Now + DateInterval
		    Request.Response.CookieSet("x", "A", ExpirationDate)
		    
		    // The y cookie will be set with a 30 second expiration.
		    Request.Response.CookieSet("y", "B", 0, 0, 0, 30)
		    
		    // The "z" cookie will be set with a 30 day expiration.
		    Request.Response.CookieSet("z", "C", 30)
		    
		    Request.Response.Content = "<p>Cookies have been set.</p>" _
		    + "<p><a href=""/get"">Click here</a> to send them to the server.</p>"
		    
		  ElseIf Request.Path = "/get" Then
		    
		    // Get the cookies from the request.
		    Dim CookieX As String = Request.Cookies.Lookup("x", "")
		    Dim CookieY As String = Request.Cookies.Lookup("y", "")
		    Dim CookieZ As String = Request.Cookies.Lookup("z", "")
		    
		    Request.Response.Content = "<p>" _
		    + "Cookies Received:<br />" _
		    + "x: " + CookieX  + "<br />" _
		    + "y: " + CookieY  + "<br />" _
		    + "z: " + CookieZ _
		    + "</p>"
		    
		  Else
		    
		    // Return a 404 response.
		    Request.Response.Set404Response(Request.Headers, Request.Path)
		    
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

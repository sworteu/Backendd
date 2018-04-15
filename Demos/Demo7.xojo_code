#tag Module
Protected Module Demo7
	#tag Method, Flags = &h0
		Sub RequestProcess(Request As Backendd.Request)
		  // Returns the current date as either a JSON or HTML response,
		  // depending on the "Accept" header value passed by the caller.
		  
		  
		  // Get the current time in RFC1123 format.
		  Dim Now As String = Backendd.DateToRFC1123(Xojo.Core.Date.Now)
		  
		  
		  // Get the Accepts header from the request.
		  Dim Accepts As String = Request.Headers.Lookup("Accept", "")
		  
		  
		  // If the client wants a JSON response...
		  If Accepts = "application/json" Then
		    
		    // Create an return a JSON response.
		    Dim CurrentDate As New JSONItem
		    CurrentDate.Value("Now") = Now
		    Request.Response.Content = CurrentDate.ToString
		    Request.Response.Headers.Value("Content-Type") = "application/json"
		    
		  Else
		    
		    // Return an HTML Response.
		    Request.Response.Content = "<p>The time is: " + Now + "</p>"
		    
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

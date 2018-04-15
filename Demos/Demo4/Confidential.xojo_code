#tag Class
Protected Class Confidential
	#tag CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit)) or  (TargetIOS and (Target32Bit or Target64Bit))
	#tag Method, Flags = &h0
		Sub Constructor(Request As Backendd.Request)
		  // Store the request instance so that it can be used throughout the class.
		  Self.Request = Request
		  
		  
		  // Get a session.
		  Session = App.SessionEngine.SessionGet(Request)
		  
		  
		  // If the user has not been authenticated...
		  If Session.Value("Authenticated") = False Then
		    Request.Response.MetaRedirect("/login")
		    Return
		  End If
		  
		  
		  // Create a folderitem that points to the template file.
		  Dim FI as FolderItem = Request.StaticPath.Child("protected").Child("confidential.pdf")
		  
		  
		  // Use Aloe's FileRead method to load the file.
		  Dim PDFContent As String = Backendd.FileRead(FI)
		  
		  
		  // Update the response content.
		  Request.Response.Content = PDFContent
		  
		  
		  // Specify the mime type using the Content-Type header.
		  Request.Response.Headers.Value("Content-Type") = Backendd.MIMETypeGet("pdf")
		  
		  
		  // Specify the filename using the Content-Disposition header.
		  Request.Response.Headers.Value("Content-Disposition") = "inline; filename=confidential.pdf"
		  
		  
		  // Update the request status code.
		  Request.Response.Status = "200"
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Request As Backendd.Request
	#tag EndProperty

	#tag Property, Flags = &h0
		Session As Xojo.Core.Dictionary
	#tag EndProperty


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
End Class
#tag EndClass

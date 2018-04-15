#tag Module
Protected Module Demo10
	#tag CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit)) or  (TargetIOS and (Target32Bit or Target64Bit))
	#tag Method, Flags = &h0
		Sub RequestProcess(Request As Backendd.Request)
		  // Demonstrates the use of Aloe's Template class.
		  
		  
		  // By default, RequestMapper uses an "htdocs" folder to serve up content.
		  // In this example, we're using an alternate folder.
		  Request.StaticPath = GetFolderItem("").Parent.Child("htdocs").Child("demo-10")
		  
		  
		  // Process the request based on the path of the requested resource...
		  If Request.Path = "/" or Request.Path = "/index.html" Then
		    
		    Dim Page As New IndexPage
		    Page.Request = Request
		    Page.Generate
		    
		  ElseIf Request.Path = "/system-demo.html" Then
		    
		    Dim Page As New SystemPage
		    Page.Request = Request
		    Page.Generate
		    
		  Else
		    
		    Request.MapToFile
		    
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

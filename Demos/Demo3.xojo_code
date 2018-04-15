#tag Module
Protected Module Demo3
	#tag CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit)) or  (TargetIOS and (Target32Bit or Target64Bit))
	#tag Method, Flags = &h0
		Sub RequestProcess(Request As Backendd.Request)
		  
		  // By default, RequestMapper uses an "htdocs" folder to serve up content.
		  // In this example, we're using an alternate folder.
		  Request.StaticPath = GetFolderItem("").Parent.Child("htdocs").Child("demo-3")
		  
		  
		  // If this is a request for the root...
		  If Request.Path = "/" or Request.Path = "/index.html" Then
		    Dim DrummersList As New DrummersList(Request)
		  Else
		    // Try to map the request to a file.
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

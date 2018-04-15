#tag Module
Protected Module Demo5
	#tag Method, Flags = &h0
		Sub RequestProcess(Request As Backendd.Request)
		  
		  Dim Captain As New JSONItem
		  Captain.Value("Name") = "Jean-Luc Picard"
		  Captain.Value("Species") = "Human"
		  Captain.Value("Birthdate") = "July 13, 2305"
		  Captain.Value("Birthplace") = "La Barre, France, Earth"
		  Captain.Value("Parents") = "Maurice and Yvette Picard"
		  Captain.Value("Starfleet Division") = "Command"
		  
		  Request.Response.Status = "200"
		  Request.Response.Content = Captain.ToString
		  Request.Response.Headers.Value("Content-Type") = Backendd.MIMETypeGet("json")
		  
		  
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

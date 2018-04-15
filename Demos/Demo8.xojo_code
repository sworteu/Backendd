#tag Module
Protected Module Demo8
	#tag Method, Flags = &h0
		Sub RequestProcess(Request As Backendd.Request)
		  // Demonstrates threading.
		  
		  
		  
		  If Request.Path = "/slow" Then
		    
		    // Simulate a long-running process.
		    App.SleepCurrentThread(5000)
		    Request.Response.Content = "This is a slow response."
		    
		  Else
		    
		    Request.Response.Content = "This is a fast response."
		    
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

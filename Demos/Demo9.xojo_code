#tag Module
Protected Module Demo9
	#tag CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit)) or  (TargetIOS and (Target32Bit or Target64Bit))
	#tag Method, Flags = &h0
		Sub RequestProcess(Request As Backendd.Request)
		  // Demonstrates processing requests when the app is running multiple AE server instances.
		  // Note that while a server is listening on port 64003 (see App.MultipleServerDemo), it isn't
		  // "wired up" in this method. If you send a request to that port, you should get a 
		  // "501 Not Implemented" response.
		  
		  
		  If Request.Port = 64000 Then
		    // The "Hello World" demo.
		    Demo1.RequestProcess(Request)
		  ElseIf Request.Port = 64001 Then
		    // The static file server demo.
		    Demo2.RequestProcess(Request)
		  ElseIf Request.Port = 64002 Then
		    // The SQLite database / caching demo.
		    Demo3.RequestProcess(Request)
		  Else 
		    // Used to demonstrate a misconfigured app.
		    // The app is listening on a port, but we have not configured the request processor
		    // to handle it.
		    Request.Response.Status = "501 Not Implemented"
		    Request.Response.Content = "The server is not configured to handle requests on this port."
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ServersLaunch()
		  // See the comments in the App.Run event handler for information about this method.
		  
		  
		  // Create Backendd Server instances to listen on port 64000, 64001, etc.
		  Dim ServerThread1 As New Backendd.ServerThread
		  ServerThread1.Server.Port = 64000
		  ServerThread1.Run
		  
		  Dim ServerThread2 As New Backendd.ServerThread
		  ServerThread2.Server.Port = 64001
		  ServerThread2.Run
		  
		  Dim ServerThread3 As New Backendd.ServerThread
		  ServerThread3.Server.Port = 64002
		  ServerThread3.Run
		  
		  Dim ServerThread4 As New Backendd.ServerThread
		  ServerThread4.Server.Port = 64003
		  ServerThread4.Run
		  
		  
		  // Rock me Amadeus...
		  While True
		    app.DoEvents
		  Wend
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

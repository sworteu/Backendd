#tag Class
Protected Class BackendApp
Inherits ConsoleApplication
	#tag Event
		Function Run(args() as String) As Integer
		  // Create an instance of Backendd.Server, and configure it with optional command-line arguments.
		  AloeServer = New Backendd.Server(args)
		  
		  // Configure server-level session management. 
		  // This is used by the DemoSessions demo module.
		  AloeServer.SessionsEnabled = True
		  
		  // Configure server-level caching.
		  // This is used by the DemoCaching demo module.
		  AloeServer.CachingEnabled = True
		  
		  // Arguments handling.
		  Dim ArgumentsList As New Backendd.Arguments(args)
		  
		  // Execute the open event.
		  RaiseEvent Open(ArgumentsList, Server)
		  
		  // The main loop 
		  While Close = False
		    
		    RaiseEvent Running()
		    
		    Self.DoEvents(MillisecondsSleep)
		    
		  Wend
		  
		  // Call the Close event with return code
		  Return RaiseEvent Finished
		  
		  
		End Function
	#tag EndEvent


	#tag Hook, Flags = &h0, Description = 43616C6C6564207768656E20746865206170706C69636174696F6E2069732061626F757420746F20636C6F73652E205468697320697320746865206C617374206576656E7420746861742077696C6C206265207261697365642E
		Event Finished() As Integer
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Open(Args As Backendd.Arguments, Server As Backendd.Server)
	#tag EndHook

	#tag Hook, Flags = &h0, Description = 5468697320697320746865206D61696E206C6F6F702E
		Event Running()
	#tag EndHook


	#tag Property, Flags = &h21
		Private AloeServer As Backendd.Server
	#tag EndProperty

	#tag Property, Flags = &h0
		Close As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686973206973207468652074696D6520746F206769766520746F207468652073797374656D20696E206D696C6C697365636F6E64732E205468652064656661756C742069732031302C2061206869676865722076616C7565206D65616E7320746861742052756E6E696E672077696C6C2062652063616C6C6564206C657373206F6674656E2E204C6F7765722076616C7565206D65616E732069742077696C6C2062652063616C6C6564206D6F72652E
		MillisecondsSleep As Integer = 10
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return AloeServer
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  // Cannot be set
			End Set
		#tag EndSetter
		Server As Backendd.Server
	#tag EndComputedProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="MillisecondsSleep"
			Group="Behavior"
			InitialValue="10"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Close"
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass

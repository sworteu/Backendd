#tag Class
Protected Class Server
Inherits ServerSocket
	#tag Event
		Function AddSocket() As TCPSocket
		  // Tries to add a socket to the pool.
		  Try
		    
		    // Increment the Socket ID.
		    CurrentSocketID = CurrentSocketID + 1
		    
		    // Create a new instance of Request to act as the socket, and assign it an ID.
		    Dim NewSocket As TCPSocket = New Request(CurrentSocketID, Multithreading)
		    
		    // Return the socket.
		    Return NewSocket
		    
		  Catch e As RunTimeException
		    
		    Dim TypeInfo As Xojo.Introspection.TypeInfo = Xojo.Introspection.GetType(e)
		    
		    System.DebugLog "Aloe Express Server Error: Unable to Add Socket w/ID " + CurrentSocketID.ToText
		    
		  End Try
		  
		End Function
	#tag EndEvent

	#tag Event
		Sub Error(ErrorCode as Integer)
		  System.DebugLog "Aloe Express Server Error: Code: " + ErrorCode.ToText
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub Constructor(Args() As String = Nil)
		  // If arguments were passed...
		  If Args <> Nil Then
		    
		    // Convert any command line arguments into a dictionary.
		    Dim Arguments As Xojo.Core.Dictionary = ArgsToDictionary(Args)
		    
		    // Assign valid arguments to their corresponding properties.
		    Port = If(Arguments.HasKey("--Port"), Val(Arguments.Value("--Port")), 8080)
		    MaximumSocketsConnected = Val(Arguments.Lookup("--MaxSockets", "200"))
		    MinimumSocketsAvailable = Val(Arguments.Lookup("--MinSockets", "50"))
		    Loopback = Arguments.HasKey("--Loopback")
		    If Arguments.HasKey("--Nothreads") Then 
		      Multithreading = False
		    End If
		    
		  End If
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Start()
		  // Starts the server so that it listens for incoming requests.
		  
		  
		  // If the server should use the loopback network interface.
		  If Loopback Then
		    NetworkInterface = NetworkInterface.Loopback
		  End If
		  
		  // Start listening for incoming requests.
		  Listen
		  
		  System.DebugLog "Backendd Server Started... " + EndOfLine _
		  + "• Loopback: " + If(Loopback , "Enabled", "Disabled") + EndOfLine _
		  + "• Maximum Sockets Connected: " + MaximumSocketsConnected.ToText + EndOfLine _
		  + "• Minimum Sockets Available: " + MinimumSocketsAvailable.ToText + EndOfLine _
		  + "• Multithreading: " + If(Multithreading, "Enabled", "Disabled") + EndOfLine _
		  + "• Port: " + Port.ToText + EndOfLine
		  
		  // Original server call moved to Backendd.BackenddApplication class
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		CurrentSocketID As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Loopback As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		Multithreading As Boolean = True
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="CurrentSocketID"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			Type="Integer"
			EditorType="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Loopback"
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="MaximumSocketsConnected"
			Visible=true
			Group="Behavior"
			InitialValue="10"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="MinimumSocketsAvailable"
			Visible=true
			Group="Behavior"
			InitialValue="2"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Multithreading"
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
			EditorType="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Port"
			Visible=true
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
			EditorType="String"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass

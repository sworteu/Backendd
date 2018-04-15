#tag Class
Protected Class BackenddApplication
Inherits ConsoleApplication
	#tag Event
		Function Run(args() as String) As Integer
		  // Create an instance of SessionEngine.
		  SessionEngine = New Backendd.SessionEngine
		  
		  // Create an instance of Backendd.CacheEngine.
		  CacheEngine = New Backendd.CacheEngine
		  
		  // Raise the open event with the arguments
		  RaiseEvent Open(args)
		  
		  // Create an instance of Backendd.Server, and configure it with optional command-line arguments.
		  Server = New Backendd.Server(args)
		  
		  // Start the server.
		  Server.Start
		  
		  // Keep the Backendd alive untill there is a given stop/exit/quit command.
		  While Not StopServer
		    
		    If IsDaemon = False Then
		      // When IsDaemon = True, no commands can be parsed to the daemon.
		      // So when it's a daemon we skip the MainLoop
		      RaiseEvent MainLoop 'Run the main loop
		    End If
		    
		    App.DoEvents(10) 'Lower value is faster running.
		    
		  Wend
		  
		  // The loop is ended, let's call the close event
		  RaiseEvent Close
		  
		  // Let's return the right return-code
		  Return 0
		End Function
	#tag EndEvent

	#tag Event
		Function UnhandledException(error As RuntimeException) As Boolean
		  // Log the error to a debug/start log
		  // Usefull to track exceptions.
		  Dim out As TextOutputStream
		  Dim LogFolder As FolderItem = GetFolderItem("").Child("logs")
		  Dim LogFile As FolderItem
		  Dim d As New Date
		  If LogFolder <> Nil Then
		    If LogFolder.Exists = False Then
		      LogFolder.CreateAsFolder
		    End If
		    LogFile = LogFolder.Child("exceptions.log")
		    Try 
		      out = TextOutputStream.Create(LogFile)
		      out.WriteLine(d.SQLDateTime + " : " + "Exception: " + error.Message + " : " + Str(error.ErrorNumber))
		      out.Close
		    End Try
		  End If
		  
		  // Re-raise the event in case there is more to handle:
		  Return RaiseEvent UnhandledException(error)
		End Function
	#tag EndEvent


	#tag Hook, Flags = &h0
		Event Close()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event MainLoop()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Open(Args() As String)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event UnhandledException(Error As RuntimeException) As Boolean
	#tag EndHook


	#tag Property, Flags = &h0
		CacheEngine As Backendd.CacheEngine
	#tag EndProperty

	#tag Property, Flags = &h0
		IsDaemon As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		Server As Backendd.Server
	#tag EndProperty

	#tag Property, Flags = &h0
		SessionEngine As Backendd.SessionEngine
	#tag EndProperty

	#tag Property, Flags = &h0
		StopServer As Boolean = False
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="IsDaemon"
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="StopServer"
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass

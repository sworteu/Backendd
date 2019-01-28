#tag Class
Protected Class SessionEngine
Inherits Timer
	#tag CompatibilityFlags = ( TargetConsole and ( Target32Bit or Target64Bit ) ) or ( TargetWeb and ( Target32Bit or Target64Bit ) ) or ( TargetDesktop and ( Target32Bit or Target64Bit ) ) or ( TargetIOS and ( Target32Bit or Target64Bit ) )
	#tag Event
		Sub Action()
		  SessionsSweep
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub Constructor(SweepIntervalSecs As Integer = 300)
		  // Initilize the Sessions dictionary.
		  Sessions = New Dictionary
		  
		  // Set the SweepIntervalSecs property.
		  Self.SweepIntervalSecs = SweepIntervalSecs
		  
		  // Schedule the SessionSweep process.
		  Period = SweepIntervalSecs * 1000
		  Mode = Timer.ModeMultiple
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SessionGet(Request As Backendd.Request, AssignNewID As Boolean = True) As Dictionary
		  // Returns a session for the request.
		  // If an existing session is available, then it is returned.
		  // Otherwise a new session is created and returned.
		  
		  
		  // This is the session that we'll return.
		  Dim Session As Dictionary
		  
		  
		  // This will be used if a new SessionID is assigned.
		  Dim NewSessionID As String
		  
		  
		  // Get the current date/time.
		  Dim Now As New Date
		  
		  
		  // Get the original Session ID, if applicable.
		  Dim OriginalSessionID As String = Request.Cookies.Lookup("SessionID", "")
		  
		  
		  // If the user has a Session ID cookie...
		  If OriginalSessionID <> "" Then
		    
		    // If the Session ID matches a session in the Sessions dictionary...
		    If Sessions.HasKey(OriginalSessionID) = True Then
		      
		      // Get the session.
		      Session = Sessions.Value(OriginalSessionID)
		      
		      // Get the session's LastRequestTimestamp.
		      Dim LastRequestTimestamp As Date = Session.Value("LastRequestTimestamp")
		      
		      // Determine the time that has elapsed since the last request.
		      Dim TimeElapsed As Double = Now.TotalSeconds - LastRequestTimestamp.TotalSeconds
		      
		      // If the session has expired...
		      If TimeElapsed > SessionsTimeOutSecs Then
		        
		        // Remove the session from the array.
		        Sessions.Remove(OriginalSessionID)
		        
		        // Clear the session.
		        Session = Nil
		        
		      End If
		      
		    End If
		    
		  End If
		  
		  
		  // If an existing session is available...
		  If Session <> Nil Then
		    
		    // Update the session's LastRequestTimestamp.
		    Session.Value("LastRequestTimestamp") = Now
		    
		    // Increment the session's Request Count.
		    Session.Value("RequestCount") = Session.Value("RequestCount") + 1
		    
		    // If we're not going to assign a new Session ID to the existing session...
		    If AssignNewID = False Then
		      
		      // Return the session to the caller.
		      Return Session
		      
		    End If
		    
		    // Assign a new Session ID to the existing session.
		    
		    // Generate a new Session ID.
		    NewSessionID = UUIDGenerate
		    
		    // Update the session with the new ID.
		    Session.Value("SessionID") = NewSessionID
		    
		    // Add the new session to the Sessions dictionary.
		    Sessions.Value(NewSessionID) = Session
		    
		    // Remove the old session from the Sessions dictionary.
		    Sessions.Remove(OriginalSessionID)
		    
		  Else
		    
		    // We were unable to re-use an existing session, so create a new one...
		    
		    // Generate a new Session ID.
		    NewSessionID = UUIDGenerate
		    
		    // Create a new session dictionary.
		    Session = New Dictionary
		    Session.Value("SessionID") = NewSessionID
		    Session.Value("LastRequestTimestamp") = Now
		    Session.Value("RemoteAddress") = Request.RemoteAddress
		    Session.Value("UserAgent") = Request.Headers.Lookup("User-Agent", "")
		    Session.Value("RequestCount") = 1
		    Session.Value("Authenticated") = False
		    
		  End If
		  
		  
		  // Add the session to the Sessions dictionary.
		  Sessions.Value(NewSessionID) = Session
		  
		  
		  // Set the cookie expiration date.
		  Dim CookieExpiration As New Date
		  CookieExpiration.Second = CookieExpiration.Second + SessionsTimeOutSecs
		  
		  
		  // Drop the SessionID cookie.
		  Request.Response.CookieSet("SessionID", NewSessionID, CookieExpiration)
		  
		  
		  // Return the session to the caller.
		  Return Session
		  
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SessionsSweep()
		  // Removes any expired sessions from the Sessions array.
		  // This prevents the array from growing unnecessarily due to orphaned sessions.
		  
		  
		  // Get the current date/time.
		  Dim Now As New Date
		  
		  // This is an array of the session IDs that have expired.
		  Dim ExpiredSessionIDs() As String
		  
		  // Loop over the dictionary entries...
		  For Each Key As Variant in Sessions.Keys
		    
		    // Get the entry's value.
		    Dim Session As Dictionary = Sessions.Value(Key)
		    
		    // Get the session's LastRequestTimestamp.
		    Dim LastRequestTimestamp As Date = Session.Value("LastRequestTimestamp")
		    
		    // Determine the time that has elapsed since the last request.
		    Dim TimeElapsedSecs As Double = Now.TotalSeconds - LastRequestTimestamp.TotalSeconds
		    
		    // If the session has expired...
		    If TimeElapsedSecs > SessionsTimeOutSecs Then
		      
		      // Append the session's key to the array.
		      ExpiredSessionIDs.Append(Key)
		      
		    End If
		    
		  Next
		  
		  // Removed the expired sessions...
		  For Each SessionID As String in ExpiredSessionIDs
		    Sessions.Remove(SessionID)
		  Next
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SessionTerminate(Session As Dictionary)
		  // Terminates a given session.
		  
		  
		  // If the session still exists...
		  If Sessions.HasKey(Session.Value("SessionID")) Then
		    
		    // Remove the session from the array of sessions.
		    Sessions.Remove(Session.Value("SessionID"))
		    
		  End If
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Sessions As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		SessionsTimeOutSecs As Integer = 600
	#tag EndProperty

	#tag Property, Flags = &h0
		SweepIntervalSecs As Integer = 300
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Mode"
			Visible=true
			Group="Behavior"
			InitialValue="2"
			Type="Integer"
			EditorType="Enum"
			#tag EnumValues
				"0 - Off"
				"1 - Single"
				"2 - Multiple"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="Period"
			Visible=true
			Group="Behavior"
			InitialValue="1000"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
			EditorType="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
			EditorType="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SweepIntervalSecs"
			Group="Behavior"
			InitialValue="300"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SessionsTimeOutSecs"
			Group="Behavior"
			InitialValue="600"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass

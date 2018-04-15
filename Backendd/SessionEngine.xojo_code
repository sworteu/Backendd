#tag Class
Protected Class SessionEngine
	#tag CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit)) or  (TargetIOS and (Target32Bit or Target64Bit))
	#tag Method, Flags = &h0
		Sub Constructor(SweepIntervalSecs As Integer = 300)
		  // Initilize the Sessions dictionary.
		  Sessions = New Xojo.Core.Dictionary
		  
		  // Set the SweepIntervalSecs property.
		  Self.SweepIntervalSecs = SweepIntervalSecs
		  
		  // Schedule the SessionSweep process.
		  Xojo.Core.Timer.CallLater(SweepIntervalSecs * 1000, AddressOf SessionsSweep)
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SessionGet(Request As Backendd.Request, AssignNewID As Boolean=True) As Xojo.Core.Dictionary
		  // Returns a session for the request.
		  // If an existing session is available, then it is returned.
		  // Otherwise a new session is created and returned.
		  
		  // This is the session that we'll return.
		  Dim Session As Xojo.Core.Dictionary
		  
		  // This will be used if a new SessionID is assigned.
		  Dim NewSessionID As String
		  
		  // Get the expiration date to use for the SessionID cookie....
		  // Get the current date.
		  Dim CurrentDate As Xojo.Core.Date = Xojo.Core.Date.Now
		  // Create a TimeZone set to GMT.
		  Dim GMT As New Xojo.Core.TimeZone(0)
		  // Adjust the current date so that it is based on GMT.
		  CurrentDate = New Xojo.Core.Date(CurrentDate.SecondsFrom1970, GMT)
		  // Create a date interval.
		  Dim DI As New Xojo.Core.DateInterval
		  DI.Days = 1
		  // Create the expiration date.
		  Dim ExpirationDate As Xojo.Core.Date = CurrentDate + DI
		  
		  
		  // Get the original Session ID, if applicable.
		  Dim OriginalSessionID As String = Request.Cookies.Lookup("SessionID", "")
		  
		  // If the user has a Session ID cookie...
		  If OriginalSessionID <> "" Then
		    
		    // If the Session ID matches a session in the Sessions dictionary...
		    If Sessions.HasKey(OriginalSessionID) = True Then
		      
		      // Get the session.
		      Session = Sessions.Value(OriginalSessionID)
		      
		      // Get the session's LastRequestTimestamp.
		      Dim LastRequestTimestamp As Xojo.Core.Date = Session.Value("LastRequestTimestamp")
		      
		      // Create a date interval based on the SessionsTimeOutSecs setting.
		      Dim SecondsInterval As New xojo.Core.DateInterval
		      SecondsInterval.Seconds = SessionsTimeOutSecs
		      
		      // Determine the session's timeout date.
		      Dim SessionTimeOut As Xojo.Core.Date = LastRequestTimestamp + SecondsInterval
		      
		      // If the session has expired...
		      If Xojo.Core.Date.Now.SecondsFrom1970 >= SessionTimeOut.SecondsFrom1970 Then
		        
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
		    Session.Value("LastRequestTimestamp") = Xojo.Core.Date.Now
		    
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
		    Session = New Xojo.Core.Dictionary
		    Session.Value("SessionID") = NewSessionID
		    Session.Value("LastRequestTimestamp") = Xojo.Core.Date.Now
		    Session.Value("RemoteAddress") = Request.RemoteAddress
		    Session.Value("UserAgent") = Request.Headers.Lookup("User-Agent", "")
		    Session.Value("RequestCount") = 1
		    Session.Value("Authenticated") = False
		    
		  End If
		  
		  
		  // Add the session to the Sessions dictionary.
		  Sessions.Value(NewSessionID) = Session
		  
		  
		  // Drop the SessionID cookie.
		  Request.Response.CookieSet("SessionID", NewSessionID, ExpirationDate)
		  
		  
		  // Return the session to the caller.
		  Return Session
		  
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SessionsSweep()
		  // Removes any expired sessions from the Sessions array.
		  // This prevents the array from growing unnecessarily due to orphaned sessions.
		  
		  
		  // Continue trying to iterate through the dictionary until we get all the way through it...
		  Dim TryAgain As Boolean = False
		  Do
		    
		    // Try to remove expired sessions...
		    Try
		      
		      // Assume that we'll be able to iterate through the entire dictionary.
		      TryAgain = False
		      
		      
		      // Loop over the dictionary entries...
		      For Each Entry As Xojo.Core.DictionaryEntry in Sessions
		        
		        // Get the entry's key and value.
		        Dim SessionID As String = Entry.Key
		        Dim Session As Xojo.Core.Dictionary = Entry.Value
		        
		        // Get the session's LastRequestTimestamp.
		        Dim LastRequestTimestamp As Xojo.Core.Date = Session.Value("LastRequestTimestamp")
		        
		        // Create a date interval based on the SessionsTimeOutSecs setting.
		        Dim SecondsInterval As New xojo.Core.DateInterval
		        SecondsInterval.Seconds = SessionsTimeOutSecs
		        
		        // Determine the session's timeout date.
		        Dim SessionTimeOut As Xojo.Core.Date = LastRequestTimestamp + SecondsInterval
		        
		        // If the session has expired...
		        If Xojo.Core.Date.Now.SecondsFrom1970 >= SessionTimeOut.SecondsFrom1970 Then
		          
		          // Remove the session from the array.
		          Sessions.Remove(SessionID)
		          
		        End If
		        
		      Next
		      
		    Catch IteratorException
		      
		      // Woot!
		      TryAgain = True
		      
		    End Try
		    
		  Loop Until TryAgain = False
		  
		  // Schedule the next sessions sweep.
		  Xojo.Core.Timer.CallLater(SweepIntervalSecs * 1000, AddressOf SessionsSweep)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SessionTerminate(Session As Xojo.Core.Dictionary)
		  // Terminates a given session.
		  
		  
		  // If the session still exists...
		  If Sessions.HasKey(Session.Value("SessionID")) Then
		    
		    // Remove the session from the array of sessions.
		    Sessions.Remove(Session.Value("SessionID"))
		    
		  End If
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Sessions As Xojo.Core.Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		SessionsTimeOutSecs As Integer = 600
	#tag EndProperty

	#tag Property, Flags = &h0
		SweepIntervalSecs As Integer = 300
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
			Name="SessionsTimeOutSecs"
			Group="Behavior"
			InitialValue="600"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SweepIntervalSecs"
			Group="Behavior"
			InitialValue="300"
			Type="Integer"
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

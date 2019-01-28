#tag Class
Protected Class CacheEngine
Inherits Timer
	#tag Event
		Sub Action()
		  // Removes expired entries from the cache.
		  Sweep
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub Constructor(SweepIntervalSecs As Integer = 300)
		  // Initilize the Cache dictionary.
		  Cache = New Dictionary
		  
		  // Set the SweepIntervalSecs property.
		  Self.SweepIntervalSecs = SweepIntervalSecs
		  
		  // Schedule the CacheSweep process.
		  Period = SweepIntervalSecs * 1000
		  Mode = Timer.ModeMultiple
		  
		  
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Delete(Name As String)
		  // Deletes an object from the cache.
		  
		  
		  // If the value is in the cache...
		  If Cache.HasKey(Name) Then
		    
		    // Remove the expired cache entry.
		    Cache.Remove(Name)
		    
		  End If
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Get(Name As String) As Dictionary
		  // Gets an object from the cache, and checks its expiration date.
		  // If the object is found, but it has expired, it is deleted from the cache.
		  
		  
		  // If the value is in the cache...
		  If Cache.HasKey(Name) Then
		    
		    // Get the cache entry.
		    Dim CacheEntry As Dictionary = Cache.Value(Name)
		    
		    // Get the cache's expiration date.
		    Dim Expiration As Date = CacheEntry.Value("Expiration")
		    
		    // Get the current date.
		    Dim Now As New Date
		    
		    // If the cache has not expired...
		    If Expiration > Now Then
		      
		      // Return the cached content.
		      Return CacheEntry
		      
		    Else
		      
		      // Remove the expired cache entry.
		      Cache.Remove(Name)
		      
		      Return Nil
		      
		    End If
		    
		  End If
		  
		  
		  
		  
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Put(Name As String, Content As Variant, ExpirationSecs As Integer)
		  // Puts an object into the cache, and sets its expiration date.
		  
		  
		  // Create the expiration date/time.
		  Dim Expiration As New Date
		  Expiration.Second = Expiration.Second + ExpirationSecs
		  
		  // Get the current date/time.
		  Dim Now As New Date
		  
		  // Create the cache entry.
		  Dim CacheEntry As New Dictionary
		  CacheEntry.Value("Content") = Content
		  CacheEntry.Value("Expiration") = Expiration
		  CacheEntry.Value("Entered") = Now
		  
		  // Add the entry to the cache.
		  Cache.Value(Name) = CacheEntry
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Reset()
		  // Resets the cache.
		  
		  Cache = New Dictionary
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Sweep()
		  // Removes expired objects from the cache.
		  // This prevents the cache from growing unnecessarily due to orphaned objects.
		  
		  
		  // Get the current date/time.
		  Dim Now As New Date
		  
		  // This is an array of the cache names that have expired.
		  Dim ExpiredCacheNames() As String
		  
		  // Loop over the entries in the cache array...
		  For Each Key As Variant in Cache.Keys
		    
		    // Get the entry's value.
		    Dim CacheEntry As Dictionary = Cache.Value(Key)
		    
		    // Set the expiration date.
		    Dim Expiration As Date = CacheEntry.Value("Expiration")
		    
		    // If the session has expired...
		    If Now > Expiration Then
		      
		      // Append the cache name to the array.
		      ExpiredCacheNames.Append(Key)
		      
		    End If
		    
		  Next
		  
		  // Removed the cache entries...
		  For Each CacheName As String in ExpiredCacheNames
		    Cache.Remove(CacheName)
		  Next
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Cache As Dictionary
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
			InitialValue="60"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass

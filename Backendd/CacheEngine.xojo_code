#tag Class
Protected Class CacheEngine
	#tag Method, Flags = &h0
		Sub Constructor(SweepIntervalSecs As Integer = 300)
		  // Initilize the Cache dictionary.
		  Cache = New Xojo.Core.Dictionary
		  
		  // Set the SweepIntervalSecs property.
		  Self.SweepIntervalSecs = SweepIntervalSecs
		  
		  // Schedule the CacheSweep process.
		  Xojo.Core.Timer.CallLater(SweepIntervalSecs * 1000, AddressOf Sweep)
		  
		  
		  
		  
		  
		  
		  
		  
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
		Function Get(Name As String) As Xojo.Core.Dictionary
		  // Gets an object from the cache, and checks its expiration date.
		  // If the object is found, but it has expired, it is deleted from the cache.
		  
		  
		  // If the value is in the cache...
		  If Cache.HasKey(Name) Then
		    
		    // Get the cache entry.
		    Dim CacheEntry As Xojo.Core.Dictionary = Cache.Value(Name)
		    
		    // Get the cache's expiration date.
		    Dim Expiration As Xojo.Core.Date = CacheEntry.Value("Expiration")
		    
		    // If the cache has not expired...
		    If Xojo.Core.Date.Now.SecondsFrom1970 < Expiration.SecondsFrom1970 Then
		      
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
		Sub Put(Name As String, Content As Auto, ExpirationSecs As Integer)
		  // Puts an object into the cache, and sets its expiration date.
		  
		  
		  // Create a date interval based on the ExpirationSecs param.
		  Dim SecondsInterval As New xojo.Core.DateInterval
		  SecondsInterval.Seconds = ExpirationSecs
		  
		  // Determine the cache's expiration date.
		  Dim Expiration As Xojo.Core.Date = Xojo.Core.Date.Now + SecondsInterval
		  
		  // Create the cache entry.
		  Dim CacheEntry As New Xojo.Core.Dictionary
		  CacheEntry.Value("Content") = Content
		  CacheEntry.Value("Expiration") = Expiration
		  CacheEntry.Value("Entered") = Xojo.Core.Date.Now
		  
		  // Add the entry to the cache.
		  Cache.Value(Name) = CacheEntry
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Reset()
		  // Resets the cache.
		  
		  Cache = New Xojo.Core.Dictionary
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Sweep()
		  // Removes expired objects from the cache.
		  // This prevents the cache from growing unnecessarily due to orphaned objects.
		  
		  
		  // Continue trying to iterate through the dictionary until we get all the way through it...
		  Dim TryAgain As Boolean = False
		  Do
		    
		    // Try to remove expired content...
		    Try
		      
		      // Assume that we'll be able to iterate through the entire dictionary.
		      TryAgain = False
		      
		      // Loop over the entries in the cache array...
		      For Each Entry As Xojo.Core.DictionaryEntry In Cache
		        
		        // Get the entry's name value.
		        Dim CacheName As String = Entry.Key
		        Dim CacheEntry As Xojo.Core.Dictionary = Entry.Value
		        
		        // Get the cache's expiration date.
		        Dim Expiration As Xojo.Core.Date = CacheEntry.Value("Expiration")
		        
		        // If the cache has expired...
		        If Xojo.Core.Date.Now.SecondsFrom1970 > Expiration.SecondsFrom1970 Then
		          
		          // Remove the expired cache entry.
		          Cache.Remove(CacheName)
		          
		        End If
		        
		      Next
		      
		    Catch IteratorException
		      
		      // Woot!
		      TryAgain = True
		      
		    End Try
		    
		  Loop Until TryAgain = False
		  
		  
		  // Schedule the next sessions sweep.
		  Xojo.Core.Timer.CallLater(SweepIntervalSecs * 1000, AddressOf Sweep)
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Cache As Xojo.Core.Dictionary
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
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SweepIntervalSecs"
			Group="Behavior"
			InitialValue="60"
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

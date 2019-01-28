#tag Class
Protected Class Arguments
Inherits Dictionary
	#tag Method, Flags = &h0
		Sub Constructor(Args() As String)
		  // Calling the overridden superclass constructor.
		  Super.Constructor
		  
		  // Load the Args
		  Load(Args)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Load(Args() As String)
		  // Converts the Arguments to a Dictionary - String based
		  Dim CurrentArg, CurrentKey, CurrentValue As String
		  
		  If Args.Ubound > -1 Then
		    
		    For i As Integer = 0 to Args.Ubound
		      
		      If i = 0 Then
		        // This should be the path to the executable.
		        zPath = Args(i)
		        
		      Else
		        // This is an argument
		        
		        CurrentArg = Args(i)
		        
		        CurrentKey = CurrentArg.NthField("=",1)
		        CurrentValue = CurrentArg.NthField("=",2)
		        
		        If CurrentKey <> "" Then
		          // We only store keys when they are not empty strings
		          
		          Self.Value(CurrentKey) = CurrentValue
		          
		        End If
		        
		      End If
		      
		    Next
		    
		  End If
		End Sub
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return zPath
			End Get
		#tag EndGetter
		Path As String
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private zPath As String
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="BinCount"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Count"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
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
		#tag ViewProperty
			Name="Path"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass

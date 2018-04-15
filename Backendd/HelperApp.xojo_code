#tag Class
Protected Class HelperApp
Inherits Shell
	#tag Event
		Sub DataAvailable()
		  // Get the result from the helper app.
		  Result = ReadAll
		  
		  // Update the "Running" status.
		  Running = False
		  
		  
		  
		  
		  
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h1000
		Sub Constructor()
		  // Execute the helper app in Asynchronous mode.
		  Mode = 1 
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Launch()
		  // Launches the helper app.
		  
		  
		  // Determine the helper app's filename.
		  Dim Filename As String = Name
		  #If TargetWindows Then
		    Filename = Filename + ".exe"
		  #Endif
		  
		  // Create a folderitem that points to the app.
		  Dim HelperApp As New FolderItem
		  HelperApp = GetFolderItem("").Parent.Child("helpers").Child(Name).Child(Filename)
		  
		  //  If the folderitem is valid...
		  If HelperApp <> nil Then
		    
		    // If the app exists...
		    If HelperApp.Exists Then
		      
		      // Launch the app.
		      Execute(HelperApp.ShellPath, Parameters)
		      
		      // Update the running status.
		      Running = True
		      
		      // Wait for the helper app to complete...
		      While Running
		        app.DoEvents
		      Wend
		      
		    End If
		    
		  End If
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Name As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Parameters As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Result As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Running As Boolean = False
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Arguments"
			Visible=true
			Type="String"
			EditorType="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Backend"
			Visible=true
			Type="String"
			EditorType="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Canonical"
			Visible=true
			Type="Boolean"
			EditorType="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Mode"
			Visible=true
			Type="Integer"
			EditorType="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Parameters"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Result"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Running"
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TimeOut"
			Visible=true
			Type="Integer"
			EditorType="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass

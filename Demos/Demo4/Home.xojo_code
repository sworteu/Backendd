#tag Class
Protected Class Home
	#tag CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit)) or  (TargetIOS and (Target32Bit or Target64Bit))
	#tag Method, Flags = &h0
		Sub BodyContentGenerate()
		  // If the user has not been authenticated...
		  If Session.Value("Authenticated") = False Then
		    
		    // Display the public content.
		    BodyContent = ContentPublic
		    
		  Else
		    
		    // Display the private content.
		    BodyContent = ContentPrivate
		    BodyContent = BodyContent.ReplaceAll("[[UserName]]", Session.Lookup("Username", ""))
		    
		  End If
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(Request As Backendd.Request)
		  // Store the request instance so that it can be used throughout the class.
		  Self.Request = Request
		  
		  
		  // Get a session.
		  Session = App.SessionEngine.SessionGet(Request)
		  
		  
		  // Generate the body content.
		  BodyContentGenerate
		  
		  
		  // Display the page.
		  PageDisplay
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PageDisplay()
		  // Load the template.
		  TemplateLoad
		  
		  
		  // Substitute special tokens.
		  HTML = HTML.ReplaceAll("[[H1]]", "Session Engine Demo")
		  HTML = HTML.ReplaceAll("[[Content]]", BodyContent)
		  
		  
		  // Update the response content.
		  Request.Response.Content = HTML
		  
		  
		  // Update the response status code.
		  Request.Response.Status = "200"
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub TemplateLoad()
		  // Loads the template file.
		  
		  // Create a folderitem that points to the template file.
		  Dim FI as FolderItem = Request.StaticPath.Child("template.html")
		  
		  // Use Aloe's FileRead method to load the file.
		  HTML = Backendd.FileRead(FI)
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		BodyContent As String
	#tag EndProperty

	#tag Property, Flags = &h0
		HTML As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Request As Backendd.Request
	#tag EndProperty

	#tag Property, Flags = &h0
		Session As Xojo.Core.Dictionary
	#tag EndProperty


	#tag Constant, Name = ContentPrivate, Type = String, Dynamic = False, Default = \"<p>\nHello\x2C [[UserName]]!\n</p>\n<p>\nNow that you\'re logged in\x2C you can:\n<ul>\n<li>Learn the <a href\x3D\"/secret\">Secret of Life</a>.</li>\n<li>Access a <a href\x3D\"/confidential\">Confidential Document</a>.</li>\n<li>View the <a href\x3D\"/sessions\">Sessions</a> that are being managed by SessionEngine.</li>\n</ul>\n</p>\n<p>\nOh yeah\x2C you can also <a href\x3D\"/logout\">logout</a>.\n</p>", Scope = Public
	#tag EndConstant

	#tag Constant, Name = ContentPublic, Type = String, Dynamic = False, Default = \"<p>\nUnfortunately\x2C you\'re not logged in. So you can\'t see or do much...\n</p>\n<p>\nWhy don\'t you <a href\x3D\"/login\">login</a> and see what happens\?\n</p>", Scope = Public
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="BodyContent"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="HTML"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
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
	#tag EndViewBehavior
End Class
#tag EndClass

#tag Class
Protected Class Login
	#tag CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit)) or  (TargetIOS and (Target32Bit or Target64Bit))
	#tag Method, Flags = &h0
		Sub BodyContentGenerate()
		  // If the form has been submitted and validation errors were found...
		  If ValidationErrors.Ubound > -1 Then
		    
		    // We'll include information about the errors.
		    BodyContent = ErrorsIntro
		    
		    // Build the list of errors...
		    Dim ErrorsList As String
		    For i As integer = 0 to ValidationErrors.Ubound
		      ErrorsList = ErrorsList _
		      + "<li>" + ValidationErrors(i) + "</li>" + EndOfLine
		    Next
		    
		    // Replace the token with the errors.
		    BodyContent = BodyContent.ReplaceAll("[[Errors]]", ErrorsList)
		    
		  End If
		  
		  
		  // Add the form.
		  BodyContent = BodyContent + FormHTML
		  BodyContent = BodyContent.ReplaceAll("[[username]]", Request.POST.Lookup("username", ""))
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(Request As Backendd.Request)
		  // Store the request instance so that it can be used throughout the class.
		  Self.Request = Request
		  
		  
		  // Get a session.
		  Session = App.SessionEngine.SessionGet(Request)
		  
		  
		  // If the form has been submitted...
		  If Request.Method = "Post" Then
		    
		    // Validate the form.
		    FormValidate
		    
		    // If no validation errors were found...
		    If ValidationErrors.Ubound = -1 Then
		      
		      // Try to authenticate the user.
		      UserAuthenticate
		      
		    End If
		    
		  End If
		  
		  
		  // If the user has been authenticated...
		  If Session.Value("Authenticated") = True Then
		    Request.Response.MetaRedirect("/")
		    Return
		  End If
		  
		  
		  // Generate the body content.
		  BodyContentGenerate
		  
		  
		  // Display the page.
		  PageDisplay
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub FormValidate()
		  
		  Dim Username As String = Request.POST.Lookup("username", "")
		  If Username = "" Then
		    ValidationErrors.Append("You did not enter your username.")
		  End If
		  
		  Dim Password As String = Request.POST.Lookup("password", "")
		  If Password = "" Then
		    ValidationErrors.Append("You did not enter your password.")
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PageDisplay()
		  // Load the template.
		  TemplateLoad
		  
		  
		  // Substitute special tokens.
		  HTML = HTML.ReplaceAll("[[H1]]", "Login")
		  HTML = HTML.ReplaceAll("[[Content]]", BodyContent)
		  
		  
		  // Update the response content.
		  Request.Response.Content = HTML
		  
		  
		  // Update the request status code.
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

	#tag Method, Flags = &h0
		Sub UserAuthenticate()
		  // If the password was incorrect...
		  Dim Password As String = Request.POST.Lookup("password", "")
		  If Password <> "secret" Then
		    ValidationErrors.Append("The password that you provided is incorrect.")
		    Return
		  End
		  
		  
		  // Update the session's "Authenticated" value.
		  Session.Value("Authenticated") = True
		  
		  
		  // Store the username in the session.
		  Session.Value("Username") = Request.POST.Value("username")
		  
		  
		  
		  
		  
		  
		  
		  
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

	#tag Property, Flags = &h0
		ValidationErrors() As String
	#tag EndProperty


	#tag Constant, Name = ErrorsIntro, Type = String, Dynamic = False, Default = \"<p>\nSorry\x2C but we are unable to log you in because:\n<ul>\n[[Errors]]\n</ul>\n</p>\n<p>\nPlease try again.\n</p>", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FormHTML, Type = String, Dynamic = False, Default = \"<form method\x3D\"POST\" action\x3D\"/login\" enctype\x3D\"application/x-www-form-urlencoded\">\n<p>\n<label for\x3D\"username\">Username:</label><br />\n<input name\x3D\"username\" type\x3D\"text\" value\x3D\"[[username]]\" placeholder\x3D\"Any username will do.\" required autofocus>\n</p>\n<p>\n<label for\x3D\"password\">Password:</label><br />\n<input name\x3D\"password\" type\x3D\"password\" placeholder\x3D\"The password is: secret\" required>\n</p>\n<p>\n<input name\x3D\"login\" type\x3D\"submit\" value\x3D\"Login\">\n</p>\n</form>", Scope = Public
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

#tag Class
Protected Class SystemPage
	#tag Method, Flags = &h0
		Sub Generate()
		  // Use an instance of Template to merge the template with the system data.
		  // This page uses ony system tokens, so we're not providing data for the hash.
		  Dim Template As New Backendd.Template
		  Template.Request = Request
		  Template.Source = Backendd.FileRead(Request.StaticPath.Child("template-system.html"))
		  Template.Merge
		  
		  // Update the response content with the expanded template.
		  Request.Response.Content = Template.Expanded
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Request As Backendd.Request
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
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass

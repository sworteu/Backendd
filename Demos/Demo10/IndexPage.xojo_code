#tag Class
Protected Class IndexPage
	#tag Method, Flags = &h0
		Sub Generate()
		  // Load the JSON data file.
		  Dim Data As String = Backendd.FileRead(Request.StaticPath.Child("orders.json"))
		  
		  // Parse the JSON.
		  Dim DataJSON As Auto = Xojo.Data.ParseJSON(Data.ToText)
		  
		  // Convert the JSON to a dictionary.
		  Dim DataDictionary As Xojo.Core.Dictionary = DataJSON
		  
		  // Create a Template instance.  
		  Dim Template As New Backendd.Template
		  
		  // Pass the Request to the Template so that request-related system tokens can be handled.
		  Template.Request = Request
		  
		  // Load the template file and use it as the source.
		  Template.Source = Backendd.FileRead(Request.StaticPath.Child("template-index.html"))
		  
		  // Set the hash to use for the merge.
		  Template.Hash = DataDictionary
		  
		  // If the request indicated that the orders table should be hidden...
		  Dim HideOrders As String = Request.GET.Lookup("hideorders", "false")
		  If HideOrders = "true" Then
		    
		    // Use the Template's BlockReplace method to replace the table.
		    Dim TokenBegin As String = "{{! Orders Table - Begin }}"
		    Dim TokenEnd As String = "{{! Orders Table - End }}"
		    Template.Source = Template.BlockReplace(Template.Source, TokenBegin, TokenEnd, 0, "")
		    
		  Else
		    
		    // Use the Template's BlockReplace method to replace the "orders hidden" message.
		    Dim TokenBegin As String = "{{! Orders Hidden - Begin }}"
		    Dim TokenEnd As String = "{{! Orders Hidden - End }}"
		    Template.Source = Template.BlockReplace(Template.Source, TokenBegin, TokenEnd, 0, "")
		    
		  End If
		  
		  // Merge the template with the data.
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

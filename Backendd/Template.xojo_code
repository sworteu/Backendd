#tag Class
Protected Class Template
	#tag Method, Flags = &h0
		Function BlockGet(Source As String, TokenBegin As String, TokenEnd As String, Start As Integer = 0) As String
		  Dim Content As String
		  
		  // Get the start position of the beginning token.
		  Dim StartPosition As Integer = Source.InStr(Start, TokenBegin) 
		  
		  // Get the position of the ending token.
		  Dim StopPosition As Integer = Source.InStr(StartPosition, TokenEnd)
		  
		  // If the template includes both the beginning and ending tokens...
		  If ( (StartPosition > 0) and (StopPosition > 0) ) Then
		    
		    // Get the content between the tokens.
		    Content = Mid(Source, StartPosition + TokenBegin.Len, StopPosition - StartPosition - TokenBegin.Len)
		    
		  End If
		  
		  Return Content
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function BlockReplace(Source As String, TokenBegin As String, TokenEnd As String, Start As Integer = 0, ReplacementContent As String = "") As String
		  // Get the content block.
		  Dim BlockContent As String = BlockGet(Source, TokenBegin, TokenEnd, 0)
		  
		  // Replace the content.
		  Source = Source.ReplaceAll(TokenBegin + BlockContent + TokenEnd, ReplacementContent)
		  
		  Return Source
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  // Initialize the Hash dictionary.
		  Hash = New Xojo.Core.Dictionary
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Merge()
		  // Merges a template ("Source") with a data ("Data"), and stores the result in "Expanded."
		  
		  
		  // Load the template.
		  Expanded = Source
		  
		  // Append the system hash to the data hash.
		  If MergeSystemTokens Then
		    SystemHashAppend
		  End If
		  
		  // Regex used for removal of comments and orphans.
		  Dim rg As New RegEx
		  Dim rgMatch As RegExMatch
		  
		  // Remove comments.
		  If RemoveComments = True Then
		    rg.SearchPattern = "\{\{!(?:(?!}})(.|\n))*\}\}"
		    rgMatch = rg.Search(Expanded)
		    While rgMatch <> Nil
		      Expanded = rg.Replace(Expanded)
		      rgMatch = rg.Search(Expanded)
		    Wend
		  End If
		  
		  // Loop over the dictionary's entries...
		  For Each Entry As Xojo.Core.DictionaryEntry In Hash
		    
		    // Use introspection to determine the entry's value type.
		    Dim ValueType As Xojo.Introspection.TypeInfo = Xojo.Introspection.GetType( Entry.Value )
		    
		    // If the value is a primitive (boolean, number, string, etc)...
		    If ValueType.IsPrimitive Then
		      
		      // Convert the primitive value to a string.
		      Dim ValueString As String
		      If ValueType.Name = "Int32" Then
		        Dim ValueInteger As Integer = Entry.Value
		        ValueString = ValueInteger.ToText
		      ElseIf ValueType.Name = "Int64" Then
		        Dim ValueInteger As Integer = Entry.Value
		        ValueString = ValueInteger.ToText
		      ElseIf ValueType.Name = "Double" Then
		        Dim ValueDouble As Double = Entry.Value
		        ValueString = ValueDouble.ToText
		      Else
		        ValueString = Entry.Value
		      End If
		      
		      // Using the dictionary's name and the entry's key, generate the token to replace.
		      Dim Token As String = If(KeyPrefix <> "", KeyPrefix + ".", "") + Entry.Key
		      
		      // Replace all occurrences of the token with the value.
		      Expanded = Expanded.ReplaceAll("{{" + Token + "}}", ValueString)
		      
		    ElseIf ValueType.IsArray Then
		      
		      // Convert the value into an array of autos.
		      Dim ValueArray() As Auto = Entry.Value
		      
		      // Get the beginning and ending tokens for this array.
		      Dim TokenBegin As String = "{{#" + If(KeyPrefix <> "", KeyPrefix + ".", "") + Entry.Key + "}}"
		      Dim TokenEnd As String = "{{/" + If(KeyPrefix <> "", KeyPrefix + ".", "") + Entry.Key + "}}"
		      
		      // Get the start position of the beginning token.
		      Dim StartPosition As Integer = Source.InStr(0, TokenBegin) 
		      
		      // Get the position of the ending token.
		      Dim StopPosition As Integer = Source.InStr(StartPosition, TokenEnd)
		      
		      // If the template includes both the beginning and ending tokens...
		      If ( (StartPosition > 0) and (StopPosition > 0) ) Then
		        
		        // Get the content between the beginning and ending tokens.
		        Dim LoopSource As String = Mid(Source, StartPosition + TokenBegin.Len, StopPosition - StartPosition - TokenBegin.Len)
		        
		        // LoopContent is the content created by looping over the array and merging each value.
		        Dim LoopContent As String
		        
		        // Loop over the array's values...
		        For Each Value As Auto In ValueArray
		          
		          // Process the value using another instance of Template. 
		          Dim Engine As New Template
		          Engine.Source = LoopSource
		          Engine.Hash = Value
		          Engine.KeyPrefix = If(KeyPrefix <> "", KeyPrefix + ".", "") + Entry.Key
		          Engine.MergeSystemTokens = False
		          Engine.RemoveComments = False
		          Engine.RemoveOrphans = False
		          Engine.Merge
		          
		          // Append the expanded content with the loop content.
		          LoopContent = LoopContent + Engine.Expanded
		          
		        Next
		        
		        // Substitute the loop content block of the template with the expanded content.
		        Dim LoopBlock As String = TokenBegin + LoopSource + TokenEnd
		        Expanded = Expanded.ReplaceAll(LoopBlock, LoopContent)
		        
		      End If
		      
		    ElseIf ValueType.Name = "Dictionary" Then
		      
		      // Process the nested dictionary using another Template instance. 
		      Dim Engine As New Template
		      Engine.Source = Expanded
		      Engine.Hash = Entry.Value
		      Engine.KeyPrefix = If(KeyPrefix <> "", KeyPrefix + ".", "") + Entry.Key
		      Engine.MergeSystemTokens = False
		      Engine.RemoveComments = False
		      Engine.RemoveOrphans = False
		      Engine.Merge
		      Expanded = Engine.Expanded
		      
		    End If
		    
		  Next
		  
		  // Remove orphaned tokens.
		  If RemoveOrphans = True Then
		    rg.SearchPattern = "\{\{(?:(?!}}).)*\}\}"
		    rgMatch = rg.Search(Expanded)
		    While rgMatch <> Nil
		      Expanded = rg.Replace(Expanded)
		      rgMatch = rg.Search(Expanded)
		    Wend
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SystemHashAppend()
		  // Initialize the system dictionary, which is used to merge system tokens.
		  Dim SystemHash As New Xojo.Core.Dictionary
		  
		  // Append the system dictionary to the data.
		  Hash.Value("system") = SystemHash
		  
		  // Add the Date dictionary.
		  Dim DateDictionary As New Xojo.Core.Dictionary
		  SystemHash.Value("date") = DateDictionary
		  Dim Today As New Date
		  DateDictionary.Value("abbreviateddate") = Today.AbbreviatedDate
		  DateDictionary.Value("day") = Today.Day.ToText
		  DateDictionary.Value("dayofweek") = Today.DayOfWeek.ToText
		  DateDictionary.Value("dayofyear") = Today.DayOfYear.ToText
		  DateDictionary.Value("gmtoffset") = Today.GMTOffset
		  DateDictionary.Value("hour") = Today.Hour.ToText
		  DateDictionary.Value("longdate") = Today.LongDate
		  DateDictionary.Value("longtime") = Today.LongTime
		  DateDictionary.Value("minute") = Today.Minute.ToText
		  DateDictionary.Value("month") = Today.Month.ToText
		  DateDictionary.Value("second") = Today.Second.ToText
		  DateDictionary.Value("shortdate") = Today.ShortDate
		  DateDictionary.Value("shorttime") = Today.ShortTime
		  DateDictionary.Value("sql") = Today.SQLDate
		  DateDictionary.Value("sqldate") = Today.SQLDate
		  DateDictionary.Value("sqldatetime") = Today.SQLDateTime
		  DateDictionary.Value("totalseconds") = Today.TotalSeconds
		  DateDictionary.Value("weekofyear") = Today.WeekOfYear.ToText
		  DateDictionary.Value("year") = Today.Year.ToText
		  
		  // Add the Meta dictionary.
		  Dim MetaDictionary As New Xojo.Core.Dictionary
		  SystemHash.Value("meta") = MetaDictionary
		  MetaDictionary.Value("xojo-version") = XojoVersionString
		  MetaDictionary.Value("aloe-version") = "Express " + MajorVersion.ToText + "." + MinorVersion.ToText + "." + BugVersion.ToText
		  
		  // Add the Request dictionary.
		  Dim RequestDictionary As New Xojo.Core.Dictionary
		  SystemHash.Value("request") = RequestDictionary
		  RequestDictionary.Value("cookies") = Request.Cookies
		  RequestDictionary.Value("data") = Request.Data
		  RequestDictionary.Value("get") = Request.GET
		  RequestDictionary.Value("headers") = Request.Headers
		  RequestDictionary.Value("method") = Request.Method
		  RequestDictionary.Value("path") = Request.Path
		  RequestDictionary.Value("post") = Request.POST
		  RequestDictionary.Value("remoteaddress") = Request.RemoteAddress
		  RequestDictionary.Value("socketid") = Request.SocketID
		  RequestDictionary.Value("urlparams") = Request.URLParams
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Expanded As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Hash As Xojo.Core.Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		KeyPrefix As String
	#tag EndProperty

	#tag Property, Flags = &h0
		MergeSystemTokens As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		RemoveComments As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		RemoveOrphans As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		Request As Backendd.Request
	#tag EndProperty

	#tag Property, Flags = &h0
		Source As String
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Expanded"
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
			Name="KeyPrefix"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="MergeSystemTokens"
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="RemoveComments"
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="RemoveOrphans"
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Source"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
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

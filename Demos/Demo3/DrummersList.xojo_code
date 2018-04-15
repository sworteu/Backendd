#tag Class
Protected Class DrummersList
	#tag CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit)) or  (TargetIOS and (Target32Bit or Target64Bit))
	#tag Method, Flags = &h0
		Sub Constructor(Request As Backendd.Request)
		  // Store the request instance so that it can be used throughout the class.
		  Self.Request = Request
		  
		  
		  // Try to get the cached content.
		  Dim CacheEntry As Xojo.Core.Dictionary = App.CacheEngine.Get("DrummersTable")
		  
		  
		  // If cached content is available...
		  If CacheEntry <> Nil Then
		    
		    // Use the cached content.
		    TableHTML = CacheEntry.Value("Content")
		    TableHTML = TableHTML + "<p>Cached.</p>"
		    
		  Else
		    
		    // Simulate a long-running process.
		    App.SleepCurrentThread(3000)
		    
		    // Try to connect to the database.
		    DatabaseConnect
		    
		    // If we were unable to connect to the database...
		    If DatabaseConnected = False Then
		      
		      // Substitute special tokens.
		      HTML = HTML.ReplaceAll("[[H1]]", "Error")
		      HTML = HTML.ReplaceAll("[[Content]]", "<p>Unable to connect to the database.</p>")
		      
		      // Update the response content.
		      Request.Response.Content = HTML
		      
		      // Update the request status code.
		      Request.Response.Status = "500"
		      
		      Return
		      
		    End If
		    
		    // Try to get the records from the database.
		    RecordsGet
		    
		    // If we were unable to get records from the database...
		    If Records = Nil or Records.RecordCount = 0 Then
		      
		      // Substitute special tokens.
		      HTML = HTML.ReplaceAll("[[H1]]", "Error")
		      HTML = HTML.ReplaceAll("[[Content]]", "<p>No records are available.</p>")
		      
		      // Update the response content.
		      Request.Response.Content = HTML
		      
		      // Update the request status code.
		      Request.Response.Status = "500"
		      
		      Return
		      
		    End If
		    
		    // Generate the table.
		    TableGenerate
		    
		    // Cache the content.
		    App.CacheEngine.Put("DrummersTable", TableHTML, 60)
		    
		  End If
		  
		  
		  // Load the template file.
		  TemplateLoad
		  
		  
		  // Substitute special tokens.
		  HTML = HTML.ReplaceAll("[[H1]]", "Best Drummers of All Time")
		  HTML = HTML.ReplaceAll("[[Content]]", TableHTML)
		  
		  
		  // Update the response content.
		  Request.Response.Content = HTML
		  
		  // Update the request status code.
		  Request.Response.Status = "200"
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DatabaseConnect()
		  // Create a folderitem that points to the database file.
		  DatabaseFile = GetFolderItem("").Parent.Child("data").Child("drummers.sqlite")
		  
		  
		  // Create a new database instance.
		  Database = New SQLiteDatabase
		  
		  
		  // Assume that the connection will fail.
		  DatabaseConnected = False
		  
		  
		  // If the database file doesn't exist...
		  If DatabaseFile = Nil or DatabaseFile.Exists = False Then
		    Return
		  End If
		  
		  
		  // Assign the database file to the database.
		  Database.DatabaseFile = DatabaseFile
		  
		  
		  // If we can open the database...
		  If Database.Connect Then
		    DatabaseConnected = True
		  End If
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RecordsGet()
		  // Gets all records in the Drummers table.
		  
		  
		  // Prepare a SQL statement.
		  Dim SQL As String = "SELECT * FROM Drummers ORDER BY Votes DESC"
		  
		  
		  // Create a prepared statement.
		  Dim PS As SQLitePreparedStatement = Database.Prepare(SQL)
		  
		  
		  // Perform the query.
		  Records = PS.SQLSelect
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit)) or  (TargetIOS and (Target32Bit or Target64Bit))
		Sub TableGenerate()
		  // Generates an HTML table based on the records that were retrieved.
		  
		  
		  // Open a table.
		  TableHTML = "" _
		  + "<table class=""gridtable"" width=""100%"">" _
		  + "<tr>" _
		  + "<th width=""10%"">Rank</th>" _
		  + "<th width=""10%"">Votes</th>" _
		  + "<th width=""30%"">Drummer</th>" _
		  + "<th width=""50%"">Band</th>" _
		  + "</tr>" + EndOfLine
		  
		  
		  // Initialize the rank.
		  Dim Rank As Integer
		  
		  
		  // Loop over the results...
		  While Not Records.EOF
		    
		    // Increment the rank.
		    Rank = Rank + 1
		    
		    // Open a table row for this result.
		    TableHTML = TableHTML _
		    + "<tr>" + EndOfLine _
		    + "<td>" + Rank.ToText + "</td>" + EndOfLine _
		    + "<td>" + Records.Field("Votes").StringValue + "</td>" + EndOfLine
		    
		    // If the drummer has a URL...
		    If Records.Field("URL").StringValue <> "" Then
		      TableHTML = TableHTML _
		      + "<td>" _
		      + "<a href=""" + Records.Field("URL").StringValue + """ target=""_new"">" _
		      + Records.Field("Drummer_Name").StringValue _
		      + "</a>" _
		      + "</td>" + EndOfLine
		    Else
		      TableHTML = TableHTML + "<td>" + Records.Field("Drummer_Name").StringValue + "</td>" + EndOfLine
		    End If
		    
		    // Close the row.
		    TableHTML = TableHTML _
		    + "<td>" + Records.Field("Band_Name").StringValue + "</td>" + EndOfLine _
		    + "</tr>" + EndOfLine
		    
		    // Go to the next record.
		    Records.MoveNext
		    
		  Wend
		  
		  
		  // Close the table.
		  TableHTML = TableHTML + "</table>" + EndOfLine
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub TemplateLoad()
		  // Loads the template file.
		  
		  // Create a folderitem that points to the template file.
		  Dim FI as FolderItem = Request.StaticPath.Child("index.html")
		  
		  // Use Aloe's FileRead method to load the file.
		  HTML = Backendd.FileRead(FI)
		  
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Database As SQLiteDatabase
	#tag EndProperty

	#tag Property, Flags = &h0
		DatabaseConnected As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		DatabaseFile As FolderItem
	#tag EndProperty

	#tag Property, Flags = &h0
		HTML As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Records As RecordSet
	#tag EndProperty

	#tag Property, Flags = &h0
		Request As Backendd.Request
	#tag EndProperty

	#tag Property, Flags = &h0
		TableHTML As String
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="DatabaseConnected"
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
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
			Name="TableHTML"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
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

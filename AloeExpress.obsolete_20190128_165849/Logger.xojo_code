#tag Class
Protected Class Logger
Inherits Thread
	#tag Event
		Sub Run()
		  // Logs an HTTP request and response.
		  RequestLog
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub Constructor()
		  // Set the default log folder.
		  Folder = GetFolderItem("").Parent.Child("logs")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RequestLog()
		  // Logs all requests, including Date/Time, Method (GET, POST, etc), the resource requested,
		  // the HTTP response status (200, 404, etc), response size, and user-agent name.
		  
		  
		  // Get the current date.
		  Dim CurrentDate As New Date
		  
		  // Adjust the current date so that it is based on GMT.
		  CurrentDate.GMTOffset = 0
		  
		  // Get the current date formatted as YYYYMMDD.
		  Dim YearFormatted As String = CurrentDate.Year.ToText
		  Dim MonthFormatted As String = If (CurrentDate.Month < 10, "0" + CurrentDate.Month.ToText, CurrentDate.Month.ToText)
		  Dim DayFormatted As String = If (CurrentDate.Day < 10, "0" + CurrentDate.Day.ToText, CurrentDate.Day.ToText)
		  Dim DateFormatted As String = YearFormatted + MonthFormatted + DayFormatted
		  
		  // Get the current time formatted as HHMMSS.
		  Dim HourFormatted As String = If(CurrentDate.Hour < 10, "0" + CurrentDate.Hour.ToText, CurrentDate.Hour.ToText)
		  Dim MinuteFormatted As String = If(CurrentDate.Minute < 10, "0" + CurrentDate.Minute.ToText, CurrentDate.Minute.ToText)
		  Dim SecondFormatted As String = If(CurrentDate.Second < 10, "0" + CurrentDate.Second.ToText, CurrentDate.Second.ToText)
		  Dim TimeFormatted As String = HourFormatted + ":" + MinuteFormatted + ":" +  SecondFormatted
		  
		  // If no IP address has been specified, use the default remote IP address.
		  IPAddress = If(IPAddress = "", Request.RemoteAddress, IPAddress)
		  
		  // Create the log file name using the formatted date.
		  Dim LogFileName As String = DateFormatted + ".log"
		  
		  // Create a folder item for the log file.
		  Dim FI As FolderItem = Folder.Child(LogFileName)
		  
		  //  If the folderitem is valid...
		  If FI <> nil Then
		    
		    // Create a textstream.
		    Dim TOS As TextOutputStream
		    
		    // If the file doesn't already exist...
		    If Not FI.exists Then
		      
		      // Create the file.
		      TOS = TextOutputStream.Create(FI)
		      
		      // Write the headers...
		      TOS.WriteLine("#Version: 1.0")
		      TOS.WriteLine("#Date: " + DateFormatted + " " + TimeFormatted)
		      TOS.WriteLine("time" + CHR(9) _
		      + "cs-method" + CHR(9) _
		      + "cs-uri" + CHR(9) _
		      + "sc-status" + CHR(9) _
		      + "sc-bytes" + CHR(9) _
		      + "cs-ip" + CHR(9) _
		      + "cs-user-agent" + CHR(9) _
		      + "cs-user-referrer" _
		      )
		      
		    Else
		      // Append to the existing file.
		      TOS = TextOutputStream.Append(FI)
		    End If
		    
		    // Write to the log file.
		    TOS.WriteLine(TimeFormatted + CHR(9) _
		    + Request.Method + CHR(9) _
		    + Request.Path + CHR(9) _
		    + Request.Response.Status + CHR(9) _
		    + Request.Response.Content.Len.ToText + CHR(9) _
		    + Request.Headers.Lookup("X-Forwarded-For", Request.RemoteAddress) + CHR(9) _
		    + Request.Headers.Lookup("User-Agent", "") + CHR(9) _
		    + Request.Headers.Lookup("Referer", "") _
		    )
		    
		    // Close the stream.
		    TOS.Close
		    
		  End If
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Folder As FolderItem
	#tag EndProperty

	#tag Property, Flags = &h0
		IPAddress As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Request As Backendd.Request
	#tag EndProperty


	#tag ViewBehavior
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
			Name="Priority"
			Visible=true
			Group="Behavior"
			InitialValue="5"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="StackSize"
			Visible=true
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IPAddress"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass

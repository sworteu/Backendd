#tag Class
Protected Class App
Inherits Backendd.BackendApp
	#tag Event , Description = 43616C6C6564207768656E20746865206170706C69636174696F6E2069732061626F757420746F20636C6F73652E205468697320697320746865206C617374206576656E7420746861742077696C6C206265207261697365642E
		Function Finished() As Integer
		  // Last called event just before close.
		  // Return 0 if it's a successful close, on error return errorcode
		  
		End Function
	#tag EndEvent

	#tag Event
		Sub Open(Args As Backendd.Arguments, Server As Backendd.Server)
		  // The program open event, will fire only once.
		End Sub
	#tag EndEvent

	#tag Event , Description = 5468697320697320746865206D61696E206C6F6F702E
		Sub Running()
		  // The main event loop change the processing speed using 
		  // App.MillisecondsSleep = 10 - default 10 (0 = maximum speed !100% CPU, 1000 for every +- 1 sec loop)
		  
		End Sub
	#tag EndEvent

	#tag Event
		Function UnhandledException(error As RuntimeException) As Boolean
		  
		End Function
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub RequestHandler(Request As Backendd.Request)
		  // handle the request here...
		  
		End Sub
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="MillisecondsSleep"
			Group="Behavior"
			InitialValue="10"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Close"
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass

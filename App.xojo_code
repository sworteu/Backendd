#tag Class
Protected Class App
Inherits Backendd.BackenddApplication
	#tag Method, Flags = &h0
		Sub RequestHandler(Request As Backendd.Request)
		  // Uncomment the demo that you'd like to run...
		  
		  // Demo 1
		  // A simple "Hello, World" example.
		  'Demo1.RequestProcess(Request)
		  
		  // Demo 2
		  // Maps requests to static files in a directory.
		  // Includes custom 404 handling , request logging, cache-control header.
		  'Demo2.RequestProcess(Request)
		  
		  // Demo 3
		  // Web-publishes data in a SQLite database.
		  // Also demonstrates caching.
		  'Demo3.RequestProcess(Request)
		  
		  // Demo 4
		  // Demonstrates GET and POST params, headers, session management, etc.
		  Demo4.RequestProcess(Request)
		  
		  // Demo 5
		  // Simple example of a JSON response.
		  'Demo5.RequestProcess(Request)
		  
		  // Demo 6
		  // Simple examples of setting and getting cookies.
		  'Demo6.RequestProcess(Request)
		  
		  // Demo 7
		  // A simple Web service that returns the current date/time.
		  'Demo7.RequestProcess(Request)
		  
		  // Demo 8
		  // Demonstrates multi-threading support.
		  'Demo8.RequestProcess(Request)
		  
		  // Demo 9
		  // Demonstrates processing requests when the app is running multiple AE server instances.
		  // Note: See App.Run for additional configuration info ("Multi-Server Demo"). 
		  'Demo9.RequestProcess(Request)
		  
		  // Demo 10
		  // Demonstrates template support.
		  'Demo10.RequestProcess(Request)
		  
		  
		  
		  
		End Sub
	#tag EndMethod


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass

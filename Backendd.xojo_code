#tag Module
Protected Module Backendd
	#tag Method, Flags = &h0
		Function ArgsToDictionary(Args() As String) As Xojo.Core.Dictionary
		  // Converts command line arguments to a dictionary.
		  
		  
		  Dim Arguments As New Xojo.Core.Dictionary
		  
		  For Each Argument As String In Args
		    
		    Dim ArgParts() As String = Argument.Split("=")
		    Dim Name As String = ArgParts(0)
		    Dim Value As String  = If(ArgParts.Ubound = 1,  ArgParts(1), "")
		    
		    Arguments.Value(Name) = Value
		    
		  Next
		  
		  Return Arguments
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DateToRFC1123(dt As Xojo.Core.Date) As Text
		  // Returns a Xojo.Core.Date in RFC 822 / 1123 format.
		  // Example: Mon, 27 Nov 2017 13:27:26 GMT
		  // Special thanks to Norman Palardy.
		  // See: https://forum.xojo.com/42908-current-date-time-stamp-in-rfc-822-1123-format
		  
		  Dim tmp As Text
		  
		  // clone the date since we do not want to alter it
		  Dim tmpDt As Xojo.Core.Date = New Xojo.Core.Date(dt.SecondsFrom1970, New Xojo.Core.TimeZone(0))
		  
		  Select Case tmpDt.DayOfWeek
		  Case 1
		    tmp = tmp + "Sun"
		  Case 2
		    tmp = tmp + "Mon"
		  Case 3
		    tmp = tmp + "Tue"
		  Case 4
		    tmp = tmp + "Wed"
		  Case 5
		    tmp = tmp + "Thu"
		  Case 6
		    tmp = tmp + "Fri"
		  Case 7
		    tmp = tmp + "Sat"
		  End Select
		  
		  tmp = tmp + ", "
		  
		  tmp = tmp + tmpDt.Day.ToText(Xojo.Core.Locale.Raw, "#0")
		  tmp = tmp + " "
		  
		  Select Case tmpdt.Month
		  Case 1
		    tmp = tmp + "Jan" 
		  Case 2
		    tmp = tmp + "Feb" 
		  Case 3
		    tmp = tmp + "Mar"
		  Case 4
		    tmp = tmp + "Apr"
		  Case 5
		    tmp = tmp + "May" 
		  Case 6
		    tmp = tmp + "Jun" 
		  Case 7
		    tmp = tmp + "Jul" 
		  Case 8
		    tmp = tmp + "Aug"
		  Case 9
		    tmp = tmp + "Sep" 
		  Case 10
		    tmp = tmp + "Oct"
		  Case 11
		    tmp = tmp + "Nov" 
		  Case 12
		    tmp = tmp + "Dec"
		  End Select
		  
		  tmp = tmp + " "
		  
		  tmp = tmp + tmpDt.Year.ToText(Xojo.Core.Locale.Raw, "####")
		  tmp = tmp + " "
		  
		  tmp = tmp + tmpDt.Hour.ToText(Xojo.Core.Locale.Raw, "00")
		  tmp = tmp + ":"
		  
		  tmp = tmp + tmpDt.Minute.ToText(Xojo.Core.Locale.Raw, "00")
		  tmp = tmp + ":"
		  
		  tmp = tmp + tmpDt.Second.ToText(Xojo.Core.Locale.Raw, "00")
		  tmp = tmp + " "
		  
		  tmp = tmp + "GMT"
		  
		  Return tmp
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FileRead(FI as FolderItem) As String
		  // Reads and returns the contents of a file, given a FolderItem.
		  
		  
		  If FI <> Nil Then
		    
		    If FI.Exists Then
		      
		      Dim TIS As TextInputStream
		      
		      Try
		        TIS = TextInputStream.Open(FI)
		        TIS.Encoding = Encodings.UTF8
		        Return TIS.ReadAll
		      Catch e As IOException
		        Return ""
		      End Try
		      
		    End If
		    
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Gunzip(Compressed As String) As String
		  // Decompresses a gzipped string.
		  // Source: https://forum.xojo.com/11634-gunzip-without-a-file/0
		  
		  
		  // Return the decompressed string.
		  Dim GzipContent As New _GzipString
		  Return GzipContent.Decompress(Compressed)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GZip(Uncompressed As String) As String
		  // Compresses a string using gzip.
		  // Source: https://forum.xojo.com/11634-gunzip-without-a-file/0
		  
		  // Return the compressed string.
		  Dim GzipContent As New _GzipString
		  Return GzipContent.Compress(Uncompressed)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function MIMETypeGet(Extension As String) As String
		  // Maps a file extension to its MIME type.
		  // Source: https://github.com/samuelneff/MimeTypeMap
		  
		  Dim MimeTypes As New Dictionary
		  MimeTypes.Value("323") = "text/h323"
		  MimeTypes.Value("3g2") = "video/3gpp2"
		  MimeTypes.Value("3gp") = "video/3gpp"
		  MimeTypes.Value("3gp2") = "video/3gpp2"
		  MimeTypes.Value("3gpp") = "video/3gpp"
		  MimeTypes.Value("7z") = "application/x-7z-compressed"
		  MimeTypes.Value("aa") = "audio/audible"
		  MimeTypes.Value("AAC") = "audio/aac"
		  MimeTypes.Value("aaf") = "application/octet-stream"
		  MimeTypes.Value("aax") = "audio/vnd.audible.aax"
		  MimeTypes.Value("ac3") = "audio/ac3"
		  MimeTypes.Value("aca") = "application/octet-stream"
		  MimeTypes.Value("accda") = "application/msaccess.addin"
		  MimeTypes.Value("accdb") = "application/msaccess"
		  MimeTypes.Value("accdc") = "application/msaccess.cab"
		  MimeTypes.Value("accde") = "application/msaccess"
		  MimeTypes.Value("accdr") = "application/msaccess.runtime"
		  MimeTypes.Value("accdt") = "application/msaccess"
		  MimeTypes.Value("accdw") = "application/msaccess.webapplication"
		  MimeTypes.Value("accft") = "application/msaccess.ftemplate"
		  MimeTypes.Value("acx") = "application/internet-property-stream"
		  MimeTypes.Value("AddIn") = "text/xml"
		  MimeTypes.Value("ade") = "application/msaccess"
		  MimeTypes.Value("adobebridge") = "application/x-bridge-url"
		  MimeTypes.Value("adp") = "application/msaccess"
		  MimeTypes.Value("ADT") = "audio/vnd.dlna.adts"
		  MimeTypes.Value("ADTS") = "audio/aac"
		  MimeTypes.Value("afm") = "application/octet-stream"
		  MimeTypes.Value("ai") = "application/postscript"
		  MimeTypes.Value("aif") = "audio/aiff"
		  MimeTypes.Value("aifc") = "audio/aiff"
		  MimeTypes.Value("aiff") = "audio/aiff"
		  MimeTypes.Value("air") = "application/vnd.adobe.air-application-installer-package+zip"
		  MimeTypes.Value("amc") = "application/mpeg"
		  MimeTypes.Value("anx") = "application/annodex"
		  MimeTypes.Value("apk") = "application/vnd.android.package-archive" 
		  MimeTypes.Value("application") = "application/x-ms-application"
		  MimeTypes.Value("art") = "image/x-jg"
		  MimeTypes.Value("asa") = "application/xml"
		  MimeTypes.Value("asax") = "application/xml"
		  MimeTypes.Value("ascx") = "application/xml"
		  MimeTypes.Value("asd") = "application/octet-stream"
		  MimeTypes.Value("asf") = "video/x-ms-asf"
		  MimeTypes.Value("ashx") = "application/xml"
		  MimeTypes.Value("asi") = "application/octet-stream"
		  MimeTypes.Value("asm") = "text/plain"
		  MimeTypes.Value("asmx") = "application/xml"
		  MimeTypes.Value("aspx") = "application/xml"
		  MimeTypes.Value("asr") = "video/x-ms-asf"
		  MimeTypes.Value("asx") = "video/x-ms-asf"
		  MimeTypes.Value("atom") = "application/atom+xml"
		  MimeTypes.Value("au") = "audio/basic"
		  MimeTypes.Value("avi") = "video/x-msvideo"
		  MimeTypes.Value("axa") = "audio/annodex"
		  MimeTypes.Value("axs") = "application/olescript"
		  MimeTypes.Value("axv") = "video/annodex"
		  MimeTypes.Value("bas") = "text/plain"
		  MimeTypes.Value("bcpio") = "application/x-bcpio"
		  MimeTypes.Value("bin") = "application/octet-stream"
		  MimeTypes.Value("bmp") = "image/bmp"
		  MimeTypes.Value("c") = "text/plain"
		  MimeTypes.Value("cab") = "application/octet-stream"
		  MimeTypes.Value("caf") = "audio/x-caf"
		  MimeTypes.Value("calx") = "application/vnd.ms-office.calx"
		  MimeTypes.Value("cat") = "application/vnd.ms-pki.seccat"
		  MimeTypes.Value("cc") = "text/plain"
		  MimeTypes.Value("cd") = "text/plain"
		  MimeTypes.Value("cdda") = "audio/aiff"
		  MimeTypes.Value("cdf") = "application/x-cdf"
		  MimeTypes.Value("cer") = "application/x-x509-ca-cert"
		  MimeTypes.Value("cfg") = "text/plain"
		  MimeTypes.Value("chm") = "application/octet-stream"
		  MimeTypes.Value("class") = "application/x-java-applet"
		  MimeTypes.Value("clp") = "application/x-msclip"
		  MimeTypes.Value("cmd") = "text/plain"
		  MimeTypes.Value("cmx") = "image/x-cmx"
		  MimeTypes.Value("cnf") = "text/plain"
		  MimeTypes.Value("cod") = "image/cis-cod"
		  MimeTypes.Value("config") = "application/xml"
		  MimeTypes.Value("contact") = "text/x-ms-contact"
		  MimeTypes.Value("coverage") = "application/xml"
		  MimeTypes.Value("cpio") = "application/x-cpio"
		  MimeTypes.Value("cpp") = "text/plain"
		  MimeTypes.Value("crd") = "application/x-mscardfile"
		  MimeTypes.Value("crl") = "application/pkix-crl"
		  MimeTypes.Value("crt") = "application/x-x509-ca-cert"
		  MimeTypes.Value("cs") = "text/plain"
		  MimeTypes.Value("csdproj") = "text/plain"
		  MimeTypes.Value("csh") = "application/x-csh"
		  MimeTypes.Value("csproj") = "text/plain"
		  MimeTypes.Value("css") = "text/css"
		  MimeTypes.Value("csv") = "text/csv"
		  MimeTypes.Value("cur") = "application/octet-stream"
		  MimeTypes.Value("cxx") = "text/plain"
		  MimeTypes.Value("dat") = "application/octet-stream"
		  MimeTypes.Value("datasource") = "application/xml"
		  MimeTypes.Value("dbproj") = "text/plain"
		  MimeTypes.Value("dcr") = "application/x-director"
		  MimeTypes.Value("def") = "text/plain"
		  MimeTypes.Value("deploy") = "application/octet-stream"
		  MimeTypes.Value("der") = "application/x-x509-ca-cert"
		  MimeTypes.Value("dgml") = "application/xml"
		  MimeTypes.Value("dib") = "image/bmp"
		  MimeTypes.Value("dif") = "video/x-dv"
		  MimeTypes.Value("dir") = "application/x-director"
		  MimeTypes.Value("disco") = "text/xml"
		  MimeTypes.Value("divx") = "video/divx"
		  MimeTypes.Value("dll") = "application/x-msdownload"
		  MimeTypes.Value("dll.config") = "text/xml"
		  MimeTypes.Value("dlm") = "text/dlm"
		  MimeTypes.Value("doc") = "application/msword"
		  MimeTypes.Value("docm") = "application/vnd.ms-word.document.macroEnabled.12"
		  MimeTypes.Value("docx") = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
		  MimeTypes.Value("dot") = "application/msword"
		  MimeTypes.Value("dotm") = "application/vnd.ms-word.template.macroEnabled.12"
		  MimeTypes.Value("dotx") = "application/vnd.openxmlformats-officedocument.wordprocessingml.template"
		  MimeTypes.Value("dsp") = "application/octet-stream"
		  MimeTypes.Value("dsw") = "text/plain"
		  MimeTypes.Value("dtd") = "text/xml"
		  MimeTypes.Value("dtsConfig") = "text/xml"
		  MimeTypes.Value("dv") = "video/x-dv"
		  MimeTypes.Value("dvi") = "application/x-dvi"
		  MimeTypes.Value("dwf") = "drawing/x-dwf"
		  MimeTypes.Value("dwg") = "application/acad"
		  MimeTypes.Value("dwp") = "application/octet-stream"
		  MimeTypes.Value("dxr") = "application/x-director"
		  MimeTypes.Value("eml") = "message/rfc822"
		  MimeTypes.Value("emz") = "application/octet-stream"
		  MimeTypes.Value("eot") = "application/vnd.ms-fontobject"
		  MimeTypes.Value("eps") = "application/postscript"
		  MimeTypes.Value("etl") = "application/etl"
		  MimeTypes.Value("etx") = "text/x-setext"
		  MimeTypes.Value("evy") = "application/envoy"
		  MimeTypes.Value("exe") = "application/octet-stream"
		  MimeTypes.Value("exe.config") = "text/xml"
		  MimeTypes.Value("fdf") = "application/vnd.fdf"
		  MimeTypes.Value("fif") = "application/fractals"
		  MimeTypes.Value("filters") = "application/xml"
		  MimeTypes.Value("fla") = "application/octet-stream"
		  MimeTypes.Value("flac") = "audio/flac"
		  MimeTypes.Value("flr") = "x-world/x-vrml"
		  MimeTypes.Value("flv") = "video/x-flv"
		  MimeTypes.Value("fsscript") = "application/fsharp-script"
		  MimeTypes.Value("fsx") = "application/fsharp-script"
		  MimeTypes.Value("generictest") = "application/xml"
		  MimeTypes.Value("gif") = "image/gif"
		  MimeTypes.Value("gpx") = "application/gpx+xml"
		  MimeTypes.Value("group") = "text/x-ms-group"
		  MimeTypes.Value("gsm") = "audio/x-gsm"
		  MimeTypes.Value("gtar") = "application/x-gtar"
		  MimeTypes.Value("gz") = "application/x-gzip"
		  MimeTypes.Value("h") = "text/plain"
		  MimeTypes.Value("hdf") = "application/x-hdf"
		  MimeTypes.Value("hdml") = "text/x-hdml"
		  MimeTypes.Value("hhc") = "application/x-oleobject"
		  MimeTypes.Value("hhk") = "application/octet-stream"
		  MimeTypes.Value("hhp") = "application/octet-stream"
		  MimeTypes.Value("hlp") = "application/winhlp"
		  MimeTypes.Value("hpp") = "text/plain"
		  MimeTypes.Value("hqx") = "application/mac-binhex40"
		  MimeTypes.Value("hta") = "application/hta"
		  MimeTypes.Value("htc") = "text/x-component"
		  MimeTypes.Value("htm") = "text/html"
		  MimeTypes.Value("html") = "text/html"
		  MimeTypes.Value("htt") = "text/webviewhtml"
		  MimeTypes.Value("hxa") = "application/xml"
		  MimeTypes.Value("hxc") = "application/xml"
		  MimeTypes.Value("hxd") = "application/octet-stream"
		  MimeTypes.Value("hxe") = "application/xml"
		  MimeTypes.Value("hxf") = "application/xml"
		  MimeTypes.Value("hxh") = "application/octet-stream"
		  MimeTypes.Value("hxi") = "application/octet-stream"
		  MimeTypes.Value("hxk") = "application/xml"
		  MimeTypes.Value("hxq") = "application/octet-stream"
		  MimeTypes.Value("hxr") = "application/octet-stream"
		  MimeTypes.Value("hxs") = "application/octet-stream"
		  MimeTypes.Value("hxt") = "text/html"
		  MimeTypes.Value("hxv") = "application/xml"
		  MimeTypes.Value("hxw") = "application/octet-stream"
		  MimeTypes.Value("hxx") = "text/plain"
		  MimeTypes.Value("i") = "text/plain"
		  MimeTypes.Value("ico") = "image/x-icon"
		  MimeTypes.Value("ics") = "application/octet-stream"
		  MimeTypes.Value("idl") = "text/plain"
		  MimeTypes.Value("ief") = "image/ief"
		  MimeTypes.Value("iii") = "application/x-iphone"
		  MimeTypes.Value("inc") = "text/plain"
		  MimeTypes.Value("inf") = "application/octet-stream"
		  MimeTypes.Value("ini") = "text/plain"
		  MimeTypes.Value("inl") = "text/plain"
		  MimeTypes.Value("ins") = "application/x-internet-signup"
		  MimeTypes.Value("ipa") = "application/x-itunes-ipa"
		  MimeTypes.Value("ipg") = "application/x-itunes-ipg"
		  MimeTypes.Value("ipproj") = "text/plain"
		  MimeTypes.Value("ipsw") = "application/x-itunes-ipsw"
		  MimeTypes.Value("iqy") = "text/x-ms-iqy"
		  MimeTypes.Value("isp") = "application/x-internet-signup"
		  MimeTypes.Value("ite") = "application/x-itunes-ite"
		  MimeTypes.Value("itlp") = "application/x-itunes-itlp"
		  MimeTypes.Value("itms") = "application/x-itunes-itms"
		  MimeTypes.Value("itpc") = "application/x-itunes-itpc"
		  MimeTypes.Value("IVF") = "video/x-ivf"
		  MimeTypes.Value("jar") = "application/java-archive"
		  MimeTypes.Value("java") = "application/octet-stream"
		  MimeTypes.Value("jck") = "application/liquidmotion"
		  MimeTypes.Value("jcz") = "application/liquidmotion"
		  MimeTypes.Value("jfif") = "image/pjpeg"
		  MimeTypes.Value("jnlp") = "application/x-java-jnlp-file"
		  MimeTypes.Value("jpb") = "application/octet-stream"
		  MimeTypes.Value("jpe") = "image/jpeg"
		  MimeTypes.Value("jpeg") = "image/jpeg"
		  MimeTypes.Value("jpg") = "image/jpeg"
		  MimeTypes.Value("js") = "application/javascript"
		  MimeTypes.Value("json") = "application/json"
		  MimeTypes.Value("jsx") = "text/jscript"
		  MimeTypes.Value("jsxbin") = "text/plain"
		  MimeTypes.Value("latex") = "application/x-latex"
		  MimeTypes.Value("library-ms") = "application/windows-library+xml"
		  MimeTypes.Value("lit") = "application/x-ms-reader"
		  MimeTypes.Value("loadtest") = "application/xml"
		  MimeTypes.Value("lpk") = "application/octet-stream"
		  MimeTypes.Value("lsf") = "video/x-la-asf"
		  MimeTypes.Value("lst") = "text/plain"
		  MimeTypes.Value("lsx") = "video/x-la-asf"
		  MimeTypes.Value("lzh") = "application/octet-stream"
		  MimeTypes.Value("m13") = "application/x-msmediaview"
		  MimeTypes.Value("m14") = "application/x-msmediaview"
		  MimeTypes.Value("m1v") = "video/mpeg"
		  MimeTypes.Value("m2t") = "video/vnd.dlna.mpeg-tts"
		  MimeTypes.Value("m2ts") = "video/vnd.dlna.mpeg-tts"
		  MimeTypes.Value("m2v") = "video/mpeg"
		  MimeTypes.Value("m3u") = "audio/x-mpegurl"
		  MimeTypes.Value("m3u8") = "audio/x-mpegurl"
		  MimeTypes.Value("m4a") = "audio/m4a"
		  MimeTypes.Value("m4b") = "audio/m4b"
		  MimeTypes.Value("m4p") = "audio/m4p"
		  MimeTypes.Value("m4r") = "audio/x-m4r"
		  MimeTypes.Value("m4v") = "video/x-m4v"
		  MimeTypes.Value("mac") = "image/x-macpaint"
		  MimeTypes.Value("mak") = "text/plain"
		  MimeTypes.Value("man") = "application/x-troff-man"
		  MimeTypes.Value("manifest") = "application/x-ms-manifest"
		  MimeTypes.Value("map") = "text/plain"
		  MimeTypes.Value("master") = "application/xml"
		  MimeTypes.Value("mda") = "application/msaccess"
		  MimeTypes.Value("mdb") = "application/x-msaccess"
		  MimeTypes.Value("mde") = "application/msaccess"
		  MimeTypes.Value("mdp") = "application/octet-stream"
		  MimeTypes.Value("me") = "application/x-troff-me"
		  MimeTypes.Value("mfp") = "application/x-shockwave-flash"
		  MimeTypes.Value("mht") = "message/rfc822"
		  MimeTypes.Value("mhtml") = "message/rfc822"
		  MimeTypes.Value("mid") = "audio/mid"
		  MimeTypes.Value("midi") = "audio/mid"
		  MimeTypes.Value("mix") = "application/octet-stream"
		  MimeTypes.Value("mk") = "text/plain"
		  MimeTypes.Value("mmf") = "application/x-smaf"
		  MimeTypes.Value("mno") = "text/xml"
		  MimeTypes.Value("mny") = "application/x-msmoney"
		  MimeTypes.Value("mod") = "video/mpeg"
		  MimeTypes.Value("mov") = "video/quicktime"
		  MimeTypes.Value("movie") = "video/x-sgi-movie"
		  MimeTypes.Value("mp2") = "video/mpeg"
		  MimeTypes.Value("mp2v") = "video/mpeg"
		  MimeTypes.Value("mp3") = "audio/mpeg"
		  MimeTypes.Value("mp4") = "video/mp4"
		  MimeTypes.Value("mp4v") = "video/mp4"
		  MimeTypes.Value("mpa") = "video/mpeg"
		  MimeTypes.Value("mpe") = "video/mpeg"
		  MimeTypes.Value("mpeg") = "video/mpeg"
		  MimeTypes.Value("mpf") = "application/vnd.ms-mediapackage"
		  MimeTypes.Value("mpg") = "video/mpeg"
		  MimeTypes.Value("mpp") = "application/vnd.ms-project"
		  MimeTypes.Value("mpv2") = "video/mpeg"
		  MimeTypes.Value("mqv") = "video/quicktime"
		  MimeTypes.Value("ms") = "application/x-troff-ms"
		  MimeTypes.Value("msi") = "application/octet-stream"
		  MimeTypes.Value("mso") = "application/octet-stream"
		  MimeTypes.Value("mts") = "video/vnd.dlna.mpeg-tts"
		  MimeTypes.Value("mtx") = "application/xml"
		  MimeTypes.Value("mvb") = "application/x-msmediaview"
		  MimeTypes.Value("mvc") = "application/x-miva-compiled"
		  MimeTypes.Value("mxp") = "application/x-mmxp"
		  MimeTypes.Value("nc") = "application/x-netcdf"
		  MimeTypes.Value("nsc") = "video/x-ms-asf"
		  MimeTypes.Value("nws") = "message/rfc822"
		  MimeTypes.Value("ocx") = "application/octet-stream"
		  MimeTypes.Value("oda") = "application/oda"
		  MimeTypes.Value("odb") = "application/vnd.oasis.opendocument.database"
		  MimeTypes.Value("odc") = "application/vnd.oasis.opendocument.chart"
		  MimeTypes.Value("odf") = "application/vnd.oasis.opendocument.formula"
		  MimeTypes.Value("odg") = "application/vnd.oasis.opendocument.graphics"
		  MimeTypes.Value("odh") = "text/plain"
		  MimeTypes.Value("odi") = "application/vnd.oasis.opendocument.image"
		  MimeTypes.Value("odl") = "text/plain"
		  MimeTypes.Value("odm") = "application/vnd.oasis.opendocument.text-master"
		  MimeTypes.Value("odp") = "application/vnd.oasis.opendocument.presentation"
		  MimeTypes.Value("ods") = "application/vnd.oasis.opendocument.spreadsheet"
		  MimeTypes.Value("odt") = "application/vnd.oasis.opendocument.text"
		  MimeTypes.Value("oga") = "audio/ogg"
		  MimeTypes.Value("ogg") = "audio/ogg"
		  MimeTypes.Value("ogv") = "video/ogg"
		  MimeTypes.Value("ogx") = "application/ogg"
		  MimeTypes.Value("one") = "application/onenote"
		  MimeTypes.Value("onea") = "application/onenote"
		  MimeTypes.Value("onepkg") = "application/onenote"
		  MimeTypes.Value("onetmp") = "application/onenote"
		  MimeTypes.Value("onetoc") = "application/onenote"
		  MimeTypes.Value("onetoc2") = "application/onenote"
		  MimeTypes.Value("opus") = "audio/ogg"
		  MimeTypes.Value("orderedtest") = "application/xml"
		  MimeTypes.Value("osdx") = "application/opensearchdescription+xml"
		  MimeTypes.Value("otf") = "application/font-sfnt"
		  MimeTypes.Value("otg") = "application/vnd.oasis.opendocument.graphics-template"
		  MimeTypes.Value("oth") = "application/vnd.oasis.opendocument.text-web"
		  MimeTypes.Value("otp") = "application/vnd.oasis.opendocument.presentation-template"
		  MimeTypes.Value("ots") = "application/vnd.oasis.opendocument.spreadsheet-template"
		  MimeTypes.Value("ott") = "application/vnd.oasis.opendocument.text-template"
		  MimeTypes.Value("oxt") = "application/vnd.openofficeorg.extension"
		  MimeTypes.Value("p10") = "application/pkcs10"
		  MimeTypes.Value("p12") = "application/x-pkcs12"
		  MimeTypes.Value("p7b") = "application/x-pkcs7-certificates"
		  MimeTypes.Value("p7c") = "application/pkcs7-mime"
		  MimeTypes.Value("p7m") = "application/pkcs7-mime"
		  MimeTypes.Value("p7r") = "application/x-pkcs7-certreqresp"
		  MimeTypes.Value("p7s") = "application/pkcs7-signature"
		  MimeTypes.Value("pbm") = "image/x-portable-bitmap"
		  MimeTypes.Value("pcast") = "application/x-podcast"
		  MimeTypes.Value("pct") = "image/pict"
		  MimeTypes.Value("pcx") = "application/octet-stream"
		  MimeTypes.Value("pcz") = "application/octet-stream"
		  MimeTypes.Value("pdf") = "application/pdf"
		  MimeTypes.Value("pfb") = "application/octet-stream"
		  MimeTypes.Value("pfm") = "application/octet-stream"
		  MimeTypes.Value("pfx") = "application/x-pkcs12"
		  MimeTypes.Value("pgm") = "image/x-portable-graymap"
		  MimeTypes.Value("php") = "text/html"
		  MimeTypes.Value("pic") = "image/pict"
		  MimeTypes.Value("pict") = "image/pict"
		  MimeTypes.Value("pkgdef") = "text/plain"
		  MimeTypes.Value("pkgundef") = "text/plain"
		  MimeTypes.Value("pko") = "application/vnd.ms-pki.pko"
		  MimeTypes.Value("pls") = "audio/scpls"
		  MimeTypes.Value("pma") = "application/x-perfmon"
		  MimeTypes.Value("pmc") = "application/x-perfmon"
		  MimeTypes.Value("pml") = "application/x-perfmon"
		  MimeTypes.Value("pmr") = "application/x-perfmon"
		  MimeTypes.Value("pmw") = "application/x-perfmon"
		  MimeTypes.Value("png") = "image/png"
		  MimeTypes.Value("pnm") = "image/x-portable-anymap"
		  MimeTypes.Value("pnt") = "image/x-macpaint"
		  MimeTypes.Value("pntg") = "image/x-macpaint"
		  MimeTypes.Value("pnz") = "image/png"
		  MimeTypes.Value("pot") = "application/vnd.ms-powerpoint"
		  MimeTypes.Value("potm") = "application/vnd.ms-powerpoint.template.macroEnabled.12"
		  MimeTypes.Value("potx") = "application/vnd.openxmlformats-officedocument.presentationml.template"
		  MimeTypes.Value("ppa") = "application/vnd.ms-powerpoint"
		  MimeTypes.Value("ppam") = "application/vnd.ms-powerpoint.addin.macroEnabled.12"
		  MimeTypes.Value("ppm") = "image/x-portable-pixmap"
		  MimeTypes.Value("pps") = "application/vnd.ms-powerpoint"
		  MimeTypes.Value("ppsm") = "application/vnd.ms-powerpoint.slideshow.macroEnabled.12"
		  MimeTypes.Value("ppsx") = "application/vnd.openxmlformats-officedocument.presentationml.slideshow"
		  MimeTypes.Value("ppt") = "application/vnd.ms-powerpoint"
		  MimeTypes.Value("pptm") = "application/vnd.ms-powerpoint.presentation.macroEnabled.12"
		  MimeTypes.Value("pptx") = "application/vnd.openxmlformats-officedocument.presentationml.presentation"
		  MimeTypes.Value("prf") = "application/pics-rules"
		  MimeTypes.Value("prm") = "application/octet-stream"
		  MimeTypes.Value("prx") = "application/octet-stream"
		  MimeTypes.Value("ps") = "application/postscript"
		  MimeTypes.Value("psc1") = "application/PowerShell"
		  MimeTypes.Value("psd") = "application/octet-stream"
		  MimeTypes.Value("psess") = "application/xml"
		  MimeTypes.Value("psm") = "application/octet-stream"
		  MimeTypes.Value("psp") = "application/octet-stream"
		  MimeTypes.Value("pub") = "application/x-mspublisher"
		  MimeTypes.Value("pwz") = "application/vnd.ms-powerpoint"
		  MimeTypes.Value("qht") = "text/x-html-insertion"
		  MimeTypes.Value("qhtm") = "text/x-html-insertion"
		  MimeTypes.Value("qt") = "video/quicktime"
		  MimeTypes.Value("qti") = "image/x-quicktime"
		  MimeTypes.Value("qtif") = "image/x-quicktime"
		  MimeTypes.Value("qtl") = "application/x-quicktimeplayer"
		  MimeTypes.Value("qxd") = "application/octet-stream"
		  MimeTypes.Value("ra") = "audio/x-pn-realaudio"
		  MimeTypes.Value("ram") = "audio/x-pn-realaudio"
		  MimeTypes.Value("rar") = "application/x-rar-compressed"
		  MimeTypes.Value("ras") = "image/x-cmu-raster"
		  MimeTypes.Value("rat") = "application/rat-file"
		  MimeTypes.Value("rc") = "text/plain"
		  MimeTypes.Value("rc2") = "text/plain"
		  MimeTypes.Value("rct") = "text/plain"
		  MimeTypes.Value("rdlc") = "application/xml"
		  MimeTypes.Value("reg") = "text/plain"
		  MimeTypes.Value("resx") = "application/xml"
		  MimeTypes.Value("rf") = "image/vnd.rn-realflash"
		  MimeTypes.Value("rgb") = "image/x-rgb"
		  MimeTypes.Value("rgs") = "text/plain"
		  MimeTypes.Value("rm") = "application/vnd.rn-realmedia"
		  MimeTypes.Value("rmi") = "audio/mid"
		  MimeTypes.Value("rmp") = "application/vnd.rn-rn_music_package"
		  MimeTypes.Value("roff") = "application/x-troff"
		  MimeTypes.Value("rpm") = "audio/x-pn-realaudio-plugin"
		  MimeTypes.Value("rqy") = "text/x-ms-rqy"
		  MimeTypes.Value("rtf") = "application/rtf"
		  MimeTypes.Value("rtx") = "text/richtext"
		  MimeTypes.Value("ruleset") = "application/xml"
		  MimeTypes.Value("s") = "text/plain"
		  MimeTypes.Value("safariextz") = "application/x-safari-safariextz"
		  MimeTypes.Value("scd") = "application/x-msschedule"
		  MimeTypes.Value("scr") = "text/plain"
		  MimeTypes.Value("sct") = "text/scriptlet"
		  MimeTypes.Value("sd2") = "audio/x-sd2"
		  MimeTypes.Value("sdp") = "application/sdp"
		  MimeTypes.Value("sea") = "application/octet-stream"
		  MimeTypes.Value("searchConnector-ms") = "application/windows-search-connector+xml"
		  MimeTypes.Value("setpay") = "application/set-payment-initiation"
		  MimeTypes.Value("setreg") = "application/set-registration-initiation"
		  MimeTypes.Value("settings") = "application/xml"
		  MimeTypes.Value("sgimb") = "application/x-sgimb"
		  MimeTypes.Value("sgml") = "text/sgml"
		  MimeTypes.Value("sh") = "application/x-sh"
		  MimeTypes.Value("shar") = "application/x-shar"
		  MimeTypes.Value("shtml") = "text/html"
		  MimeTypes.Value("sit") = "application/x-stuffit"
		  MimeTypes.Value("sitemap") = "application/xml"
		  MimeTypes.Value("skin") = "application/xml"
		  MimeTypes.Value("sldm") = "application/vnd.ms-powerpoint.slide.macroEnabled.12"
		  MimeTypes.Value("sldx") = "application/vnd.openxmlformats-officedocument.presentationml.slide"
		  MimeTypes.Value("slk") = "application/vnd.ms-excel"
		  MimeTypes.Value("sln") = "text/plain"
		  MimeTypes.Value("slupkg-ms") = "application/x-ms-license"
		  MimeTypes.Value("smd") = "audio/x-smd"
		  MimeTypes.Value("smi") = "application/octet-stream"
		  MimeTypes.Value("smx") = "audio/x-smd"
		  MimeTypes.Value("smz") = "audio/x-smd"
		  MimeTypes.Value("snd") = "audio/basic"
		  MimeTypes.Value("snippet") = "application/xml"
		  MimeTypes.Value("snp") = "application/octet-stream"
		  MimeTypes.Value("sol") = "text/plain"
		  MimeTypes.Value("sor") = "text/plain"
		  MimeTypes.Value("spc") = "application/x-pkcs7-certificates"
		  MimeTypes.Value("spl") = "application/futuresplash"
		  MimeTypes.Value("spx") = "audio/ogg"
		  MimeTypes.Value("src") = "application/x-wais-source"
		  MimeTypes.Value("srf") = "text/plain"
		  MimeTypes.Value("SSISDeploymentManifest") = "text/xml"
		  MimeTypes.Value("ssm") = "application/streamingmedia"
		  MimeTypes.Value("sst") = "application/vnd.ms-pki.certstore"
		  MimeTypes.Value("stl") = "application/vnd.ms-pki.stl"
		  MimeTypes.Value("sv4cpio") = "application/x-sv4cpio"
		  MimeTypes.Value("sv4crc") = "application/x-sv4crc"
		  MimeTypes.Value("svc") = "application/xml"
		  MimeTypes.Value("svg") = "image/svg+xml"
		  MimeTypes.Value("swf") = "application/x-shockwave-flash"
		  MimeTypes.Value("step") = "application/step"
		  MimeTypes.Value("stp") = "application/step"
		  MimeTypes.Value("t") = "application/x-troff"
		  MimeTypes.Value("tar") = "application/x-tar"
		  MimeTypes.Value("tcl") = "application/x-tcl"
		  MimeTypes.Value("testrunconfig") = "application/xml"
		  MimeTypes.Value("testsettings") = "application/xml"
		  MimeTypes.Value("tex") = "application/x-tex"
		  MimeTypes.Value("texi") = "application/x-texinfo"
		  MimeTypes.Value("texinfo") = "application/x-texinfo"
		  MimeTypes.Value("tgz") = "application/x-compressed"
		  MimeTypes.Value("thmx") = "application/vnd.ms-officetheme"
		  MimeTypes.Value("thn") = "application/octet-stream"
		  MimeTypes.Value("tif") = "image/tiff"
		  MimeTypes.Value("tiff") = "image/tiff"
		  MimeTypes.Value("tlh") = "text/plain"
		  MimeTypes.Value("tli") = "text/plain"
		  MimeTypes.Value("toc") = "application/octet-stream"
		  MimeTypes.Value("tr") = "application/x-troff"
		  MimeTypes.Value("trm") = "application/x-msterminal"
		  MimeTypes.Value("trx") = "application/xml"
		  MimeTypes.Value("ts") = "video/vnd.dlna.mpeg-tts"
		  MimeTypes.Value("tsv") = "text/tab-separated-values"
		  MimeTypes.Value("ttf") = "application/font-sfnt"
		  MimeTypes.Value("tts") = "video/vnd.dlna.mpeg-tts"
		  MimeTypes.Value("txt") = "text/plain"
		  MimeTypes.Value("u32") = "application/octet-stream"
		  MimeTypes.Value("uls") = "text/iuls"
		  MimeTypes.Value("user") = "text/plain"
		  MimeTypes.Value("ustar") = "application/x-ustar"
		  MimeTypes.Value("vb") = "text/plain"
		  MimeTypes.Value("vbdproj") = "text/plain"
		  MimeTypes.Value("vbk") = "video/mpeg"
		  MimeTypes.Value("vbproj") = "text/plain"
		  MimeTypes.Value("vbs") = "text/vbscript"
		  MimeTypes.Value("vcf") = "text/x-vcard"
		  MimeTypes.Value("vcproj") = "application/xml"
		  MimeTypes.Value("vcs") = "text/plain"
		  MimeTypes.Value("vcxproj") = "application/xml"
		  MimeTypes.Value("vddproj") = "text/plain"
		  MimeTypes.Value("vdp") = "text/plain"
		  MimeTypes.Value("vdproj") = "text/plain"
		  MimeTypes.Value("vdx") = "application/vnd.ms-visio.viewer"
		  MimeTypes.Value("vml") = "text/xml"
		  MimeTypes.Value("vscontent") = "application/xml"
		  MimeTypes.Value("vsct") = "text/xml"
		  MimeTypes.Value("vsd") = "application/vnd.visio"
		  MimeTypes.Value("vsi") = "application/ms-vsi"
		  MimeTypes.Value("vsix") = "application/vsix"
		  MimeTypes.Value("vsixlangpack") = "text/xml"
		  MimeTypes.Value("vsixmanifest") = "text/xml"
		  MimeTypes.Value("vsmdi") = "application/xml"
		  MimeTypes.Value("vspscc") = "text/plain"
		  MimeTypes.Value("vss") = "application/vnd.visio"
		  MimeTypes.Value("vsscc") = "text/plain"
		  MimeTypes.Value("vssettings") = "text/xml"
		  MimeTypes.Value("vssscc") = "text/plain"
		  MimeTypes.Value("vst") = "application/vnd.visio"
		  MimeTypes.Value("vstemplate") = "text/xml"
		  MimeTypes.Value("vsto") = "application/x-ms-vsto"
		  MimeTypes.Value("vsw") = "application/vnd.visio"
		  MimeTypes.Value("vsx") = "application/vnd.visio"
		  MimeTypes.Value("vtx") = "application/vnd.visio"
		  MimeTypes.Value("wav") = "audio/wav"
		  MimeTypes.Value("wave") = "audio/wav"
		  MimeTypes.Value("wax") = "audio/x-ms-wax"
		  MimeTypes.Value("wbk") = "application/msword"
		  MimeTypes.Value("wbmp") = "image/vnd.wap.wbmp"
		  MimeTypes.Value("wcm") = "application/vnd.ms-works"
		  MimeTypes.Value("wdb") = "application/vnd.ms-works"
		  MimeTypes.Value("wdp") = "image/vnd.ms-photo"
		  MimeTypes.Value("webarchive") = "application/x-safari-webarchive"
		  MimeTypes.Value("webm") = "video/webm"
		  MimeTypes.Value("webp") = "image/webp"
		  MimeTypes.Value("webtest") = "application/xml"
		  MimeTypes.Value("wiq") = "application/xml"
		  MimeTypes.Value("wiz") = "application/msword"
		  MimeTypes.Value("wks") = "application/vnd.ms-works"
		  MimeTypes.Value("WLMP") = "application/wlmoviemaker"
		  MimeTypes.Value("wlpginstall") = "application/x-wlpg-detect"
		  MimeTypes.Value("wlpginstall3") = "application/x-wlpg3-detect"
		  MimeTypes.Value("wm") = "video/x-ms-wm"
		  MimeTypes.Value("wma") = "audio/x-ms-wma"
		  MimeTypes.Value("wmd") = "application/x-ms-wmd"
		  MimeTypes.Value("wmf") = "application/x-msmetafile"
		  MimeTypes.Value("wml") = "text/vnd.wap.wml"
		  MimeTypes.Value("wmlc") = "application/vnd.wap.wmlc"
		  MimeTypes.Value("wmls") = "text/vnd.wap.wmlscript"
		  MimeTypes.Value("wmlsc") = "application/vnd.wap.wmlscriptc"
		  MimeTypes.Value("wmp") = "video/x-ms-wmp"
		  MimeTypes.Value("wmv") = "video/x-ms-wmv"
		  MimeTypes.Value("wmx") = "video/x-ms-wmx"
		  MimeTypes.Value("wmz") = "application/x-ms-wmz"
		  MimeTypes.Value("woff") = "application/font-woff"
		  MimeTypes.Value("wpl") = "application/vnd.ms-wpl"
		  MimeTypes.Value("wps") = "application/vnd.ms-works"
		  MimeTypes.Value("wri") = "application/x-mswrite"
		  MimeTypes.Value("wrl") = "x-world/x-vrml"
		  MimeTypes.Value("wrz") = "x-world/x-vrml"
		  MimeTypes.Value("wsc") = "text/scriptlet"
		  MimeTypes.Value("wsdl") = "text/xml"
		  MimeTypes.Value("wvx") = "video/x-ms-wvx"
		  MimeTypes.Value("x") = "application/directx"
		  MimeTypes.Value("xaf") = "x-world/x-vrml"
		  MimeTypes.Value("xaml") = "application/xaml+xml"
		  MimeTypes.Value("xap") = "application/x-silverlight-app"
		  MimeTypes.Value("xbap") = "application/x-ms-xbap"
		  MimeTypes.Value("xbm") = "image/x-xbitmap"
		  MimeTypes.Value("xdr") = "text/plain"
		  MimeTypes.Value("xht") = "application/xhtml+xml"
		  MimeTypes.Value("xhtml") = "application/xhtml+xml"
		  MimeTypes.Value("xla") = "application/vnd.ms-excel"
		  MimeTypes.Value("xlam") = "application/vnd.ms-excel.addin.macroEnabled.12"
		  MimeTypes.Value("xlc") = "application/vnd.ms-excel"
		  MimeTypes.Value("xld") = "application/vnd.ms-excel"
		  MimeTypes.Value("xlk") = "application/vnd.ms-excel"
		  MimeTypes.Value("xll") = "application/vnd.ms-excel"
		  MimeTypes.Value("xlm") = "application/vnd.ms-excel"
		  MimeTypes.Value("xls") = "application/vnd.ms-excel"
		  MimeTypes.Value("xlsb") = "application/vnd.ms-excel.sheet.binary.macroEnabled.12"
		  MimeTypes.Value("xlsm") = "application/vnd.ms-excel.sheet.macroEnabled.12"
		  MimeTypes.Value("xlsx") = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
		  MimeTypes.Value("xlt") = "application/vnd.ms-excel"
		  MimeTypes.Value("xltm") = "application/vnd.ms-excel.template.macroEnabled.12"
		  MimeTypes.Value("xltx") = "application/vnd.openxmlformats-officedocument.spreadsheetml.template"
		  MimeTypes.Value("xlw") = "application/vnd.ms-excel"
		  MimeTypes.Value("xml") = "text/xml"
		  MimeTypes.Value("xmta") = "application/xml"
		  MimeTypes.Value("xof") = "x-world/x-vrml"
		  MimeTypes.Value("XOML") = "text/plain"
		  MimeTypes.Value("xpm") = "image/x-xpixmap"
		  MimeTypes.Value("xps") = "application/vnd.ms-xpsdocument"
		  MimeTypes.Value("xrm-ms") = "text/xml"
		  MimeTypes.Value("xsc") = "application/xml"
		  MimeTypes.Value("xsd") = "text/xml"
		  MimeTypes.Value("xsf") = "text/xml"
		  MimeTypes.Value("xsl") = "text/xml"
		  MimeTypes.Value("xslt") = "text/xml"
		  MimeTypes.Value("xsn") = "application/octet-stream"
		  MimeTypes.Value("xss") = "application/xml"
		  MimeTypes.Value("xspf") = "application/xspf+xml"
		  MimeTypes.Value("xtp") = "application/octet-stream"
		  MimeTypes.Value("xwd") = "image/x-xwindowdump"
		  MimeTypes.Value("z") = "application/x-compress"
		  MimeTypes.Value("zip") = "application/zip"
		  
		  Return MIMETypes.Lookup(Extension, "binary/octet-stream")
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function URLDecode(Encoded As String) As String
		  // Properly and fully decodes a URL-encoded value.
		  // Unlike Xojo's "DecodeURLComponent," this method decodes any "+" characters
		  // that represent encoded space characters.
		  
		  // Replace any "+" chars with spaces.
		  Encoded = Encoded.ReplaceAll("+", " ")
		  
		  // Decode everything else.
		  Encoded = DecodeURLComponent(Encoded)
		  
		  Return Encoded
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function URLEncode(Value As String) As String
		  // A wrapper for Xojo's EncodeURLComponent, provided for consistency and convenience.
		  
		  Return EncodeURLComponent(Value)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function UUIDGenerate() As String
		  // Generates a UUID.
		  // Source: https://forum.xojo.com/18856-getting-guid/0 ( Roberto Calvi )
		  // Replace this with whatever UUID generation function that you prefer.
		  
		  
		  Dim db As New SQLiteDatabase
		  
		  Dim SQL_Instruction As String= "select hex( randomblob(4)) " _
		  + "|| '-' || hex( randomblob(2)) " _
		  + "|| '-' || '4' || substr( hex( randomblob(2)), 2) " _
		  + "|| '-' || substr('AB89', 1 + (abs(random()) % 4) , 1) " _
		  + "|| substr(hex(randomblob(2)), 2) " _
		  + "|| '-' || hex(randomblob(6)) AS GUID"
		  
		  If db.Connect Then
		    Dim GUID As String = db.SQLSelect(SQL_Instruction).Field("GUID")
		    db.Close
		    Return  GUID
		  End If
		End Function
	#tag EndMethod


	#tag Note, Name = About
		
		
		
		Read about the original AloeExpress:
		
		-----------------------------------------------------------------------------------------
		About
		-----------------------------------------------------------------------------------------
		
		Aloe Express is a powerful, easy-to-use, open source foundation on which you can 
		build Web APIs, microservices, and more using Xojo. 
		
		To learn more about Aloe, visit: http://aloe.zone
		
		
	#tag EndNote

	#tag Note, Name = License
		
		
		Based and derived from the following license:
		
		-----------------------------------------------------------------------------------------
		The MIT License (MIT)
		-----------------------------------------------------------------------------------------
		
		Copyright (c) 2018 Timothy Dietrich
		
		Permission is hereby granted, free of charge, to any person obtaining a copy of this 
		software and associated documentation files (the "Software"), to deal in the Software 
		without restriction, including without limitation the rights to use, copy, modify, merge, 
		publish, distribute, sublicense, and/or sell copies of the Software, and to permit 
		persons to whom the Software is furnished to do so, subject to the following conditions:
		
		The above copyright notice and this permission notice shall be included in all copies 
		or substantial portions of the Software.
		
		THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
		EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
		MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
		IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
		CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
		TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
		SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
		
		To learn more, visit https://www.tldrlegal.com/l/mit.
		
		
	#tag EndNote

	#tag Note, Name = Thanks
		
		
		Based on AloeExpress Thanks to:
		
		-----------------------------------------------------------------------------------------
		Special thanks to...
		-----------------------------------------------------------------------------------------
		
		Hal Gumbert of Camp Software (http://campsoftware.com), for his feedback and 
		guidance as Aloe Express took shape.
		
		Geoff Perlman of Xojo (https://www.xojo.com) for his suggestions and feedback
		regarding the Aloe Express concept. 
		
		Joshua Golub of Finite Wisdom (https://www.finitewisdom.com) for his sharing
		his insights regarding NodeJS.
		
		Scott Boss of Nocturnal Coding Monkeys (http://nocturnalcodingmonkeys.com), for
		providing valuable feedback and working on the "loopback" support.
		
		Paul Lefebvre of Xojo (https://www.xojo.com) for reviewing Aloe Express from
		a technical perspective.
		
	#tag EndNote


	#tag Constant, Name = BugVersion, Type = Double, Dynamic = False, Default = \"0", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MajorVersion, Type = Double, Dynamic = False, Default = \"1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = MinorVersion, Type = Double, Dynamic = False, Default = \"2", Scope = Public
	#tag EndConstant


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
End Module
#tag EndModule

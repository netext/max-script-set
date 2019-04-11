(
	try((DotNetClass "System.Windows.Forms.Application").CurrentCulture = dotnetObject "System.Globalization.CultureInfo" "zh-cn")catch() -- 强制中文	
	Filepath = (getFilenamePath (getSourceFileName()))
	try(
		dotnet.loadassembly (Filepath+"ExecuteMxsDLL.dll")
	)catch(
		try(
			filedll = (dotnetClass "System.IO.File").ReadAllBytes (Filepath+"ExecuteMxsDLL.dll")
			Refload = (dotnetClass "System.Reflection.Assembly").Load filedll
		)catch()			
	)
	EncryStrs = dotnetClass "ExecuteMxsDLL.ExeDLL" 
	EncryStrs.Execute_Scrip (((maxVersion())[1]/1000)as Integer)
)

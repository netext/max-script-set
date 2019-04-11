/*******************************************************************************************************
<SCRIPTFILE>
Created: 2013-04-29
Last Updated: 2013-04-29
Version: 1

Author: Klaas Nienhuis, mail@klaasnienhuis.nl, www.klaasnienhuis.nl
Version: 3ds max 2013

Description:
	An example on how to use drag/drop with a listview to open files. This example will take the recent documents as a source,
	but you can edit the script to feed it any array of filepaths
	
	knowledge taken from these sources
	http://forums.cgsociety.org/showthread.php?f=98&t=685803&highlight=drop+viewport
	http://lonerobot.net/?p=111
Usage:
	RUN IT

Features:
	drag drop files onto a viewport to open them
Wishlist:
Changelog:
	2013-04-29: first setup
</SCRIPTFILE>
*******************************************************************************************************/


try(destroyDialog fileOpenDragDrop.roll_dragDrop)catch()

(
	global fileOpenDragDrop
	
	struct str_fileOpenDragDrop
	(
		roll_dragDrop,
		
		function fn_getRecentDocumentsIni =
		(
			/*<FUNCTION>
			Description:
				Gets the recent documents from the ini-file where they're stored.
			Arguments:
			Return:
				<array> an array of filepaths.
			</FUNCTION>*/
			
			local theIniFile = getdir #maxData + "3dsmax.ini" 
			local theKeys = getIniSetting theIniFile "FileList" 
			local arrPath = for o in theKeys where o != "MaxFiles" collect getIniSetting theIniFIle "FileList" o 
		),
		
		function fn_getRecentDocumentsXml =
		(
			/*<FUNCTION>
			Description:
				Gets the recent documents from the xml where they're stored.
				In the past these would be in an ini-file, but now it's xml.
			Arguments:
			Return:
				<array> an array of filepaths
			</FUNCTION>*/
			
			--the recent documents are stored in an xml, get it and load it
			local xmlPath = getdir #maxData + "RecentDocuments.xml"
			dotnet.loadAssembly "system.xml"
			local xmlDoc=dotNetObject "system.xml.xmlDocument"
			xmlDoc.load xmlPath
		
			--find the elements which contain the filepaths and collect them in an array
			local searchString = "//MaxApp.RecentDocument/FilePath"
			local arrNodes = xmlDoc.DocumentElement.SelectNodes searchString
			local arrPath = for i =0 to arrNodes.count-1 collect (arrNodes.itemOf[i].innerText)
		),
		
		function fn_populate control =
		(
			/*<FUNCTION>
			Description:
				Populates a listview control with an array of filepaths. maxfiles will work, texturemaps as well
			Arguments:
				<listview> control: the listview control to populate
			Return:
			</FUNCTION>*/
			
			--get the recent files, either from an xml (newer) or an ini (older)
			local arrPath = if doesFileExist (getdir #maxData + "RecentDocuments.xml") then fn_getRecentDocumentsXml() else fn_getRecentDocumentsIni()
			
			--create a listviewItem for each of the filepaths
			for thePath in arrPath do
			(
				local lvItem = control.items.add thePath
				lvItem.tag = dotnetmxsvalue thePath
			)
		),
		
		function fn_defineRollout =
		(
			/*<FUNCTION>
			Description:
				Creates the rollout for demoing a drag-drop file operation.
			Arguments:
			Return:
			</FUNCTION>*/
			
			rollout roll_dragDrop "Drag files into the viewport"  width:300 height:300
			(
				local dragFlag = false
				dotNetControl lvMain "system.windows.forms.listView" pos:[0,0] width:300 height:300
				
				on roll_dragDrop open do
				(
					--design the listview
					lvMain.view=(dotNetClass "system.windows.forms.view").details
					lvMain.FullRowSelect=true
					lvMain.GridLines=true
					lvMain.MultiSelect=false
					lvMain.allowdrop = true
					lvMain.Columns.add "Recent documents" 295
					
					--populate the listview
					fileOpenDragDrop.fn_populate lvMain
				)
				
				--these flags keep me from dropping stuff back onto the treelist
				on lvMain itemDrag sender args do dragFlag = true
				on lvMain mouseUp sender args do dragFlag = false
				
				--When the treeview loses focus, activate the drag/drop menu
				on lvMain lostFocus sender args do if dragFlag == true do
				(
					local theFilePath = sender.SelectedItems.Item[0].tag.value --the filepath for the dropped item
					
					--place the max-string into a dotnet-string-array
					local dropfilePath = dotnetobject "System.String[]" 1 --this isn't a string, but an array of strings with one member
					dropfilePath.setvalue theFilePath 0
					
					--feed the string into a special dataObject
					local dataObj = dotnetobject "DataObject" ((dotnetclass "DataFormats").filedrop) dropfilePath 
					sender.dodragdrop dataobj ((dotnetclass "DragDropEffects").Copy) 
				)				
			)
		),
		
		define = fn_defineRollout()
	)
	
	fileOpenDragDrop = str_fileOpenDragDrop()
)

createDialog fileOpenDragDrop.roll_dragDrop style:#(#style_toolwindow, #style_sysmenu)
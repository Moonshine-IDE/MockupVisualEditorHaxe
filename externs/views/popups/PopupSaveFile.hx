package views.popups;

import haxeScripts.valueObjects.ProjectVO;
import feathers.controls.TitleWindow;

extern enum abstract SaveType(String)
{
    var MXHX;
    var Abstract;
    var FormBuilder;
}
extern class PopupSaveFile extends TitleWindow 
{
	public function new(saveAsType:SaveType);
	
    public var project:ProjectVO;
    
    public var isCancelled(default, never):Bool;
    public var fileName(default, default):String;
}
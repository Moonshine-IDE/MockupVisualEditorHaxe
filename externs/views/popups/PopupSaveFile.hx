package views.popups;

import feathers.controls.TitleWindow;

extern enum abstract SaveType(String)
{
    var MXHX;
    var FormBuilderProject;
    var FormBuilder;
}
extern class PopupSaveFile extends TitleWindow 
{
	public function new(saveAsType:SaveType);
	
    public var isCancelled(default, never):Bool;
    public var fileName(default, default):String;
}
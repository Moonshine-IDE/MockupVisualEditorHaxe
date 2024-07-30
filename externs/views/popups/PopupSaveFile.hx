package views.popups;

import feathers.controls.TitleWindow;

extern class PopupSaveFile extends TitleWindow 
{
	public function new();
	
    public var isCancelled(default, never):Bool;
    public var fileName(default, default):String;
}
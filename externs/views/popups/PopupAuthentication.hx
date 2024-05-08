package views.popups;

import feathers.controls.Panel;

extern class PopupAuthentication extends Panel 
{
    public function new();
    
    public var isNeedsLogin:Bool;
    public var isNeedsFileNameSave:Bool;

    public var isCancelled(default, never):Bool;
    public var fileName(default, default):String;
}
package views.popups;

import feathers.controls.TitleWindow;

extern class PopupAuthentication extends TitleWindow 
{
    public function new();
    
    public var isCancelled(default, never):Bool;
}
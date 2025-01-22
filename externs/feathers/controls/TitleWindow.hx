package feathers.controls;

import openfl.events.KeyboardEvent;
import feathers.events.TriggerEvent;
import feathers.controls.Panel;

extern class TitleWindow extends Panel 
{
	public var closeEnabled(get, set):Bool;
	private function get_closeEnabled():Bool;
	private function set_closeEnabled(value:Bool):Bool;

	public var title(get, set):String;
	private function get_title():String;
	private function set_title(value:String):String;

	public function new();

	private function closeButton_triggerHandler(event:TriggerEvent):Void;
	private function titleWindow_keyDownHandler(event:KeyboardEvent):Void;
}
package haxeScripts.events;

import openfl.events.Event;

extern class ConsoleEvent extends Event
{
    public static final OUTPUT:String;   
    public function new(type:String, text:String, ?isError:Bool=false, ?canBubble:Bool=false, ?isCancelable:Bool=true);
}
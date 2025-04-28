package haxeScripts.events;

import openfl.events.EventDispatcher;

extern class GlobalEventDispatcher extends EventDispatcher 
{
    public static function getInstance():GlobalEventDispatcher;
}
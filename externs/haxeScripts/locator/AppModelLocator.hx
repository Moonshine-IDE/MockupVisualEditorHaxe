package haxeScripts.locator;

import haxeScripts.interfaces.IFileBridge;
import openfl.events.EventDispatcher;

extern class AppModelLocator extends EventDispatcher
{
    public static function getInstance():AppModelLocator;

    public var currentUser:String;
    public var fileCore:IFileBridge;
}
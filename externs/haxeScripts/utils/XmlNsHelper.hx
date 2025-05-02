package haxeScripts.utils;

import haxe.xml.Access;

extern class XmlNsHelper 
{
    public var xmlAccess:Access;
    
    public function new(xml:Access);
    public function registerNamespace(nsPrefix:String, uri:String):Void;
    public function hasElement(localName:String, nsPrefix:String, ?checkNamespace:Bool=true):Bool;
    public function getElement(localName:String, nsPrefix:String, ?checkNamespace:Bool=true):Access;
    public function getElements(localName:String, nsPrefix:String, ?checkNamespace:Bool=true):Array<Access>;
    public function forChild(localName:String, nsPrefix:String, ?checkNamespace:Bool=true):XmlNsHelper;

    public static function documentHasNamespaceWithURI(xml:Xml, namespacePrefix:String, uri:String):Bool;
}
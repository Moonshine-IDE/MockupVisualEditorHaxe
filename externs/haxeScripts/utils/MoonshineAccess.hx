package haxeScripts.utils;

extern class MoonshineAccess 
{
    public function new(x:Xml):Void;

    public var x(get, never):Xml;
    function get_x():Xml;

    public var name(get, never):String;
    function get_name():String;

    public var innerData(get, never):String;
    function get_innerData():String;

    public var innerHTML(get, never):String;
    function get_innerHTML():String;

    public var node(get, never):MoonshineAccess.NodeAccess;
    function get_node():MoonshineAccess.NodeAccess;

    public var nodes(get, never):MoonshineAccess.NodeListAccess;
    function get_nodes():MoonshineAccess.NodeListAccess;

    public var att(get, never):MoonshineAccess.AttribAccess;
    function get_att():MoonshineAccess.AttribAccess;

    public var has(get, never):MoonshineAccess.HasAttribAccess;
    function get_has():MoonshineAccess.HasAttribAccess;

    public var hasNode(get, never):MoonshineAccess.HasNodeAccess;
    function get_hasNode():MoonshineAccess.HasNodeAccess;

    public var elements(get, never):Iterator<MoonshineAccess>;
    function get_elements():Iterator<MoonshineAccess>;
}

@:forward
extern abstract NodeAccess(Xml) from Xml {
    @:op(a.b)
    public function resolve(name:String):MoonshineAccess;
}

@:forward
extern abstract NodeListAccess(Xml) from Xml {
    @:op(a.b)
    public function resolve(name:String):Array<MoonshineAccess>;
}

@:forward
extern abstract AttribAccess(Xml) from Xml {
    @:op(a.b)
    public function resolve(name:String):String;
    @:op(a.b)
    function _hx_set(name:String, value:String):String;
}

@:forward
extern abstract HasAttribAccess(Xml) from Xml {
    @:op(a.b)
    public function resolve(name:String):Bool;
}

@:forward
extern abstract HasNodeAccess(Xml) from Xml {
    @:op(a.b)
    public function resolve(name:String):Bool;
}
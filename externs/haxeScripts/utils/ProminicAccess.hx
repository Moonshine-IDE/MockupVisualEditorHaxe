package haxeScripts.utils;

extern class ProminicAccess 
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

    public var node(get, never):ProminicAccess.NodeAccess;
    function get_node():ProminicAccess.NodeAccess;

    public var nodes(get, never):ProminicAccess.NodeListAccess;
    function get_nodes():ProminicAccess.NodeListAccess;

    public var att(get, never):ProminicAccess.AttribAccess;
    function get_att():ProminicAccess.AttribAccess;

    public var has(get, never):ProminicAccess.HasAttribAccess;
    function get_has():ProminicAccess.HasAttribAccess;

    public var hasNode(get, never):ProminicAccess.HasNodeAccess;
    function get_hasNode():ProminicAccess.HasNodeAccess;

    public var elements(get, never):Iterator<ProminicAccess>;
    function get_elements():Iterator<ProminicAccess>;
}

@:forward
extern abstract NodeAccess(Xml) from Xml {
    @:op(a.b)
    public function resolve(name:String):ProminicAccess;
}

@:forward
extern abstract NodeListAccess(Xml) from Xml {
    @:op(a.b)
    public function resolve(name:String):Array<ProminicAccess>;
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
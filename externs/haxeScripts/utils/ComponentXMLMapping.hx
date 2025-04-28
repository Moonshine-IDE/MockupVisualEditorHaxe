package haxeScripts.utils;

import view.dominoFormBuilder.vo.DominoFormFieldVO;

extern class ComponentXMLMapping 
{
    public static function getInstance():ComponentXMLMapping;
    public function registerComponent(field:DominoFormFieldVO, xmlData:String):Void;
}
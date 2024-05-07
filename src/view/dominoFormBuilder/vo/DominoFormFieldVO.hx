////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) STARTcloud, Inc. 2015-2022. All rights reserved.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the Server Side Public License, version 1,
//  as published by MongoDB, Inc.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
//  Server Side Public License for more details.
//
//  You should have received a copy of the Server Side Public License
//  along with this program. If not, see
//
//  http://www.mongodb.com/licensing/server-side-public-license
//
//  As a special exception, the copyright holders give permission to link the
//  code of portions of this program with the OpenSSL library under certain
//  conditions as described in each individual source file and distribute
//  linked combinations including the program with the OpenSSL library. You
//  must comply with the Server Side Public License in all respects for
//  all of the code used other than as permitted herein. If you modify file(s)
//  with this exception, you may extend this exception to your version of the
//  file(s), but you are not obligated to do so. If you do not wish to do so,
//  delete this exception statement from your version. If you delete this
//  exception statement from all source files in the program, then also delete
//  it in the license file.
//
////////////////////////////////////////////////////////////////////////////////
package view.dominoFormBuilder.vo;

import view.dominoFormBuilder.utils.DominoTemplatesManager;
import view.dominoFormBuilder.vo.FormBuilderSortingType.SortTypeVO;
import haxe.xml.Access;

class DominoFormFieldVO 
{
    public static final ELEMENT_NAME:String = "field";
		
    public var name:String;
    public var label:String = "";
    public var description:String = "";
    public var type:String = FormBuilderFieldType.fieldTypes.get(0);
    public var editable:String = FormBuilderEditableType.editableTypes.get(0);
    public var formula:String = "";
    public var sortOption:SortTypeVO = FormBuilderSortingType.sortTypes.get(0);
    public var isMultiValue:Bool;
    public var isIncludeInView:Bool = true;

    public function new() {}

    //--------------------------------------------------------------------------
    //
    //  PUBLIC API
    //
    //--------------------------------------------------------------------------
    
    public function fromXML(accessXML:Access, ?callback:()->Void):Void
    {
        this.name = accessXML.att.name;
        this.type = accessXML.att.type;
        this.editable = accessXML.att.editable;
        this.isMultiValue = (accessXML.att.isMultiValue == "true") ? true : false;
        this.isIncludeInView = (accessXML.att.isIncludeInView == "true") ? true : false;
        
        for (sortType in FormBuilderSortingType.sortTypes)
        {
            if (accessXML.att.sortOption == sortType.label)
            {
                this.sortOption = sortType;
                break;
            }
        }
        
        this.label = accessXML.node.label.innerData;
        this.description = accessXML.node.description.innerData;
        this.formula = accessXML.node.formula.innerData;
    }
    
    public function toXML():Xml
    {
        var xml:Xml = Xml.createElement(ELEMENT_NAME);
        
        xml.set("name", name);
        xml.set("type", type);
        xml.set("editable", editable);
        xml.set("sortOption", sortOption.label);
        xml.set("isMultiValue", Std.string(isMultiValue));
        xml.set("isIncludeInView", Std.string(isIncludeInView));
        
        var tempXML = Xml.createElement("label");
        tempXML.addChild(Xml.createCData(label));
        xml.addChild(tempXML);
        
        tempXML = Xml.createElement("description");
        tempXML.addChild(Xml.createCData(description));
        xml.addChild(tempXML);
        
        tempXML = Xml.createElement("formula");
        tempXML.addChild(Xml.createCData(formula));
        xml.addChild(tempXML);
        
        return xml;
    }
    
    //--------------------------------------------------------------------------
    //
    //  DXL/XML
    //
    //--------------------------------------------------------------------------
    
    public function toCode():String
    {
        var row:String = DominoTemplatesManager.getTableRowTemplate();
        var cell:String = DominoTemplatesManager.getTableCellTemplate();
        
        // for now until Dmytro provides
        // template of table-row having predefined
        // table-column/cell, we'll generate manual 3
        var tmpAllColumns:String = "";
        var tmpField:String;
        var ereg:EReg = null;
        for (i in 0...3)
        {
            ereg = ~/%cellbody%/ig;
            tmpAllColumns = ereg.replace(cell, label);
            
            tmpField = DominoTemplatesManager.getFieldTemplate(type, isMultiValue, editable);
            if (tmpField != null)
            {
                ereg = ~/%fieldname%/ig;
                tmpField = ereg.replace(tmpField, name);
                ereg = ~/%computedvalue%/ig;
                tmpField = ereg.replace(tmpField, formula);
            }

            ereg = ~/%cellbody%/ig;
            tmpAllColumns += ereg.replace(cell, (tmpField != null) ? tmpField : '');
            ereg = ~/%cellbody%/ig;
            tmpAllColumns += ereg.replace(cell, description);
        }
        
        ereg = ~/%cells%/ig;
        row = ereg.replace(row, tmpAllColumns);
        return row;
    }
}
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

import haxeScripts.valueObjects.AppConstants;
import haxeScripts.utils.XmlNsHelper;
import haxeScripts.utils.ComponentXMLMapping;
import haxeScripts.factory.FileLocation;
import view.dominoFormBuilder.utils.DominoTemplatesManager;
import haxe.xml.Access;
import feathers.data.ArrayCollection;
import openfl.events.EventDispatcher;

class DominoFormVO extends EventDispatcher 
{
    public static final ELEMENT_NAME:String = "fb:form";
		
    public var formName:String;
    public var viewName:String;
    public var hasWebAccess:Bool = false;
    public var fields:ArrayCollection<DominoFormFieldVO> = new ArrayCollection();
    public var dxlGeneratedOn:Date;
    public var pageContent:Xml;
    public var isSubForm:Bool;
    public var subFormsNames:Array<String>;
    public var projectPath:FileLocation;

    public function new()
    {
        super();
    }    

    //--------------------------------------------------------------------------
    //
    //  PUBLIC API
    //
    //--------------------------------------------------------------------------
    
    public function fromXML(value:Xml, callback:()->Void):Void
    {
        var accessXML = new Access(value.firstElement());
        var helper = new XmlNsHelper(accessXML);
        helper.registerNamespace("fb", AppConstants.NAMESPACE_URI_FORMBUILDER);

        // find/get `form` element
        if (helper.hasElement('form', AppConstants.NAMESPACE_FORMBUILDER))
        {
            var formHelper = helper.forChild('form', AppConstants.NAMESPACE_FORMBUILDER);
            this.formName = formHelper.xmlAccess.att.name;
            this.hasWebAccess = (formHelper.xmlAccess.att.hasWebAccess == "true") ? true : false;

            if (formHelper.hasElement("viewName", AppConstants.NAMESPACE_FORMBUILDER)) 
            {
                this.viewName = formHelper.getElement("viewName", AppConstants.NAMESPACE_FORMBUILDER).innerData;
            }
            if (formHelper.xmlAccess.has.dxlGeneratedOn)
            {
                /*this.dxlGeneratedOn = Date.fromString(
                    formHelper.xmlAccess.att.dxlGeneratedOn
                );*/
            }

            // parse `fields`
            var fieldsHelper = formHelper.forChild("fields", AppConstants.NAMESPACE_FORMBUILDER);
            for (field in fieldsHelper.getElements('field', AppConstants.NAMESPACE_FORMBUILDER))
            {
                var tmpField:DominoFormFieldVO = new DominoFormFieldVO();
                tmpField.fromXML(field);
                fields.add(tmpField);
            }
        }
        
        if (callback != null)
        {
            callback();
        }
    }
    
    public function toXML():Xml
    {
        var xml:Xml = Xml.createElement(ELEMENT_NAME);
        xml.set("hasWebAccess", Std.string(hasWebAccess));
        xml.set("name", (formName!=null)?formName:"");
        
        var tempXML:Xml = Xml.createElement("fb:viewName");
        tempXML.addChild(Xml.createCData((viewName!=null)?viewName:""));
        xml.addChild(tempXML);
        
        var fieldXml:Xml;
        tempXML = Xml.createElement("fb:fields");
        for (field in fields)
        {
            fieldXml = field.toXML();
            ComponentXMLMapping.getInstance().registerComponent(field, haxe.xml.Printer.print(fieldXml, true));
            tempXML.addChild(fieldXml);
        }
        xml.addChild(tempXML);
        
        if (dxlGeneratedOn == null) dxlGeneratedOn = Date.now();
        xml.set("dxlGeneratedOn", dxlGeneratedOn.toString());
        return xml;
    }
    
    //--------------------------------------------------------------------------
    //
    //  DXL/XML
    //
    //--------------------------------------------------------------------------
    
    public function toCode():String
    {
        var table:String = DominoTemplatesManager.getTableTemplate();
        
        // generate rows/columns
        var tmpRows:String = "";
        for (field in fields)
        {
            tmpRows += field.toCode();
        }
        
        var ereg:EReg = ~/%rows%/ig;
        table = ereg.replace(table, tmpRows);
        return table;
    }
    
    public function toViewColumnsCode():String
    {
        var column:String = DominoTemplatesManager.getViewColumn().toLowerCase();
        
        // generate rows/columns
        var tmpColumns:String = "";
        var tmpColumn:String = "";
        var ereg:EReg = null;
        for (field in fields)
        {
            if (field.isIncludeInView)
            {
                tmpColumn = ~/%fieldname%/ig.replace(column, field.name);
                tmpColumn = ~/%sort%/ig.replace(tmpColumn, field.sortOption.value);
                tmpColumn = ~/%categorized%/ig.replace(tmpColumn, Std.string(field.sortOption.isCategorized));
                tmpColumn = ~/%label%/ig.replace(tmpColumn, field.label);
                
                tmpColumns += tmpColumn;
            }
        }
        
        return tmpColumns;
    }

    public function toSubformVOExtends():String
    {
        var subformVOInterfaces:String = "";
        if (subFormsNames != null && subFormsNames.length > 0)
        {
            var subFormsNamesCount:Int = subFormsNames.length;
            for (i in 0...subFormsNamesCount)
            {
                var subformName:String = subFormsNames[i];
                var nextInterfaceColon:String = i == subFormsNamesCount - 1 ? "" : ",";
                subformVOInterfaces += "I" + subformName + "VO" + nextInterfaceColon;
            }
        }

        return subformVOInterfaces;
    }
}
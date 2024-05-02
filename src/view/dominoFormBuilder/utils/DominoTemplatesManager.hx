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
package view.dominoFormBuilder.utils;

import haxe.Resource;

class DominoTemplatesManager
{
    public static function getFormTemplate():String
    {
        var templateFile:String = "form.dxl";
        return readAndReturnAsString(templateFile);
    }
    
    public static function getFormParTemplate():String
    {
        var templateFile = "form-par.dxl";
        return readAndReturnAsString(templateFile);
    }
    
    public static function getTableTemplate():String
    {
        var templateFile = "table.dxl";
        return readAndReturnAsString(templateFile);
    }
    
    public static function getTableRowTemplate():String
    {
        var templateFile = "table-row.dxl";
        return readAndReturnAsString(templateFile);
    }
    
    public static function getTableCellTemplate():String
    {
        var templateFile = "table-cell.dxl";
        return readAndReturnAsString(templateFile);
    }
    
    public static function getFieldTemplate(type:String, multivalue:Bool, editable:String):String
    {
        var fileName:String = "field_"+ type.toLowerCase() +"_";
        fileName += (multivalue ? "m" : "s") +"_";
        switch(editable)
        {
            case "Editable":
                fileName += "e";
            case "Computed":
                fileName += "c";
            case "Compute on compose":
                fileName += "cwc";
            case "Compute for display":
                fileName += "cfd";
        }
        
        // since we have file-access problem within library project
        // we'll request the file available in main application sandbox
        var templateFile:String = fileName +".dxl";
        return readAndReturnAsString(templateFile);
    }
    
    public static function getViewTemplate():String
    {
        var templateFile = "view.dxl";
        return readAndReturnAsString(templateFile);
    }
    
    public static function getViewColumn():String
    {
        var templateFile = "view-column.dxl";
        return readAndReturnAsString(templateFile);
    }
    
    private static function readAndReturnAsString(path:String):String
    {
        #if !html5
            // File api read?
        #end
        return Resource.getString(path);
    }
}
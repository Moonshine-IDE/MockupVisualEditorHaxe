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

import utils.MoonshineBridgeUtils;
import view.dominoFormBuilder.vo.DominoFormVO;

class FormBuilderCodeUtils 
{
    public static function loadFromFile(path:String, toFormObject:DominoFormVO, ?onSuccess:()->Void):Void
    {
        function successHandler(file:String, output:Dynamic)
        {
            if (output != null)
            {
                toFormObject.fromXML(Xml.parse(StringTools.trim(Std.string(output))), onSuccess);
            }
            else if (onSuccess != null)
            {
                onSuccess();
            }
        } 
        function errorHandler(error:String)
        {
            if (onSuccess != null) 
                onSuccess();
        }
        
        MoonshineBridgeUtils.moonshineBridgeFormBuilderInterface.readAsync(path, successHandler, errorHandler);
    }

    public static function toDominoCode(formObject:DominoFormVO):Xml
    {
        var form:String = DominoTemplatesManager.getFormTemplate();
        var par:String = DominoTemplatesManager.getFormParTemplate();
        
        var ereg:EReg = ~/%value%/ig;
        var formBody:String = ereg.replace(par, formObject.viewName);
        formBody += formObject.toCode();
        
        ereg = ~/%formname%/ig;
        form = ereg.replace(form, formObject.formName);
        ereg = ~/%frombody%/ig;
        form = ereg.replace(form, formBody);
        
        return Xml.parse(form);
    }
    
    public static function toViewCode(formObject:DominoFormVO):Xml
    {
        var view:String = DominoTemplatesManager.getViewTemplate();

        var ereg:EReg = ~/%viewname%/ig;
        view = ereg.replace(view, formObject.viewName);
        ereg = ~/%formname%/ig;
        view = ereg.replace(view, formObject.formName);
        ereg = ~/%columns%/ig;
        view = ereg.replace(view, formObject.toViewColumnsCode());
        
        return Xml.parse(view);
    }
}
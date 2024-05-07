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

import feathers.data.ArrayCollection;

enum abstract FormBuilderEditableType(String) to String 
{
    var EDITABLE = "Editable";
    var COMPUTED = "Computed";
    var COMPUTE_ON_COMPOSE = "Compute on compose";
    var COMPUTE_FOR_DISPLAY = "Compute for display";

    private static var _editableTypes:ArrayCollection<FormBuilderEditableType>;
    public static var editableTypes(get, never):ArrayCollection<FormBuilderEditableType>;
    private static function get_editableTypes():ArrayCollection<FormBuilderEditableType>
    {
        if (_editableTypes == null)
        {
            _editableTypes = new ArrayCollection([EDITABLE, COMPUTED, COMPUTE_ON_COMPOSE, COMPUTE_FOR_DISPLAY]);
        }
        
        return _editableTypes;
    }

    private static var _editableTypesRichtext:ArrayCollection<FormBuilderEditableType>;
    public static var editableTypesRichtext(get, never):ArrayCollection<FormBuilderEditableType>;
    private static function get_editableTypesRichtext():ArrayCollection<FormBuilderEditableType>
    {
        if (_editableTypesRichtext == null)
        {
            _editableTypesRichtext = new ArrayCollection([EDITABLE, COMPUTED]);
        }
        
        return _editableTypesRichtext;
    }
}
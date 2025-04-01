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
package view.dominoFormBuilder.supportClasses;

import view.dominoFormBuilder.supportClasses.events.FormBuilderEvent;
import haxeScripts.events.GlobalEventDispatcher;
import feathers.core.InvalidationFlag;
import openfl.events.Event;
import view.supportClasses.events.PropertyEditorChangeEvent;
import view.dominoFormBuilder.utils.FormBuilderCodeUtils;
import view.dominoFormBuilder.vo.DominoFormVO;
import feathers.controls.LayoutGroup;

class DominoFormBuilderBaseEditor extends LayoutGroup 
{
    public var tabularTab:DominoTabularForm;

    private var _dominoForm:DominoFormVO = new DominoFormVO();
    public var dominoForm(get, set):DominoFormVO;
    private function get_dominoForm():DominoFormVO
    {
        return _dominoForm;   
    }
    private function set_dominoForm(value:DominoFormVO):DominoFormVO
    {
        _dominoForm = value;
        return _dominoForm;   
    }

    private var _filePath:String;
    public var filePath(get, set):String;
    private function get_filePath():String
    {
        return _filePath;   
    }
    private function set_filePath(value:String):String
    {
        if (_filePath != value)
        {
            _filePath = value;
        }
        return _filePath;
    }

    public function new()
    {
        super();
    }

    public var formXML(get, never):Xml;
    private function get_formXML():Xml
    {
        return dominoForm.toXML();
    }
    
    public var formDXL(get, never):Xml;
    private function get_formDXL():Xml
    {
        return FormBuilderCodeUtils.toDominoCode(dominoForm);
    }
    
    public var viewDXL(get, never):Xml;
    private function get_viewDXL():Xml
    {
        return FormBuilderCodeUtils.toViewCode(dominoForm);
    }
    
    public function release():Void
    {
        this.removeChangeListeners();
    }

    public function retrieveFromFile():Void
    {
        FormBuilderCodeUtils.loadFromFile(filePath, dominoForm, addChangeListeners);
    }

    //--------------------------------------------------------------------------
    //
    //  PRIVATE API
    //
    //--------------------------------------------------------------------------
    
    private function addChangeListeners():Void
    {
        this.removeChangeListeners();
        
        //this.dominoForm.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onFormPropertyChanged);
        this.dominoForm.fields.addEventListener(Event.CHANGE, onFormFieldsCollectionChanged);

        this.setInvalid(InvalidationFlag.DATA);
        GlobalEventDispatcher.getInstance().dispatchEvent(new FormBuilderEvent(FormBuilderEvent.FORM_POPULATED));
    }
    
    private function removeChangeListeners():Void
    {
        //this.dominoForm.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onFormPropertyChanged);
        this.dominoForm.fields.removeEventListener(Event.CHANGE, onFormFieldsCollectionChanged);
    }
    
    private function onFormPropertyChanged(event:Event):Void
    {
        this.tabularTab.dispatchEvent(new PropertyEditorChangeEvent(PropertyEditorChangeEvent.PROPERTY_EDITOR_CHANGED, null));
    }
    
    private function onFormFieldsCollectionChanged(event:Event):Void
    {
        this.onFormPropertyChanged(null);
    }
}
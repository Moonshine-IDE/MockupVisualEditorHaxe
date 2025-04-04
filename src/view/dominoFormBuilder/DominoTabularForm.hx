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
package view.dominoFormBuilder;

import view.dominoFormBuilder.vo.DominoFormFieldVO;
import feathers.layout.AnchorLayoutData;
import feathers.layout.AnchorLayout;
import haxeScripts.valueObjects.ProjectVO;
import view.dominoFormBuilder.vo.DominoFormVO;
import feathers.layout.VerticalLayoutData;
import feathers.layout.VerticalLayout;
import utils.MoonshineBridgeUtils;
import view.interfaces.IDominoFormBuilderLibraryBridge;
import feathers.controls.LayoutGroup;

class DominoTabularForm extends LayoutGroup 
{
    public var isDefaultItem:Bool;
    public var selectedProject:ProjectVO;

    private var _filePath:String;
    public var filePath(get, set):String;
    private function get_filePath():String
    {
        return _filePath;
    }
    private function set_filePath(value:String):String
    {
        _filePath = value;
        if (this.formDescriptor != null) 
        {
            this.formDescriptor.filePath = value;
        }
        return _filePath;
    }

    public var moonshineBridge(get, set):IDominoFormBuilderLibraryBridge;
    private function set_moonshineBridge(value:IDominoFormBuilderLibraryBridge):IDominoFormBuilderLibraryBridge
    {
        MoonshineBridgeUtils.moonshineBridgeFormBuilderInterface = value;
        return value;
    }
    private function get_moonshineBridge():IDominoFormBuilderLibraryBridge
    {
        return MoonshineBridgeUtils.moonshineBridgeFormBuilderInterface;
    }

    public var isFormValid(get, never):Bool;
    private function get_isFormValid():Bool
    {
        return formDescriptor.validateForm();
    }
    
    public var formXML(get, never):Xml;
    private function get_formXML():Xml
    {
        return formDescriptor.formXML;
    }
    
    public var formDXL(get, never):Xml;
    private function get_formDXL():Xml
    {
        return formDescriptor.formDXL;
    }
    
    public var viewDXL(get, never):Xml;
    private function get_viewDXL():Xml
    {
        return formDescriptor.viewDXL;
    }
    
    public var formObject(get, never):DominoFormVO;
    private function get_formObject():DominoFormVO
    {
        return formDescriptor.dominoForm;
    }

    public var selectedItem(get, never):DominoFormFieldVO;
    private function get_selectedItem():DominoFormFieldVO
    {
        return formDescriptor.selectedItem;
    }
    
    private var formDescriptor:FormDescriptor;

    public function new()
    {
        super();
        this.minWidth = 300;
		this.minHeight = 300;
    }

    override private function initialize():Void 
    {
		this.layout = new AnchorLayout();

        formDescriptor = new FormDescriptor();
        formDescriptor.filePath = this.filePath;
        formDescriptor.isDefaultItem = this.isDefaultItem;
        formDescriptor.selectedProject = this.selectedProject;
        formDescriptor.layoutData = AnchorLayoutData.fill();
        formDescriptor.tabularTab = this;
        this.addChild(formDescriptor);

        super.initialize();
    }

    public function release():Void
    {
        formDescriptor.release();
    }

    public function requestSaveByOwner():Void
    {
        formDescriptor.requestSaveByOwner();
    }

    public function onFormSaved():Void
    {
        formDescriptor.onFormSaved();
    }

    public function addNewFieldRequest():Void
    {
        formDescriptor.addNewFieldRequest();
    }
}
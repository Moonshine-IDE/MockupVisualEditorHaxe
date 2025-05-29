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

import openfl.events.Event;
import feathers.events.TriggerEvent;
import feathers.controls.Button;
import feathers.skins.RectangleSkin;
import theme.AppTheme;
import feathers.text.TextFormat;
import feathers.controls.Label;
import feathers.core.InvalidationFlag;
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
    public static final EVENT_OPEN_CODE = "event-open-code-view";

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

    private var _isCodeError:Bool;
    public var isCodeError(never, set):Bool;
    private function set_isCodeError(value:Bool):Bool
    {
        if (_isCodeError == value) 
            return _isCodeError;

        _isCodeError = value;
        this.setInvalid(InvalidationFlag.DATA);
        return _isCodeError;
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

    public var updateWithXml(never, set):Xml;
    private function set_updateWithXml(value:Xml):Xml
    {
        formDescriptor.updateWithXml = value;
        return null;
    }
    
    private var formDescriptor:FormDescriptor;
    private var errorMessageContainer:LayoutGroup;

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

        errorMessageContainer = new LayoutGroup();
        errorMessageContainer.layout = new AnchorLayout();
        errorMessageContainer.backgroundSkin = new RectangleSkin(
            SolidColor(AppTheme.isDarkMode() ? 0x383838 : 0xffffff), 
            SolidColor(2, AppTheme.isDarkMode() ? 0x222222 : 0x999999)
            );
        errorMessageContainer.layoutData = AnchorLayoutData.fill();
        errorMessageContainer.includeInLayout = errorMessageContainer.visible = false;
        this.addChild(errorMessageContainer);

        var lblErrorMessage:Label = new Label("Invalid XML in Code view. Fix errors to continue.");
        lblErrorMessage.layoutData = AnchorLayoutData.center(0, -30);
        lblErrorMessage.textFormat = new TextFormat(AppTheme.DEFAULT_FONT, 14, AppTheme.isDarkMode() ? 0xff3333 : 0xff0000);
        errorMessageContainer.addChild(lblErrorMessage);

        var btnNavToCode = new Button("Go to Code");
        btnNavToCode.variant = AppTheme.THEME_VARIANT_BUTTON_SECTION;
        btnNavToCode.layoutData = AnchorLayoutData.center(0, 10);
        btnNavToCode.addEventListener(TriggerEvent.TRIGGER, onNavToCode, false, 0, true);
        errorMessageContainer.addChild(btnNavToCode);

        super.initialize();
    }

    override private function update():Void 
    {
        var dataInvalid = this.isInvalid(InvalidationFlag.DATA);
        if (dataInvalid) 
        {
            if (this._isCodeError)
            {
                this.formDescriptor.includeInLayout = this.formDescriptor.visible = false;
                this.errorMessageContainer.includeInLayout = this.errorMessageContainer.visible = true;
            }
            else if (!this.formDescriptor.visible)
            {
                this.errorMessageContainer.includeInLayout = this.errorMessageContainer.visible = false;
                this.formDescriptor.includeInLayout = this.formDescriptor.visible = true;
            }
        }

        super.update();
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

    private function onNavToCode(event:TriggerEvent):Void
    {
        this.dispatchEvent(new Event(EVENT_OPEN_CODE));
    }
}
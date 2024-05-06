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

import view.dominoFormBuilder.supportClasses.events.VisualEditorEvent;
import feathers.validators.Validator;
import feathers.layout.HorizontalLayoutData;
import haxeScripts.ui.Spacer;
import feathers.controls.Button;
import feathers.controls.Radio;
import feathers.layout.HorizontalLayout;
import feathers.controls.FormItem;
import feathers.controls.TextInput;
import haxeScripts.ui.Line;
import feathers.events.FormEvent;
import feathers.controls.Form;
import view.renderers.DeleteGridItemRenderer;
import view.dominoFormBuilder.vo.DominoFormFieldVO;
import openfl.events.Event;
import view.renderers.EditGridItemRenderer;
import view.renderers.FieldIncludeInGridItemRenderer;
import feathers.controls.GridViewColumn;
import feathers.data.ArrayCollection;
import openfl.display.DisplayObject;
import feathers.data.GridViewCellState;
import feathers.utils.DisplayObjectRecycler;
import feathers.layout.AnchorLayoutData;
import feathers.controls.GridView;
import feathers.layout.AnchorLayout;
import feathers.skins.RectangleSkin;
import feathers.text.TextFormat;
import feathers.controls.Label;
import feathers.layout.VerticalLayoutData;
import feathers.controls.LayoutGroup;
import feathers.layout.VerticalLayout;
import feathers.core.ToggleGroup;
import feathers.validators.StringValidator;
import view.dominoFormBuilder.supportClasses.DominoFormBuilderBaseEditor;
import views.renderers.GridViewColumnMultiline;

class FormDescriptor extends DominoFormBuilderBaseEditor 
{
    private var svFormName:StringValidator;
    private var svViewName:StringValidator;
    private var rbgWebForm:ToggleGroup;
    private var dgFields:GridView;
    private var columnMultilineStateRecycler:DisplayObjectRecycler<Dynamic, GridViewCellState, DisplayObject>;
    private var visibilityStateRecycler:DisplayObjectRecycler<Dynamic, GridViewCellState, DisplayObject>;
    private var editRecycler:DisplayObjectRecycler<Dynamic, GridViewCellState, DisplayObject>;
    private var deleteRecycler:DisplayObjectRecycler<Dynamic, GridViewCellState, DisplayObject>;
    private var textFormName:TextInput;
    private var textViewName:TextInput;
    private var rbWebFormYes:Radio;
    private var rbWebFormNo:Radio;

    public function new()
    {
        super();

        this.columnMultilineStateRecycler = DisplayObjectRecycler.withFunction(() -> {
            return (new GridViewColumnMultiline());
		}, (itemRenderer:GridViewColumnMultiline, state:GridViewCellState) -> {
			itemRenderer.label.text = state.text;
		},
		(itemRenderer:GridViewColumnMultiline, state:GridViewCellState) -> {
			itemRenderer.label.text = "";
		});

        this.visibilityStateRecycler = DisplayObjectRecycler.withFunction(() -> {
            return (new FieldIncludeInGridItemRenderer());
		});

        this.editRecycler = DisplayObjectRecycler.withFunction(() -> {
			var itemRenderer = new EditGridItemRenderer();
			itemRenderer.addEventListener(EditGridItemRenderer.EVENT_EDIT, this.onItemEditRequest, false, 0, true);
			return itemRenderer;
		}, null, null, (itemRenderer:EditGridItemRenderer) -> {
			itemRenderer.removeEventListener(EditGridItemRenderer.EVENT_EDIT, this.onItemEditRequest);
		});

        this.deleteRecycler = DisplayObjectRecycler.withFunction(() -> {
			var itemRenderer = new DeleteGridItemRenderer();
			itemRenderer.addEventListener(DeleteGridItemRenderer.EVENT_DELETE, this.onItemDeleteRequest, false, 0, true);
			return itemRenderer;
		}, null, null, (itemRenderer:DeleteGridItemRenderer) -> {
			itemRenderer.removeEventListener(DeleteGridItemRenderer.EVENT_DELETE, this.onItemDeleteRequest);
		});
    }

    override private function initialize():Void 
    {
        var thisLayout = new VerticalLayout();
		thisLayout.horizontalAlign = CENTER;
		thisLayout.gap = 10;
		this.layout = thisLayout;

        var lblTitle = new Label("New Domino Form");
        lblTitle.textFormat = new TextFormat("_sans", 24, 0xe252d3);
        lblTitle.layoutData = new VerticalLayoutData(100);
        this.addChild(lblTitle);

        var line = new Line();
        line.layoutData = new VerticalLayoutData(100);
        this.addChild(line);

        var form = new Form();
        form.layoutData = new VerticalLayoutData(100);
        form.addEventListener(FormEvent.SUBMIT, this.onFormSubmit, false, 0, true);
        this.addChild(form);

        var formNameItem = new FormItem("Form Name", null, true);
        formNameItem.horizontalAlign = JUSTIFY;
        this.textFormName = new TextInput();
        formNameItem.content = this.textFormName;
        form.addChild(formNameItem);

        var viewNameItem = new FormItem("View Name", null, true);
        viewNameItem.horizontalAlign = JUSTIFY;
        this.textViewName = new TextInput();
        viewNameItem.content = this.textViewName;
        form.addChild(viewNameItem);

        var webFormItem = new FormItem("Is this a web form?");
        webFormItem.horizontalAlign = JUSTIFY;
        var radioContainer = new LayoutGroup();
        radioContainer.layout = new HorizontalLayout();
        cast(radioContainer.layout, HorizontalLayout).gap = 10;
        this.rbWebFormYes = new Radio("Yes");
        this.rbWebFormYes.toggleGroup = this.rbgWebForm;
        this.rbWebFormNo = new Radio("No", true);
        this.rbWebFormNo.toggleGroup = this.rbgWebForm;
        radioContainer.addChild(this.rbWebFormYes);
        radioContainer.addChild(this.rbWebFormNo);
        webFormItem.content = radioContainer;
        form.addChild(webFormItem);

        var borderedHolder = new LayoutGroup();
		borderedHolder.backgroundSkin = new RectangleSkin(SolidColor(0xCCCCCC), SolidColor(1, 0x999999));
		borderedHolder.layout = new AnchorLayout();
		borderedHolder.layoutData = new VerticalLayoutData(100, 100);
		this.addChild(borderedHolder);

        this.dgFields = new GridView();
        this.dgFields.layoutData = new AnchorLayoutData(30, 30, 30, 30);
        this.dgFields.variant = GridView.VARIANT_BORDERLESS;
        this.dgFields.resizableColumns = true;
        this.dgFields.dragEnabled = true;
        this.dgFields.dropEnabled = true;
        this.dgFields.cellRendererRecycler = this.columnMultilineStateRecycler;
        //this.dgFields.addEventListener(GridViewEvent.CELL_TRIGGER, onGridViewChangeEvent, false, 0, true);

        var columnVisibility = new GridViewColumn("Visible", null, 60);
        columnVisibility.cellRendererRecycler = this.visibilityStateRecycler;
        var columnEdit = new GridViewColumn("", null, 100);
        columnEdit.cellRendererRecycler = this.editRecycler;

        this.dgFields.columns = new ArrayCollection([
            columnVisibility,
            new GridViewColumn("Label", (data) -> data.label),
            new GridViewColumn("Name", (data) -> data.name),
            new GridViewColumn("Type", (data) -> data.type),
            columnEdit
        ]);

        borderedHolder.addChild(this.dgFields);

        var footerContainer = new LayoutGroup();
        footerContainer.layout = new HorizontalLayout();
        footerContainer.layoutData = new VerticalLayoutData(100);
        this.addChild(footerContainer);

        var btnAdd = new Button("Add");
        footerContainer.addChild(btnAdd);

        var spacer = new Spacer();
		spacer.layoutData = new HorizontalLayoutData(100.0);
        footerContainer.addChild(spacer);
        
        var btnSave = new Button("Save &amp; Generate DXL");
        footerContainer.addChild(btnSave);

        super.initialize();
    }

    public function validateForm():Bool
    {
        // validation test
        var isAllRight = true;
        var events = Validator.validateAll([this.svFormName, this.svViewName]);
        for (validatorEvent in events)
        {
            for (validationResult in validatorEvent.results)
            {
                if (validationResult.isError)
                {
                    isAllRight = false;
                    break;
                }   
            }
        }

        return isAllRight;
    }

    private function onItemEditRequest(event:Event):Void
    {
		var formObject = cast(cast(event.currentTarget, EditGridItemRenderer).data, DominoFormFieldVO);   
    }

    private function onItemDeleteRequest(event:Event):Void
    {
        var formObject = cast(cast(event.currentTarget, DeleteGridItemRenderer).data, DominoFormFieldVO);
    }

    private function onFormSubmit(event:FormEvent):Void
    {
        if (this.validateForm())
        {
            tabularTab.dispatchEvent(new VisualEditorEvent(VisualEditorEvent.SAVE_CODE));
        }
    }
}
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

import theme.AppTheme;
import openfl.events.KeyboardEvent;
import feathers.controls.TitleWindow;
import openfl.ui.Keyboard;
import feathers.data.ArrayCollection;
import openfl.events.Event;
import feathers.validators.Validator;
import feathers.validators.IValidator;
import feathers.events.ValidationResultEvent;
import feathers.validators.StringValidator;
import view.dominoFormBuilder.vo.FormBuilderSortingType;
import view.dominoFormBuilder.vo.FormBuilderEditableType;
import view.dominoFormBuilder.vo.FormBuilderFieldType;
import view.dominoFormBuilder.vo.DominoFormFieldVO;
import haxeScripts.ui.Line;
import feathers.core.PopUpManager;
import feathers.events.TriggerEvent;
import feathers.text.TextFormat;
import feathers.controls.Button;
import feathers.controls.Header;
import feathers.controls.Panel;
import feathers.layout.HorizontalLayout;
import feathers.core.ToggleGroup;
import feathers.controls.TextArea;
import feathers.controls.Radio;
import feathers.controls.PopUpListView;
import feathers.controls.TextInput;
import haxeScripts.ui.FormHeader;
import feathers.controls.FormItem;
import feathers.events.FormEvent;
import feathers.layout.VerticalLayoutData;
import feathers.controls.Form;
import feathers.layout.VerticalLayout;
import feathers.controls.LayoutGroup;

class FormFieldDescriptor extends TitleWindow 
{
    public static final EVENT_FORM_SUBMITS = "event-form-submits";

    public var editItem:DominoFormFieldVO;
    
    private var _isCancelled:Bool;
    public var isCancelled(get, never):Bool;
    private function get_isCancelled():Bool
    {
        return _isCancelled;
    }
    
    private var isItemEdit:Bool;
    private var txtName:TextInput;
    private var textLabel:TextInput;
    private var textDescription:TextInput;
    private var ddlType:PopUpListView;
    private var rbMultiYes:Radio;
    private var rbMultiNo:Radio;
    private var ddlEditable:PopUpListView;
    private var textFormula:TextArea;
    private var ddlSort:PopUpListView;
    private var rbgInclude:ToggleGroup = new ToggleGroup();
    private var rbgMultivalue:ToggleGroup = new ToggleGroup();
    private var formulaItem:FormItem;
    private var nameValidator:StringValidator;
    private var formulaValidator:StringValidator;

    public function new()
    {
        super();
        this.closeEnabled = true;
        this.title = "Add/Edit Field";
    } 

    override private function initialize():Void 
    {
        var rootLayout = new VerticalLayout();
        rootLayout.paddingBottom = 10;
        rootLayout.paddingLeft = 40;
        rootLayout.paddingRight = 40;
        rootLayout.paddingTop = 10;
        rootLayout.gap = 10;
        this.layout = rootLayout;

        var form = new Form();
        form.layoutData = new VerticalLayoutData(100);
        form.addEventListener(FormEvent.SUBMIT, this.onFormSubmit, false, 0, true);
        this.addChild(form);

        var formHeader1 = new FormHeader("General Information");
        form.addChild(formHeader1);
        
        this.txtName = new TextInput();
        this.txtName.restrict = "0-9A-Za-z_";
        var nameItem = new FormItem("Name:", this.txtName, true);
        nameItem.horizontalAlign = JUSTIFY;
        form.addChild(nameItem);

        this.textLabel = new TextInput();
        var labelItem = new FormItem("Label:", this.textLabel);
        labelItem.horizontalAlign = JUSTIFY;
        form.addChild(labelItem);

        this.textDescription = new TextInput();
        var descItem = new FormItem("Description:", this.textDescription);
        descItem.horizontalAlign = JUSTIFY;
        form.addChild(descItem);

        this.ddlType = new PopUpListView();
        this.ddlType.dataProvider = FormBuilderFieldType.fieldTypes; 
        this.ddlType.addEventListener(Event.CHANGE, onFieldTypeChanged, false, 0, true);
        var typeItem = new FormItem("Description:", this.ddlType);
        typeItem.horizontalAlign = JUSTIFY;
        form.addChild(typeItem);

        var multiValueContainer = new LayoutGroup();
        multiValueContainer.layout = new HorizontalLayout();
        cast(multiValueContainer.layout, HorizontalLayout).gap = 10;
        this.rbMultiYes = new Radio("Yes");
        this.rbMultiYes.toggleGroup = this.rbgMultivalue;
        this.rbMultiNo = new Radio("No", true);
        this.rbMultiNo.toggleGroup = this.rbgMultivalue;
        multiValueContainer.addChild(this.rbMultiYes);
        multiValueContainer.addChild(this.rbMultiNo);
        var multivalueItem = new FormItem("Multivalue:", multiValueContainer);
        multivalueItem.horizontalAlign = JUSTIFY;
        form.addChild(multivalueItem);

        this.ddlEditable = new PopUpListView();
        this.ddlEditable.dataProvider = FormBuilderEditableType.editableTypes;
        this.ddlEditable.addEventListener(Event.CHANGE, this.updateFormulaState, false, 0, true);
        var editableItem = new FormItem("Editable:", this.ddlEditable);
        editableItem.horizontalAlign = JUSTIFY;
        form.addChild(editableItem);

        this.textFormula = new TextArea();
        this.textFormula.prompt = "Enter formula";
        this.formulaItem = new FormItem("Formula:", this.textFormula);
        this.formulaItem.horizontalAlign = JUSTIFY;
        form.addChild(this.formulaItem);

        var formHeader2 = new FormHeader("View Options");
        form.addChild(formHeader2);

        var visibleContainer = new LayoutGroup();
        visibleContainer.layout = new HorizontalLayout();
        cast(visibleContainer.layout, HorizontalLayout).gap = 10;
        var rbVisibleMultiYes = new Radio("Yes");
        rbVisibleMultiYes.toggleGroup = this.rbgInclude;
        var rbVisibleMultiNo = new Radio("No");
        rbVisibleMultiNo.toggleGroup = this.rbgInclude;
        visibleContainer.addChild(rbVisibleMultiYes);
        visibleContainer.addChild(rbVisibleMultiNo);
        var visibleItem = new FormItem("Include in View:", visibleContainer);
        visibleItem.horizontalAlign = JUSTIFY;
        form.addChild(visibleItem);

        this.ddlSort = new PopUpListView();
        this.ddlSort.dataProvider = FormBuilderSortingType.sortTypes;
        this.ddlSort.itemToText = (data) -> data.label;
        var sortItem = new FormItem("Sorting:", this.ddlSort);
        sortItem.horizontalAlign = JUSTIFY;
        form.addChild(sortItem);

        var footer = new LayoutGroup();
        footer.layout = new VerticalLayout();
        cast(footer.layout, VerticalLayout).gap = 4;

        var line = new Line();
        line.customVariant = AppTheme.THEME_VARIANT_LINE;
        line.layoutData = new VerticalLayoutData(100);
        footer.addChild(line);

        var buttonsContainerLayout = new HorizontalLayout();
        buttonsContainerLayout.setPadding(10);
        buttonsContainerLayout.gap = 10;
        buttonsContainerLayout.horizontalAlign = CENTER;

        var buttonsContainer = new LayoutGroup();
        buttonsContainer.layout = buttonsContainerLayout;
        buttonsContainer.layoutData = new VerticalLayoutData(100);
        footer.addChild(buttonsContainer);

        var btnSubmit = new Button("SUBMIT");
        buttonsContainer.addChild(btnSubmit);

        this.footer = footer;
        form.submitButton = btnSubmit;

        this.setupValidators();
        this.onCreationCompletes();
        super.initialize();
    }

    override private function closeButton_triggerHandler(event:TriggerEvent):Void 
    {
        this._isCancelled = true;
        this.closePopup();
    }

    override private function titleWindow_keyDownHandler(event:KeyboardEvent):Void 
    {
        switch (event.keyCode) {
            case Keyboard.ESCAPE:
            {
                this.closeButton_triggerHandler(null);
            }
        }
    }

    private function setupValidators():Void
    {
        this.nameValidator = new StringValidator();
        this.nameValidator.source = null;
        this.nameValidator.valueFunction = () -> this.txtName.text;
        this.nameValidator.triggerEvent = null;
        this.nameValidator.addEventListener(ValidationResultEvent.VALID, event -> {
            this.txtName.errorString = null;
        }, false, 0, true);
        this.nameValidator.addEventListener(ValidationResultEvent.INVALID, event -> {
            var errorString = "";
            for (validationResult in event.results)
            {
                if (!validationResult.isError)
                {
                    continue;   
                }
                if (errorString.length > 0)
                {
                    errorString += "\n";
                }
                errorString += validationResult.errorMessage;
            }
            this.txtName.errorString = errorString;
        }, false, 0, true);
    }

    private function onCreationCompletes():Void
    {
        this.isItemEdit = (this.editItem != null);
        if (this.editItem == null) 
            this.editItem = new DominoFormFieldVO();

        // set edit fields or update
        if (isItemEdit)
        {
            this.txtName.text = this.editItem.name;
            this.textLabel.text = this.editItem.label;
            this.textDescription.text = this.editItem.description;
            this.rbgMultivalue.getItemAt(this.editItem.isMultiValue ? 0 : 1).selected = true;
            this.rbgInclude.getItemAt(this.editItem.isIncludeInView ? 0 : 1).selected = true;
            this.textFormula.text = this.editItem.formula;
            this.ddlType.selectedItem = this.editItem.type;
            this.ddlEditable.selectedItem = this.editItem.editable;
            this.updateSortingSelection();
            this.updateFormulaState(null);
            this.onFieldTypeChanged(null);
        }
        else
        {
            this.editItem.type = this.ddlType.selectedItem;
            this.editItem.editable = this.ddlEditable.selectedItem;
            this.editItem.sortOption = this.ddlSort.selectedItem;
        }
    }

    private function onFormSubmit(event:FormEvent):Void
    {
        var validators:Array<IValidator> = [this.nameValidator];
        if (this.ddlEditable.selectedItem != FormBuilderEditableType.EDITABLE)
        {
            validators.push(this.formulaValidator);
        }

        // validation test
        var hasErrors = false;
        var events = Validator.validateAll(validators);
        for (validatorEvent in events)
        {
            for (validationResult in validatorEvent.results)
            {
                if (validationResult.isError)
                {
                    hasErrors = true;
                    break;
                }   
            }
        }

        if (hasErrors) 
            return;

        this.editItem.name = this.txtName.text;
        this.editItem.label = this.textLabel.text;
        this.editItem.description = this.textDescription.text;
        this.editItem.type = this.ddlType.selectedItem;
        this.editItem.isMultiValue = (this.rbgMultivalue.selectedIndex == 0);
        this.editItem.isIncludeInView = (this.rbgInclude.selectedIndex == 0);
        this.editItem.editable = this.ddlEditable.selectedItem;
        this.editItem.formula = this.textFormula.text;
        this.editItem.sortOption = this.ddlSort.selectedItem;

        this.dispatchEvent(new Event(EVENT_FORM_SUBMITS));
        this.closePopup();
    }

    private function closePopup():Void
    {
        PopUpManager.removePopUp(this);
    }

    private function updateSortingSelection():Void
    {
        for (sortType in FormBuilderSortingType.sortTypes)
        {
            if (this.editItem.sortOption.label == sortType.label)
            {
                this.ddlSort.selectedItem = sortType;
                break;
            }
        }
    }

    private function updateFormulaState(event:Event):Void
    {
        var selectedItem = this.ddlEditable.selectedItem;
        this.formulaItem.required = (selectedItem != FormBuilderEditableType.EDITABLE);
        if (!this.formulaItem.required)
        {
            // remove validation error tip
            this.textFormula.errorString = null;
        }
    }

    private function onFieldTypeChanged(event:Event):Void
    {
        function updateEditableProvider(value:ArrayCollection<FormBuilderEditableType>)
        {
            this.ddlEditable.dataProvider = value;
            this.ddlEditable.dispatchEvent(new Event(Event.CHANGE));
        }

        var selectedItem = this.ddlType.selectedItem;
        if (selectedItem == FormBuilderFieldType.RICH_TEXT)
        {
            this.rbgMultivalue.selectedIndex = 1;
            this.rbMultiYes.enabled = false;
            updateEditableProvider(FormBuilderEditableType.editableTypesRichtext);
        }
        else if (!this.rbMultiYes.enabled)
        {
            this.rbMultiYes.enabled = true;
            updateEditableProvider(FormBuilderEditableType.editableTypes);
        }
    }
}
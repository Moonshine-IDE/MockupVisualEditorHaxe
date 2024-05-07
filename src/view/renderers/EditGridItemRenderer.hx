package view.renderers;

import openfl.events.MouseEvent;
import openfl.events.Event;
import feathers.events.TriggerEvent;
import feathers.layout.AnchorLayoutData;
import feathers.layout.AnchorLayout;
import feathers.controls.AssetLoader;
import feathers.controls.dataRenderers.LayoutGroupItemRenderer;

class EditGridItemRenderer extends LayoutGroupItemRenderer 
{
    public static final EVENT_EDIT = "event-edit";

	override private function initialize():Void 
	{
        this.layout = new AnchorLayout();

		var alEdit = new AssetLoader("assets/pencil.png");
        alEdit.width = alEdit.height = 16;
        alEdit.layoutData = AnchorLayoutData.center();
        alEdit.buttonMode = true;
        alEdit.doubleClickEnabled = false;
        alEdit.addEventListener(MouseEvent.CLICK, onEditButton, false, 0, true);
        this.addChild(alEdit);

		super.initialize();
	}

    private function onEditButton(event:MouseEvent):Void 
    {
        this.dispatchEvent(new Event(EVENT_EDIT));
    }
}
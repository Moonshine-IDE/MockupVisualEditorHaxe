package view.renderers;

import view.dominoFormBuilder.vo.DominoFormFieldVO;
import feathers.core.InvalidationFlag;
import feathers.layout.AnchorLayoutData;
import feathers.layout.AnchorLayout;
import feathers.controls.AssetLoader;
import feathers.controls.dataRenderers.LayoutGroupItemRenderer;

class FieldIncludeInGridItemRenderer extends LayoutGroupItemRenderer 
{
    private var alEye:AssetLoader;

	override private function initialize():Void 
	{
        this.layout = new AnchorLayout();

		this.alEye = new AssetLoader("assets/eye.png");
        this.alEye.width = this.alEye.height = 16;
        this.alEye.layoutData = AnchorLayoutData.center();
        this.addChild(alEye);

		super.initialize();
	}

    override private function update():Void 
    {
        var dataInvalid = this.isInvalid(InvalidationFlag.DATA);
        if (dataInvalid) 
        {
            this.alEye.visible = this.alEye.includeInLayout = cast(this.data, DominoFormFieldVO).isIncludeInView;
        }

        super.update();
    }
}
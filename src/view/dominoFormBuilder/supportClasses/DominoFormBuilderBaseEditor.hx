package view.dominoFormBuilder.supportClasses;

import feathers.layout.VerticalLayout;
import feathers.controls.LayoutGroup;

class DominoFormBuilderBaseEditor extends LayoutGroup 
{
    public function new()
    {
        super();
     }

    override private function initialize():Void 
    {
        this.layout = new VerticalLayout();

        super.initialize();
    }
}
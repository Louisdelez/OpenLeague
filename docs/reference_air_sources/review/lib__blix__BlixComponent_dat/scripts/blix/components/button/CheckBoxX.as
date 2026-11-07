package blix.components.button
{
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.layout.LayoutContainer;
   import blix.layout.algorithms.HorizontalLayout;
   import blix.layout.algorithms.ILayoutAlgorithm;
   import blix.layout.data.SizeLayoutData;
   import blix.layout.vo.SizeConstraints;
   import blix.layout.vo.VerticalAlign;
   import flash.display.InteractiveObject;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextFieldAutoSize;
   
   public class CheckBoxX extends LabelButtonX
   {
      
      public var checkPart:StatefulView;
      
      protected var _layout:LayoutContainer;
      
      public function CheckBoxX(param1:IContext)
      {
         super(param1);
         toggleOnClick = true;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._layout = new LayoutContainer(this);
         this._layout.getLayoutInvalidated().add(invalidateLayout);
         this.checkPart = new StatefulView(this);
         setTimelineChildByName("checkPart",this.checkPart);
         this._layout.addElement(this.checkPart);
         textField.setAutoSize(TextFieldAutoSize.LEFT);
         var _loc1_:SizeLayoutData = new SizeLayoutData();
         _loc1_.setWidthPercent(1);
         this._layout.addElement(textField,_loc1_);
         var _loc2_:HorizontalLayout = new HorizontalLayout();
         _loc2_.setVerticalAlign(VerticalAlign.MIDDLE);
         this.setLayoutAlgorithm(_loc2_);
      }
      
      public function getLayoutAlgorithm() : ILayoutAlgorithm
      {
         return this._layout.getLayoutAlgorithm();
      }
      
      public function setLayoutAlgorithm(param1:ILayoutAlgorithm) : void
      {
         this._layout.setLayoutAlgorithm(param1);
      }
      
      override public function setCurrentState(param1:String) : void
      {
         super.setCurrentState(param1);
         this.checkPart.setCurrentState(param1);
      }
      
      override public function updateSizeConstraints(param1:Number, param2:Number) : SizeConstraints
      {
         return this._layout.updateSizeConstraints(param1,param2);
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Point = this._layout.setExplicitSize(param1,param2);
         var _loc4_:InteractiveObject = assetProxy.hitArea;
         if(Boolean(_loc4_))
         {
            _loc4_.width = _loc3_.x;
            _loc4_.height = _loc3_.y;
         }
         return new Rectangle(0,0,_loc3_.x,_loc3_.y);
      }
   }
}


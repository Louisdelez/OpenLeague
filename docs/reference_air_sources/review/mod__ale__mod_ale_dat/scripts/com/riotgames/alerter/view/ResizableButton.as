package com.riotgames.alerter.view
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.button.LabelButtonX;
   import blix.context.IContext;
   import blix.view.behaviors.ScalingTransformBehavior;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextFieldAutoSize;
   
   public class ResizableButton extends LabelButtonX
   {
      
      private var button:SpriteProxy;
      
      public function ResizableButton(param1:IContext)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         textField.getLayoutInvalidated().add(invalidateLayout);
         textField.setAutoSize(TextFieldAutoSize.LEFT);
         this.button = new SpriteProxy(this);
         this.button.getLayoutInvalidated().add(invalidateLayout);
         this.button.setTransformBehavior(new ScalingTransformBehavior());
         setTimelineChildByName("button",this.button);
      }
      
      override public function setCurrentState(param1:String) : void
      {
         super.setCurrentState(param1);
         invalidateLayout();
         validate();
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Point = textField.setExplicitSize(NaN,NaN);
         var _loc4_:Point = this.button.setExplicitSize(Math.max(96,_loc3_.x + 8),NaN);
         textField.setExplicitPosition(_loc4_.x - _loc3_.x >> 1,NaN);
         if(_hitArea)
         {
            _hitArea.setExplicitSize(_loc4_.x,_loc4_.y);
         }
         return super.updateLayout(param1,param2);
      }
   }
}


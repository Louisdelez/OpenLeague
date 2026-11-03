package blix.components.tooltip
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.renderer.IDataRenderer;
   import blix.components.text.Text;
   import blix.context.Context;
   import blix.model.ITextModel;
   import blix.view.behaviors.ScalingTransformBehavior;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextFieldAutoSize;
   
   public class ToolTip extends SpriteProxy implements IDataRenderer
   {
      
      private var background:SpriteProxy;
      
      private var text:Text;
      
      private var _data:*;
      
      public function ToolTip(param1:Context)
      {
         super(param1);
         setMouseEnabled(false);
         setMouseChildren(false);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.background = new SpriteProxy(this);
         this.background.setTransformBehavior(new ScalingTransformBehavior());
         setTimelineChildByName("background",this.background);
         this.text = new Text(this);
         this.text.setAutoSize(TextFieldAutoSize.LEFT);
         setTimelineChildByName("textField",this.text);
      }
      
      public function getData() : *
      {
         return this._data;
      }
      
      public function setData(param1:*) : void
      {
         this._data = param1;
         if(param1 is ITextModel)
         {
            this.text.setTextModel(param1);
         }
         else if(param1 is String)
         {
            this.text.setText(param1);
         }
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Point = this.text.setExplicitSize(param1,param2);
         this.background.setExplicitSize(_loc3_.x + this.text.getX() * 2,_loc3_.y + this.text.getY() * 2);
         return getAsset().getBounds(null);
      }
   }
}


package com.riotgames.pvpnet.tips.views
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.renderer.IDataRenderer;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.view.behaviors.ScalingTransformBehavior;
   import flash.geom.Rectangle;
   import flash.text.TextFieldAutoSize;
   
   public class DefaultToolTipView extends StatefulView implements IDataRenderer
   {
      
      private var _data:String;
      
      private var _background:SpriteProxy;
      
      private var _tipText:TextFieldProxy;
      
      public function DefaultToolTipView(param1:IContext)
      {
         super(param1);
         setLinkage("tips.DefaultToolTipAsset");
         setMouseEnabled(false);
         setMouseChildren(false);
      }
      
      public function getData() : *
      {
         return this._data;
      }
      
      public function setData(param1:*) : void
      {
         if(this._data != param1)
         {
            this._data = param1;
            this._tipText.setHtmlText(param1);
            this.invalidateLayout();
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._background = new SpriteProxy(this);
         var _loc1_:ScalingTransformBehavior = new ScalingTransformBehavior();
         this._background.setTransformBehavior(_loc1_);
         this._background.setMouseEnabled(false);
         this._background.setMouseChildren(false);
         setTimelineChildByName("background",this._background);
         this._tipText = new TextFieldProxy(this);
         this._tipText.setSelectable(false);
         this._tipText.setAutoSize(TextFieldAutoSize.LEFT);
         this._tipText.setMouseEnabled(false);
         setTimelineChildByName("tipText",this._tipText);
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Rectangle = super.updateLayout(param1,param2);
         this._background.setExplicitSize(this._tipText.getTextWidth() + 15,this._tipText.getHeight() + 3);
         return new Rectangle(_loc3_.x,_loc3_.y,this._background.getWidth(),this._background.getHeight());
      }
   }
}


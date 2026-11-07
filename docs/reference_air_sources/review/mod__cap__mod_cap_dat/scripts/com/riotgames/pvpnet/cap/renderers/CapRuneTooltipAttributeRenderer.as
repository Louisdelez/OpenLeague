package com.riotgames.pvpnet.cap.renderers
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.renderer.IItemRenderer;
   import blix.context.IContext;
   import com.riotgames.platform.gameclient.domain.ItemEffect;
   import com.riotgames.platform.gameclient.domain.ItemEffectHelper;
   
   public class CapRuneTooltipAttributeRenderer extends SpriteProxy implements IItemRenderer
   {
      
      protected var itemEffect:ItemEffect;
      
      protected var _data:*;
      
      protected var rendererIndex:uint;
      
      public var descriptionText:TextFieldProxy;
      
      public var valueText:TextFieldProxy;
      
      public function CapRuneTooltipAttributeRenderer(param1:IContext)
      {
         super(param1);
         setLinkage("RuneTooltipAttributeRenderer");
      }
      
      public function getData() : *
      {
         return this._data;
      }
      
      protected function getDescriptionText(param1:ItemEffect) : String
      {
         if(!param1)
         {
            return "";
         }
         return param1.displayName;
      }
      
      protected function updateChildren() : void
      {
         var _loc1_:String = this.getDescriptionText(this.itemEffect);
         this.descriptionText.setText(_loc1_);
         var _loc2_:String = this.getValueText(this.itemEffect);
         this.valueText.setText(_loc2_);
      }
      
      public function setData(param1:*) : void
      {
         this._data = param1;
         this.itemEffect = param1 as ItemEffect;
         this.updateChildren();
      }
      
      protected function getValueText(param1:ItemEffect) : String
      {
         if(!param1)
         {
            return "";
         }
         return "+ " + ItemEffectHelper.getValueFormattingForItemEffect(param1);
      }
      
      public function setIndex(param1:uint) : void
      {
         this.rendererIndex = param1;
      }
      
      override protected function createChildren() : void
      {
         this.descriptionText = new TextFieldProxy(this);
         setTimelineChildByName("descriptionText",this.descriptionText);
         this.valueText = new TextFieldProxy(this);
         setTimelineChildByName("valueText",this.valueText);
      }
      
      public function getIndex() : uint
      {
         return this.rendererIndex;
      }
   }
}


package com.riotgames.championdetails.abilities
{
   import blix.action.IAction;
   import blix.assets.proxy.SpriteProxy;
   import blix.components.button.ButtonX;
   import blix.components.loader.ImageX;
   import blix.components.text.Text;
   import blix.components.tooltip.unassignToolTip;
   import blix.context.Context;
   import com.riotgames.championdetails.IChampionDetailsContext;
   import com.riotgames.championdetails.model.ChampionAbility;
   import com.riotgames.util.logging.getLogger;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.text.TextFieldAutoSize;
   import mx.logging.ILogger;
   
   public class AbilityButton extends ButtonX
   {
      
      private var logger:ILogger = getLogger(this);
      
      private var image:ImageX;
      
      private var label:Text;
      
      private var hotkey:Text;
      
      private var _model:ChampionAbility;
      
      private var imageSizer:SpriteProxy;
      
      public function AbilityButton(param1:Context)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.image = new ImageX(this);
         this.image.getLayoutInvalidated().add(invalidateLayout);
         this.image.getErred().add(function(param1:IAction):void
         {
            logger.error(param1.getError().toString());
         });
         setTimelineChildByName("iconHolder",this.image);
         this.label = new Text(this);
         this.label.setAutoSize(TextFieldAutoSize.LEFT);
         this.label.getLayoutInvalidated().add(invalidateLayout);
         setTimelineChildByName("label",this.label);
         this.hotkey = new Text(this);
         setTimelineChildByName("hotkey",this.hotkey);
         this.imageSizer = new SpriteProxy(this);
         this.imageSizer.getLayoutInvalidated().add(invalidateLayout);
         setTimelineChildByName("imageSizer",this.imageSizer);
      }
      
      public function getModel() : ChampionAbility
      {
         return this._model;
      }
      
      public function setModel(param1:ChampionAbility) : void
      {
         if(this._model != null)
         {
            this.image.unloadAndStop();
            this.label.setText("");
            this.hotkey.setText("");
         }
         this._model = param1;
         var _loc2_:IChampionDetailsContext = getFirstContext(IChampionDetailsContext);
         if(this._model != null)
         {
            this.image.load(new URLRequest(_loc2_.getConfig().abilityAssetsPath + this._model.iconPath));
            this.label.setText(this._model.name);
            if(Boolean(this._model.hotkey) && this._model.hotkey.length > 0)
            {
               this.hotkey.setText(this._model.hotkey);
            }
            else
            {
               this.hotkey.setText("");
            }
         }
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc4_:Rectangle = null;
         if(this.imageSizer.getAsset() != null)
         {
            _loc4_ = this.imageSizer.getBounds(_asset);
            this.image.setExplicitSize(_loc4_.width,_loc4_.height);
         }
         else
         {
            this.image.setExplicitSize(NaN,NaN);
         }
         var _loc3_:Rectangle = _asset.getBounds(null);
         this.label.setY((_loc3_.height - this.label.getHeight()) / 2);
         return _loc3_;
      }
      
      override public function destroy() : void
      {
         super.destroy();
         unassignToolTip(this);
      }
   }
}


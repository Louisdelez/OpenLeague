package com.riotgames.pvpnet.runes.tooltip
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.renderer.IDataRenderer;
   import blix.context.Context;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.platform.gameclient.domain.ItemEffect;
   import com.riotgames.platform.gameclient.domain.Rune;
   import com.riotgames.platform.gameclient.domain.RuneType;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import flash.text.TextFieldAutoSize;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   public class RuneToolTip extends SpriteProxy implements IDataRenderer
   {
      
      private var _model:Rune;
      
      private var tierTextField:TextFieldProxy;
      
      private var titleTextField:TextFieldProxy;
      
      private var descriptionTextField:TextFieldProxy;
      
      private var primaryTextField:TextFieldProxy;
      
      private var background:SpriteProxy;
      
      public function RuneToolTip(param1:Context, param2:Sprite = null)
      {
         super(param1,param2);
         setMouseEnabled(false);
         setMouseChildren(false);
         setLinkage("RuneToolTipAsset");
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.background = new SpriteProxy(this);
         this.background.setTransformBehavior(new ScalingTransformBehavior());
         setTimelineChildByName("background",this.background);
         this.tierTextField = new TextFieldProxy(this);
         setTimelineChildByName("tierTextField",this.tierTextField);
         this.titleTextField = new TextFieldProxy(this);
         this.titleTextField.getLayoutInvalidated().add(invalidateLayout);
         this.titleTextField.setAutoSize(TextFieldAutoSize.CENTER);
         setTimelineChildByName("titleTextField",this.titleTextField);
         this.descriptionTextField = new TextFieldProxy(this);
         this.descriptionTextField.getLayoutInvalidated().add(invalidateLayout);
         this.descriptionTextField.setAutoSize(TextFieldAutoSize.CENTER);
         setTimelineChildByName("descriptionTextField",this.descriptionTextField);
         this.primaryTextField = new TextFieldProxy(this);
         setTimelineChildByName("primaryTextField",this.primaryTextField);
      }
      
      public function getData() : *
      {
         return this._model;
      }
      
      public function setData(param1:*) : void
      {
         var _loc2_:IResourceManager = null;
         this._model = param1 as Rune;
         if(this._model)
         {
            _loc2_ = ResourceManager.getInstance();
            this.tierTextField.setText(_loc2_.getString("resources","runebook_tooltip_tier",[this._model.tier]));
            this.titleTextField.setText(this._model.displayName);
            this.descriptionTextField.setText(this._model.displayDescription);
            if(!this.isQuintessence(this._model))
            {
               this.primaryTextField.setText(this.getPrimaryText(this._model));
               this.primaryTextField.setVisible(true);
            }
            else
            {
               this.primaryTextField.setText("");
               this.primaryTextField.setVisible(false);
            }
            this.primaryTextField.setTextColor(this.getRuneTypeColor(this._model.runeType));
            this.tierTextField.setTextColor(this.getTitleColor(this._model));
            this.titleTextField.setTextColor(this.getRuneTypeColor(this._model.runeType));
         }
      }
      
      private function getRuneTypeColor(param1:RuneType) : uint
      {
         if(param1 == null)
         {
            return 14483456;
         }
         return param1.getColorValue();
      }
      
      private function getTitleColor(param1:Rune) : uint
      {
         var _loc2_:uint = 0;
         switch(param1.tier)
         {
            case 1:
               _loc2_ = 12303291;
               break;
            case 2:
               _loc2_ = 56576;
               break;
            case 3:
               _loc2_ = 16740096;
         }
         return _loc2_;
      }
      
      private function getPrimaryText(param1:Rune) : String
      {
         var _loc2_:String = "";
         if(this.isPrimary(param1))
         {
            _loc2_ = ResourceManager.getInstance().getString("resources","rune_tooltip_primary");
            if(!_loc2_)
            {
               _loc2_ = "**Primary";
            }
         }
         else
         {
            _loc2_ = ResourceManager.getInstance().getString("resources","rune_tooltip_secondary");
            if(!_loc2_)
            {
               _loc2_ = "**Secondary";
            }
         }
         return _loc2_;
      }
      
      private function isQuintessence(param1:Rune) : Boolean
      {
         if(param1.runeType == null)
         {
            return false;
         }
         return param1.runeType.runeTypeId == RuneType.BLACK_RUNE;
      }
      
      private function isPrimary(param1:Rune) : Boolean
      {
         if(param1.runeType == null || param1.itemEffects == null)
         {
            return false;
         }
         var _loc2_:ItemEffect = param1.itemEffects[0] as ItemEffect;
         return _loc2_.effectType == param1.runeType.runeTypeId;
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this.descriptionTextField.setExplicitPosition(NaN,this.titleTextField.getY() + this.titleTextField.getHeight());
         this.background.setExplicitSize(NaN,this.titleTextField.getHeight() + this.descriptionTextField.getHeight() + this.tierTextField.getHeight() + 15);
         return getAsset().getBounds(null);
      }
   }
}


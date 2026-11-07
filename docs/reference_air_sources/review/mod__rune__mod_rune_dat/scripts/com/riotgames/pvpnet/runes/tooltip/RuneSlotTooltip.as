package com.riotgames.pvpnet.runes.tooltip
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.renderer.IDataRenderer;
   import blix.components.tooltip.IToolTipManager;
   import blix.context.IContext;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.platform.gameclient.domain.RuneSlot;
   import com.riotgames.platform.gameclient.domain.RuneType;
   import com.riotgames.pvpnet.runes.viewcontroller.RunesViewController;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import flash.text.TextFieldAutoSize;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   public class RuneSlotTooltip extends SpriteProxy implements IDataRenderer
   {
      
      private var _slot:RuneSlot;
      
      private var toolTipManager:IToolTipManager;
      
      private var runesViewController:RunesViewController;
      
      private var lockedTextField:TextFieldProxy;
      
      private var typeTextField:TextFieldProxy;
      
      private var descriptionTextField:TextFieldProxy;
      
      private var runeInfoTextField:TextFieldProxy;
      
      private var background:SpriteProxy;
      
      public function RuneSlotTooltip(param1:IContext, param2:Sprite = null)
      {
         super(param1,param2);
         setMouseEnabled(false);
         setMouseChildren(false);
         setLinkage("RuneSlotToolTipAsset");
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         this.runesViewController = getDependency(RunesViewController);
         this.toolTipManager = getDependency(IToolTipManager);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.background = new SpriteProxy(this);
         this.background.setTransformBehavior(new ScalingTransformBehavior());
         setTimelineChildByName("background",this.background);
         this.typeTextField = new TextFieldProxy(this);
         setTimelineChildByName("typeTextField",this.typeTextField);
         this.descriptionTextField = new TextFieldProxy(this);
         this.descriptionTextField.setAutoSize(TextFieldAutoSize.LEFT);
         this.descriptionTextField.getLayoutInvalidated().add(invalidateLayout);
         setTimelineChildByName("descriptionTextField",this.descriptionTextField);
         this.runeInfoTextField = new TextFieldProxy(this);
         this.runeInfoTextField.setAutoSize(TextFieldAutoSize.LEFT);
         this.runeInfoTextField.getLayoutInvalidated().add(invalidateLayout);
         setTimelineChildByName("runeInfoTextField",this.runeInfoTextField);
         this.lockedTextField = new TextFieldProxy(this);
         setTimelineChildByName("lockedTextField",this.lockedTextField);
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this.runeInfoTextField.setExplicitPosition(NaN,this.descriptionTextField.getY() + this.descriptionTextField.getHeight());
         var _loc3_:Number = NaN;
         if(this.runeInfoTextField.getIncludeInLayout())
         {
            _loc3_ = this.runeInfoTextField.getHeight() + this.descriptionTextField.getHeight() + this.lockedTextField.getHeight() + 12;
         }
         else
         {
            _loc3_ = this.descriptionTextField.getHeight() + this.lockedTextField.getHeight() + 7;
         }
         this.background.setExplicitSize(NaN,_loc3_);
         return super.updateLayout(NaN,_loc3_);
      }
      
      public function getData() : *
      {
         return this._slot;
      }
      
      public function setData(param1:*) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:String = null;
         this._slot = param1 as RuneSlot;
         if(this._slot != null)
         {
            _loc2_ = this._slot.minLevel > this.runesViewController.getSummonerLevel();
            _loc3_ = this.getTypeText();
            this.lockedTextField.setTextColor(this._slot.runeType.getColorValue());
            this.lockedTextField.setText(this.getLockedText(_loc2_));
            this.typeTextField.setTextColor(this._slot.runeType.getColorValue());
            this.typeTextField.setText(this.getTypeText());
            this.descriptionTextField.setText(this.getDescriptionText(_loc3_,_loc2_));
            this.runeInfoTextField.setIncludeInLayout(!_loc2_);
            this.runeInfoTextField.setVisible(!_loc2_);
            this.runeInfoTextField.setText(this.getRuneInfoText());
            invalidateLayout();
         }
      }
      
      private function getLockedText(param1:Boolean) : String
      {
         var _loc2_:IResourceManager = ResourceManager.getInstance();
         var _loc3_:String = param1 ? _loc2_.getString("resources","runeslot_tooltip_locked") : _loc2_.getString("resources","runeslot_tooltip_unlocked");
         if(_loc3_ == null)
         {
            _loc3_ = param1 ? "**Locked" : "**Unlocked";
         }
         return _loc3_;
      }
      
      private function getTypeText() : String
      {
         var _loc1_:String = this._slot.runeType.localizeNameSingular();
         if(_loc1_ == null)
         {
            _loc1_ == "**Mark";
         }
         return _loc1_;
      }
      
      private function getRuneInfoText() : String
      {
         var _loc1_:String = null;
         var _loc2_:IResourceManager = ResourceManager.getInstance();
         switch(this._slot.runeType.runeTypeId)
         {
            case RuneType.BLUE_RUNE:
               _loc1_ = _loc2_.getString("resources","runeslot_tooltip_blue_explanation");
               break;
            case RuneType.RED_RUNE:
               _loc1_ = _loc2_.getString("resources","runeslot_tooltip_red_explanation");
               break;
            case RuneType.YELLOW_RUNE:
               _loc1_ = _loc2_.getString("resources","runeslot_tooltip_yellow_explanation");
               break;
            case RuneType.BLACK_RUNE:
               _loc1_ = _loc2_.getString("resources","runeslot_tooltip_black_explanation");
         }
         if(_loc1_ == null)
         {
            _loc1_ = "**Mark Runes specialize in Physical Damage";
         }
         return _loc1_;
      }
      
      private function getDescriptionText(param1:String, param2:Boolean) : String
      {
         var _loc3_:String = null;
         var _loc4_:IResourceManager = ResourceManager.getInstance();
         if(param2)
         {
            _loc3_ = _loc4_.getString("resources","runeslot_tooltip_locked_explanation",[param1,this._slot.minLevel]);
            if(_loc3_ == null)
            {
               _loc3_ = "**" + param1 + " Slot is currently Locked until Summoner Level: " + this._slot.minLevel;
            }
         }
         else
         {
            _loc3_ = _loc4_.getString("resources","runeslot_tooltip_unlocked_explanation",[param1]);
            if(_loc3_ == null)
            {
               _loc3_ = "**Drag and Drop a " + param1 + " Rune from your inventory here in order to gain its bonuses";
            }
         }
         return _loc3_;
      }
   }
}


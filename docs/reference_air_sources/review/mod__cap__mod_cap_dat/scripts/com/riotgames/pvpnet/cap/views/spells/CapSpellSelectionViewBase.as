package com.riotgames.pvpnet.cap.views.spells
{
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.components.button.ButtonX;
   import blix.context.IContext;
   import blix.layout.data.CanvasLayoutData;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import blix.view.ILayoutData;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.common.resource.RiotResourceManager;
   import com.riotgames.platform.gameclient.domain.Spell;
   import com.riotgames.pvpnet.cap.model.IPlayerSpellModel;
   import com.riotgames.pvpnet.cap.model.ISpellModel;
   import com.riotgames.rust.popup.PopUpManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class CapSpellSelectionViewBase extends ButtonX
   {
      
      protected var _spellModel:ISpellModel;
      
      protected var _playerSpellModel:IPlayerSpellModel;
      
      protected var _spellIcon:DisplayObjectProxy;
      
      protected var _spellChangedEvent:String = "defaultSpellChangeEvent";
      
      protected var _iconSizer:SpriteProxy;
      
      protected var _spellSelected:Signal = new Signal();
      
      protected var _spellSelectPopup:CapSpellSelectPopup;
      
      protected var _spellIndex:int;
      
      protected var _closeClicked:Signal = new Signal();
      
      public function CapSpellSelectionViewBase(param1:IContext, param2:int, param3:ISpellModel = null, param4:IPlayerSpellModel = null)
      {
         super(param1);
         if(param2 < 1 || param2 > 2)
         {
            throw new ArgumentError("Spell Selection View can only handle spell index where 1 <= index <= 2.");
         }
         this.setSpellIndex(param2);
         this.setSpellModel(param3);
         this.setPlayerSpellModel(param4);
         setButtonMode(true);
      }
      
      public function getCloseClicked() : ISignal
      {
         return this._closeClicked;
      }
      
      protected function hidePopup() : void
      {
         if(this._spellSelectPopup)
         {
            this._spellSelectPopup.getSpellSelected().remove(this.spellSelectedHandler);
            this._spellSelectPopup.getCloseClicked().remove(this.handleClose);
            this._spellSelectPopup.getClickOutside().remove(this.hidePopup);
            this._spellSelectPopup.destroy();
            this._spellSelectPopup = null;
         }
      }
      
      protected function setSpellIndex(param1:int) : void
      {
         this._spellIndex = param1;
      }
      
      protected function createPopup() : CapSpellSelectPopup
      {
         var _loc1_:CapSpellSelectPopup = new CapSpellSelectPopup(this,this.getSpell(),this._spellModel.allSpells);
         var _loc2_:String = RiotResourceManager.getInstance().getResourcesString("championSelection_spell_selection_title",[this._spellIndex]);
         _loc1_.setTitle(_loc2_);
         return _loc1_;
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this._spellIcon.setExplicitSize(this._iconSizer.getWidth(),this._iconSizer.getHeight());
         this._spellIcon.setExplicitPosition(this._iconSizer.getX(),this._iconSizer.getY());
         return super.updateLayout(param1,param2);
      }
      
      protected function updateSelectedSpellRenderer(param1:Event = null) : void
      {
         var _loc2_:Bitmap = null;
         if(this.getSpell() != null)
         {
            _loc2_ = ImagePackLookup.instance.getSpellBitmap(this.getSpell());
            _loc2_.smoothing = true;
            this._spellIcon.setAsset(_loc2_);
         }
         else
         {
            this._spellIcon.setAsset(null);
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._iconSizer = new SpriteProxy(this);
         setTimelineChildByName("sizer",this._iconSizer);
         this._spellIcon = new DisplayObjectProxy(this);
         this._spellIcon.setTransformBehavior(new ScalingTransformBehavior());
         addChild(this._spellIcon);
         addEventListener(MouseEvent.CLICK,this.mouseClickHandler,false,0,true);
      }
      
      public function setSpellModel(param1:ISpellModel) : void
      {
         this._spellModel = param1;
      }
      
      public function setPlayerSpellModel(param1:IPlayerSpellModel) : void
      {
         if(this._playerSpellModel != param1)
         {
            if(this._playerSpellModel != null)
            {
               this._playerSpellModel.spell1Changed.remove(this.updateSelectedSpellRenderer);
               this._playerSpellModel.spell2Changed.remove(this.updateSelectedSpellRenderer);
            }
            this._playerSpellModel = param1;
            if(this._playerSpellModel != null)
            {
               this._playerSpellModel.spell1Changed.add(this.updateSelectedSpellRenderer);
               this._playerSpellModel.spell2Changed.add(this.updateSelectedSpellRenderer);
            }
            this.updateSelectedSpellRenderer();
         }
      }
      
      public function getSpellSelected() : ISignal
      {
         return this._spellSelected;
      }
      
      protected function showPopup(param1:CapSpellSelectPopup, param2:ILayoutData = null) : void
      {
         var _loc3_:Rectangle = null;
         var _loc4_:CanvasLayoutData = null;
         if(param2 == null)
         {
            _loc3_ = getBounds(getStage());
            _loc4_ = new CanvasLayoutData();
            _loc4_.setX(_loc3_.x);
            _loc4_.setY(_loc3_.y);
            param2 = _loc4_;
         }
         this._spellSelectPopup = param1;
         this._spellSelectPopup.getSpellSelected().add(this.spellSelectedHandler);
         this._spellSelectPopup.getCloseClicked().add(this.handleClose);
         this._spellSelectPopup.getClickOutside().add(this.hidePopup);
         PopUpManager.addPopUp(param1,param2,true);
      }
      
      protected function handleClose() : void
      {
         this._closeClicked.dispatch();
         this.hidePopup();
      }
      
      protected function mouseClickHandler(param1:MouseEvent) : void
      {
         this.showPopup(this.createPopup());
      }
      
      protected function getSpell() : Spell
      {
         if(this._playerSpellModel == null)
         {
            return null;
         }
         return this._playerSpellModel["spell" + this._spellIndex.toString()] as Spell;
      }
      
      override public function destroy() : void
      {
         super.destroy();
         removeEventListener(MouseEvent.CLICK,this.mouseClickHandler);
         this.hidePopup();
      }
      
      protected function spellSelectedHandler(param1:Spell) : void
      {
         this.hidePopup();
         this._spellSelected.dispatch(param1);
         addEventListener(MouseEvent.CLICK,this.mouseClickHandler,false,0,true);
      }
   }
}


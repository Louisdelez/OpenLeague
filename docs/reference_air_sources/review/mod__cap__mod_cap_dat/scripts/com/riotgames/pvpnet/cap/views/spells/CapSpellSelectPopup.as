package com.riotgames.pvpnet.cap.views.spells
{
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.components.tooltip.unassignToolTip;
   import blix.context.IContext;
   import blix.layout.LayoutContainer;
   import blix.layout.algorithms.FlowLayout;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.gameclient.domain.Spell;
   import com.riotgames.pvpnet.model.SpellSelection;
   import com.riotgames.pvpnet.tips.TipsProviderProxy;
   import com.riotgames.pvpnet.tips.config.RectPosition;
   import com.riotgames.pvpnet.tips.config.ToolTipConfig;
   import com.riotgames.rust.popup.PopUpManager;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.ui.Keyboard;
   import mx.collections.ArrayCollection;
   import mx.collections.Sort;
   import mx.collections.SortField;
   
   public class CapSpellSelectPopup extends SpriteProxy
   {
      
      private var _spellLayoutContainer:LayoutContainer;
      
      private const SPELL_TOOLTIP_OFFSET_X:int = -13;
      
      private const SPELL_TOOLTIP_OFFSET_Y:int = 6;
      
      private var _closeBtn:ButtonX;
      
      private var _spellSelected:Signal = new Signal();
      
      private var _spellList:SpriteProxy;
      
      private var _spell:Spell;
      
      private var _spellListSizer:SpriteProxy;
      
      private var _closeClicked:Signal = new Signal();
      
      private var _currentSpellSizer:SpriteProxy;
      
      private var _titleTextField:TextFieldProxy;
      
      private var _frame:SpriteProxy;
      
      private var _spellRenderers:Vector.<CapSpellSelectIconRenderer> = new Vector.<CapSpellSelectIconRenderer>();
      
      private var _spellTooltipConfig:ToolTipConfig;
      
      private var _clickOutside:Signal = new Signal();
      
      private var _currentSpellIcon:DisplayObjectProxy;
      
      public function CapSpellSelectPopup(param1:IContext, param2:Spell, param3:ArrayCollection)
      {
         super(param1);
         this._spellTooltipConfig = new ToolTipConfig();
         this._spellTooltipConfig.showDelay = 0;
         this._spellTooltipConfig.toolTipPosition = new RectPosition(RectPosition.LEFT_MIDDLE,RectPosition.RIGHT_MIDDLE);
         this._spellTooltipConfig.gap = new Point(this.SPELL_TOOLTIP_OFFSET_X,this.SPELL_TOOLTIP_OFFSET_Y);
         this._spellTooltipConfig.cacheView = false;
         this.setCurrentSpell(param2);
         this.setAllSpells(param3);
         setLinkage("SpellSelectPopup");
      }
      
      override public function destroy() : void
      {
         var _loc1_:CapSpellSelectIconRenderer = null;
         if(getStage())
         {
            getStage().removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
            getStage().removeEventListener(MouseEvent.MOUSE_DOWN,this.onStageMouseClick);
         }
         for each(_loc1_ in this._spellRenderers)
         {
            unassignToolTip(_loc1_);
            _loc1_.removeEventListener(MouseEvent.CLICK,this.spellSelectedHandler);
            _loc1_.destroy();
         }
         this._spellRenderers.length = 0;
         PopUpManager.removePopUp(this);
         super.destroy();
      }
      
      private function onKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ESCAPE)
         {
            this._clickOutside.dispatch();
         }
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         getStage().addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown,false,0,true);
         getStage().addEventListener(MouseEvent.MOUSE_DOWN,this.onStageMouseClick,false,0,true);
      }
      
      private function setAllSpells(param1:ArrayCollection) : void
      {
         var _loc2_:SpellSelection = null;
         var _loc6_:CapSpellSelectIconRenderer = null;
         var _loc3_:SortField = new SortField();
         var _loc4_:Sort = new Sort();
         _loc3_.name = "minLevel";
         _loc3_.numeric = true;
         _loc4_.fields = [_loc3_];
         param1.sort = _loc4_;
         param1.refresh();
         var _loc5_:Vector.<SpellSelection> = new Vector.<SpellSelection>();
         for each(_loc2_ in param1)
         {
            _loc5_[_loc5_.length] = _loc2_;
         }
         for each(_loc2_ in _loc5_)
         {
            _loc6_ = new CapSpellSelectIconRenderer(this,_loc2_.spell);
            _loc6_.addEventListener(MouseEvent.CLICK,this.spellSelectedHandler);
            this._spellList.addChild(_loc6_);
            this._spellLayoutContainer.addElement(_loc6_);
            TipsProviderProxy.instance.assignCustomToolTip(_loc6_,_loc2_.spell,CapSpellTooltipView,this._spellTooltipConfig);
            this._spellRenderers.push(_loc6_);
         }
      }
      
      public function getCloseClicked() : ISignal
      {
         return this._closeClicked;
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this._spellLayoutContainer.setExplicitSize(this._spellListSizer.getWidth(),this._spellListSizer.getHeight());
         this._spellLayoutContainer.setExplicitPosition(this._spellListSizer.getX(),this._spellListSizer.getY());
         this._currentSpellIcon.setExplicitSize(this._currentSpellSizer.getWidth(),this._currentSpellSizer.getHeight());
         this._currentSpellIcon.setExplicitPosition(this._currentSpellSizer.getX(),this._currentSpellSizer.getY());
         return new Rectangle(0,0,this._frame.getWidth(),this._frame.getHeight());
      }
      
      public function setTitle(param1:String) : void
      {
         this._titleTextField.setText(param1);
      }
      
      private function close(param1:Event = null) : void
      {
         this._closeClicked.dispatch();
      }
      
      override protected function createChildren() : void
      {
         this._frame = new SpriteProxy(this);
         setTimelineChildByName("frame",this._frame);
         this._titleTextField = new TextFieldProxy(this);
         setTimelineChildByName("spellSelectLabel",this._titleTextField);
         this._spellList = new SpriteProxy(this);
         setTimelineChildByName("spellListContainer",this._spellList);
         this._spellListSizer = new SpriteProxy(this);
         setTimelineChildByName("spellListSizer",this._spellListSizer);
         this._spellLayoutContainer = new LayoutContainer(this);
         this._spellLayoutContainer.setLayoutAlgorithm(new FlowLayout());
         this._currentSpellSizer = new SpriteProxy(this);
         setTimelineChildByName("selectedSizerContainer",this._currentSpellSizer);
         this._closeBtn = new ButtonX(this);
         setTimelineChildByName("close",this._closeBtn);
         this._closeBtn.addEventListener(MouseEvent.CLICK,this.close);
         this._currentSpellIcon = new DisplayObjectProxy(this);
         this._currentSpellIcon.setTransformBehavior(new ScalingTransformBehavior());
         addChild(this._currentSpellIcon);
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      private function onStageMouseClick(param1:MouseEvent) : void
      {
         var _loc2_:DisplayObject = param1.target as DisplayObject;
         if(Boolean(_loc2_) && Boolean(getSpriteAsset().contains(_loc2_)))
         {
            return;
         }
         this._clickOutside.dispatch();
      }
      
      public function getSpellSelected() : ISignal
      {
         return this._spellSelected;
      }
      
      private function setCurrentSpell(param1:Spell) : void
      {
         this._spell = param1;
         if(this._spell != null)
         {
            this._currentSpellIcon.setAsset(ImagePackLookup.instance.getSpellBitmap(this._spell));
         }
         else
         {
            this._currentSpellIcon.setAsset(null);
         }
      }
      
      public function getClickOutside() : ISignal
      {
         return this._clickOutside;
      }
      
      private function spellSelectedHandler(param1:MouseEvent = null) : void
      {
         var _loc2_:CapSpellSelectIconRenderer = param1 != null ? param1.target as CapSpellSelectIconRenderer : null;
         var _loc3_:Spell = _loc2_ ? _loc2_.getSpell() : null;
         this._spellSelected.dispatch(_loc3_);
      }
   }
}


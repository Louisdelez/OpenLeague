package com.riotgames.pvpnet.runes.views.common
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.components.renderer.IItemRenderer;
   import blix.components.text.Text;
   import blix.components.tooltip.IToolTipManager;
   import blix.components.tooltip.ToolTipHandler;
   import blix.context.IContext;
   import com.riotgames.platform.gameclient.domain.ItemEffect;
   import com.riotgames.platform.gameclient.domain.ItemEffectHelper;
   import com.riotgames.platform.gameclient.domain.Rune;
   import com.riotgames.platform.gameclient.domain.RuneSlot;
   import com.riotgames.platform.gameclient.domain.SummonerRune;
   import com.riotgames.pvpnet.runes.tooltip.RuneToolTip;
   import com.riotgames.pvpnet.runes.viewcontroller.RunesTransportationController;
   import com.riotgames.pvpnet.runes.viewcontroller.RunesViewController;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.tracking.trackers.runes.IRunesTracker;
   import com.riotgames.rust.drag.DragBehavior;
   import flash.desktop.Clipboard;
   import flash.desktop.NativeDragManager;
   import flash.desktop.NativeDragOptions;
   import flash.display.BitmapData;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextFieldAutoSize;
   import mx.collections.ArrayCollection;
   
   public class RuneInventoryRenderer extends ButtonX implements IItemRenderer
   {
      
      private var _summonerRune:SummonerRune;
      
      private var _index:uint;
      
      private var sizer:SpriteProxy;
      
      private var runeDescription:Text;
      
      private var runeCount:TextFieldProxy;
      
      private var runeImageRenderer:RuneImageRenderer;
      
      private var runesTransportationController:RunesTransportationController;
      
      private var toolTipManager:IToolTipManager;
      
      private var runesViewController:RunesViewController;
      
      private var _runesTracker:IRunesTracker;
      
      private var dragBehavior:DragBehavior;
      
      private var rendererSizer:SpriteProxy;
      
      public function RuneInventoryRenderer(param1:IContext)
      {
         super(param1);
         setLinkage("RuneInventoryRenderer");
         setDoubleClickEnabled(true);
         addEventListener(MouseEvent.DOUBLE_CLICK,this.mouseDoubleClickHandler);
         addEventListener(MouseEvent.RIGHT_CLICK,this.mouseRightClickHandler);
         addEventListener(MouseEvent.MOUSE_OVER,this.mouseOverHandler);
         addEventListener(MouseEvent.MOUSE_OUT,this.mouseOutHandler);
         this.watchControllers();
         this.dragBehavior = new DragBehavior(this);
         this.dragBehavior.getDragBegin().add(this.dragBeginHandler);
      }
      
      private function dragBeginHandler(param1:DragBehavior, param2:Boolean, param3:Boolean, param4:Boolean) : void
      {
         var _loc5_:Rectangle = null;
         var _loc6_:BitmapData = null;
         var _loc7_:Matrix = null;
         var _loc8_:Clipboard = null;
         var _loc9_:NativeDragOptions = null;
         if(this._summonerRune)
         {
            _loc5_ = this.runeImageRenderer.getScaledBounds();
            if(_loc5_.isEmpty() || this.runeImageRenderer.getImage().getAsset() == null)
            {
               return;
            }
            _loc6_ = new BitmapData(_loc5_.width,_loc5_.height,true,0);
            _loc7_ = this.runeImageRenderer.getImage().getTransformMatrix();
            _loc6_.draw(this.runeImageRenderer.getImage().getAsset(),_loc7_);
            _loc8_ = new Clipboard();
            _loc8_.setData(SummonerRune.DATA_FORMAT,this._summonerRune);
            _loc9_ = new NativeDragOptions();
            _loc9_.allowCopy = true;
            _loc9_.allowLink = false;
            _loc9_.allowMove = false;
            NativeDragManager.doDrag(getInteractiveAsset(),_loc8_,_loc6_,new Point(-_loc6_.width / 2,-_loc6_.height / 2),_loc9_);
         }
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         this.runesTransportationController = getDependency(RunesTransportationController);
         this.runesViewController = getDependency(RunesViewController);
         this.toolTipManager = getDependency(IToolTipManager);
         this._runesTracker = getDependency(IRunesTracker);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.sizer = new SpriteProxy(this);
         this.sizer.getLayoutInvalidated().add(invalidateLayout);
         setTimelineChildByName("sizer",this.sizer);
         this.runeImageRenderer = new RuneImageRenderer(this);
         setTimelineChildByName("runeImageRenderer",this.runeImageRenderer);
         this.rendererSizer = new SpriteProxy(this);
         setTimelineChildByName("rendererSizer",this.rendererSizer);
         this.runeImageRenderer.setSizer(this.rendererSizer);
         this.runeDescription = new Text(this);
         this.runeDescription.setAutoSize(TextFieldAutoSize.LEFT);
         this.runeDescription.getLayoutInvalidated().add(invalidateLayout);
         setTimelineChildByName("runeDescriptionTextField",this.runeDescription);
         this.runeCount = new TextFieldProxy(this);
         this.runeCount.setAutoSize(TextFieldAutoSize.RIGHT);
         setTimelineChildByName("runeCountTextField",this.runeCount);
      }
      
      private function mouseRightClickHandler(param1:MouseEvent) : void
      {
         if(this._summonerRune == null)
         {
            return;
         }
         this._runesTracker.incrementRunes_UserRightClickedToAdd_Count_InASession();
         this.runesTransportationController.addRuneToFirstAvailableSlot(this._summonerRune);
      }
      
      private function mouseOverHandler(param1:MouseEvent) : void
      {
         var _loc2_:RuneToolTip = null;
         var _loc3_:ToolTipHandler = null;
         if(Boolean(this._summonerRune) && Boolean(this._summonerRune.rune))
         {
            _loc2_ = new RuneToolTip(this);
            _loc3_ = new ToolTipHandler(_loc2_);
            _loc3_.showDelay = 0;
            _loc3_.hideDelay = 0;
            this.toolTipManager.assignToolTip(this,this._summonerRune.rune,_loc3_);
         }
      }
      
      private function mouseOutHandler(param1:MouseEvent) : void
      {
         this.toolTipManager.unassignToolTip(this);
      }
      
      public function setSummonerRune(param1:SummonerRune) : void
      {
         this._summonerRune = param1;
         if(Boolean(param1) && Boolean(param1.rune))
         {
            this.runeImageRenderer.setRune(param1.rune);
            this.runeDescription.setText(this.getRuneName());
         }
         this.refreshRuneCount();
      }
      
      private function getRuneName() : String
      {
         var _loc2_:String = null;
         var _loc3_:ArrayCollection = null;
         var _loc4_:ItemEffect = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc1_:SummonerRune = this._summonerRune;
         if(_loc1_.rune.itemEffects.length > 0)
         {
            _loc2_ = "";
            _loc3_ = _loc1_.rune.itemEffects;
            _loc5_ = 0;
            while(_loc5_ < _loc3_.length)
            {
               _loc4_ = _loc3_.getItemAt(_loc5_) as ItemEffect;
               _loc6_ = ItemEffectHelper.getValueFormattingForItemEffect(_loc4_);
               _loc6_ = _loc4_.value > 0 ? "+" + _loc6_ : "-" + _loc6_.substring(1);
               _loc7_ = _loc4_.displayName;
               _loc7_ = _loc7_.replace(" %","").replace("%","");
               if(ClientConfig.instance.localePrefix == "ko")
               {
                  _loc2_ += _loc7_ + " " + _loc6_ + "\n";
               }
               else
               {
                  _loc2_ += _loc6_ + " " + _loc7_ + "\n";
               }
               _loc5_++;
            }
         }
         return _loc2_;
      }
      
      private function watchControllers() : void
      {
         this.runesTransportationController.getRuneAddedToPage().add(this.runeAddedHandler);
         this.runesTransportationController.getRuneRemovedFromPage().add(this.runeRemovedHandler);
         this.runesTransportationController.getRuneAddedToCombiner().add(this.runeAddedHandler);
         this.runesTransportationController.getRuneRemovedFromCombiner().add(this.runeRemovedHandler);
         this.runesTransportationController.getRuneBookStateChanged().add(this.runeBookStateChangedHandler);
         this.runesViewController.getCurrentRuneBookPageChanged().add(this.onCurrentRuneBookPageChanged);
      }
      
      private function onCurrentRuneBookPageChanged() : void
      {
         this.refreshRuneCount();
      }
      
      private function runeBookStateChangedHandler(param1:Boolean, param2:Boolean) : void
      {
         this.refreshRuneCount();
      }
      
      private function runeAddedHandler(param1:Rune, param2:RuneSlot) : void
      {
         if(!this._summonerRune || param1.itemId != this._summonerRune.rune.itemId)
         {
            return;
         }
         this.refreshRuneCount();
      }
      
      private function runeRemovedHandler(param1:Rune, param2:RuneSlot) : void
      {
         if(!this._summonerRune || param1.itemId != this._summonerRune.rune.itemId)
         {
            return;
         }
         this.refreshRuneCount();
      }
      
      private function refreshRuneCount() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this._summonerRune != null)
         {
            _loc1_ = this.runesTransportationController.getUsedCount(this._summonerRune.rune);
            _loc2_ = this._summonerRune.quantity - _loc1_;
            this.runeCount.setText("x" + _loc2_);
            setVisible(_loc2_ > 0);
         }
         else
         {
            this.runeCount.setText("");
            setVisible(false);
         }
      }
      
      override public function destroy() : void
      {
         this.runesTransportationController.getRuneAddedToPage().remove(this.runeAddedHandler);
         this.runesTransportationController.getRuneRemovedFromPage().remove(this.runeRemovedHandler);
         this.runesTransportationController.getRuneAddedToCombiner().remove(this.runeAddedHandler);
         this.runesTransportationController.getRuneRemovedFromCombiner().remove(this.runeRemovedHandler);
         this.runesTransportationController.getRuneBookStateChanged().remove(this.runeBookStateChangedHandler);
         this.runesViewController.getCurrentRuneBookPageChanged().remove(this.onCurrentRuneBookPageChanged);
         super.destroy();
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Point = this.runeDescription.setExplicitSize(NaN,NaN);
         this.runeDescription.setExplicitPosition(NaN,this.sizer.getHeight() - _loc3_.y >> 1);
         return new Rectangle(0,0,this.sizer.getWidth(),this.sizer.getHeight());
      }
      
      override public function setData(param1:*) : void
      {
         super.setData(param1);
         this.setSummonerRune(param1 as SummonerRune);
      }
      
      public function getIndex() : uint
      {
         return this._index;
      }
      
      public function setIndex(param1:uint) : void
      {
         this._index = param1;
      }
      
      private function mouseDoubleClickHandler(param1:MouseEvent) : void
      {
         if(this._summonerRune == null)
         {
            return;
         }
         this._runesTracker.incrementRunes_UserDoubleClickedToAdd_Count_InASession();
         this.runesTransportationController.addRuneToFirstAvailableSlot(this._summonerRune);
      }
   }
}


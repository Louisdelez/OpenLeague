package com.riotgames.pvpnet.runes.views.runespage
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.loader.ImageX;
   import blix.components.timeline.StatefulView;
   import blix.components.tooltip.IToolTipManager;
   import blix.components.tooltip.ToolTipHandler;
   import blix.context.IContext;
   import com.riotgames.platform.gameclient.domain.Rune;
   import com.riotgames.platform.gameclient.domain.RuneSlot;
   import com.riotgames.platform.gameclient.domain.RuneType;
   import com.riotgames.platform.gameclient.domain.SpellBookPageDTO;
   import com.riotgames.platform.gameclient.domain.SummonerRune;
   import com.riotgames.pvpnet.runes.tooltip.RuneSlotTooltip;
   import com.riotgames.pvpnet.runes.tooltip.RuneToolTip;
   import com.riotgames.pvpnet.runes.util.RuneImageCache;
   import com.riotgames.pvpnet.runes.viewcontroller.RuneDropTarget;
   import com.riotgames.pvpnet.runes.viewcontroller.RunesTransportationController;
   import com.riotgames.pvpnet.runes.viewcontroller.RunesViewController;
   import com.riotgames.pvpnet.runes.views.common.RuneImageRenderer;
   import com.riotgames.pvpnet.tracking.trackers.runes.IRunesTracker;
   import com.riotgames.rust.drag.DragBehavior;
   import flash.desktop.Clipboard;
   import flash.desktop.NativeDragManager;
   import flash.desktop.NativeDragOptions;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.NativeDragEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   
   public class RuneSlotView extends StatefulView
   {
      
      private var index:uint;
      
      private var _runeSlot:RuneSlot;
      
      private var _rune:Rune;
      
      private var isUserInteractionChange:Boolean;
      
      private var isQuintSlot:Boolean = false;
      
      private var runeImageRenderer:RuneImageRenderer;
      
      private var quintEmptyIconHolder:ImageX;
      
      private var quintEmptyIconSizer:SpriteProxy;
      
      private var rendererSizer:SpriteProxy;
      
      private var runeTransportationController:RunesTransportationController;
      
      private var runesViewController:RunesViewController;
      
      private var toolTipManager:IToolTipManager;
      
      private var _runesTracker:IRunesTracker;
      
      private var highlightDrop:GlowFilter;
      
      private var dragBehavior:DragBehavior;
      
      public function RuneSlotView(param1:IContext, param2:uint)
      {
         this.index = param2;
         super(param1);
         addEventListener(MouseEvent.DOUBLE_CLICK,this.mouseDoubleClickHandler);
         addEventListener(MouseEvent.RIGHT_CLICK,this.mouseRightClickHandler);
         addEventListener(MouseEvent.MOUSE_OVER,this.mouseOverHandler);
         addEventListener(MouseEvent.MOUSE_OUT,this.mouseOutHandler);
         setDoubleClickEnabled(true);
         setMouseChildren(false);
         setEnabled(true);
         setButtonMode(true);
         setUseHandCursor(false);
         addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER,this.onNativeDragEnter);
         addEventListener(NativeDragEvent.NATIVE_DRAG_DROP,this.onNativeDragDrop);
         addEventListener(NativeDragEvent.NATIVE_DRAG_EXIT,this.onNativeDragExit);
         this.dragBehavior = new DragBehavior(this);
         this.dragBehavior.getDragBegin().add(this.dragBeginHandler);
      }
      
      private function onNativeDragExit(param1:NativeDragEvent) : void
      {
         this.runeTransportationController.setHighlightedDropTarget(null);
      }
      
      private function dragBeginHandler(param1:DragBehavior, param2:Boolean, param3:Boolean, param4:Boolean) : void
      {
         var _loc5_:Rectangle = null;
         var _loc6_:BitmapData = null;
         var _loc7_:Matrix = null;
         var _loc8_:Clipboard = null;
         var _loc9_:NativeDragOptions = null;
         if(Boolean(this._rune) && this.runesViewController.isLocalSummoner())
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
            _loc8_.setData(RuneSlot.DATA_FORMAT,this._runeSlot);
            _loc9_ = new NativeDragOptions();
            _loc9_.allowCopy = false;
            _loc9_.allowLink = false;
            _loc9_.allowMove = true;
            NativeDragManager.doDrag(getInteractiveAsset(),_loc8_,_loc6_,new Point(-_loc6_.width / 2,-_loc6_.height / 2),_loc9_);
         }
      }
      
      private function onNativeDragDrop(param1:NativeDragEvent) : void
      {
         var _loc2_:SummonerRune = null;
         if(this._runeSlot.minLevel > this.runesViewController.getSummonerLevel())
         {
            return;
         }
         if(param1.clipboard.hasFormat(SummonerRune.DATA_FORMAT))
         {
            _loc2_ = param1.clipboard.getData(SummonerRune.DATA_FORMAT) as SummonerRune;
            if(_loc2_)
            {
               if(!this._rune && this.checkRuneType(_loc2_))
               {
                  this._runesTracker.incrementRunes_UserDragAndDropToAddSpecificSlot_Count_InASession();
                  this.runeTransportationController.addRuneToSpecificSlot(_loc2_,this._runeSlot);
               }
               else
               {
                  this._runesTracker.incrementRunes_UserDragAndDropToAddNonSpecificSlot_Count_InASession();
                  this.runeTransportationController.addRuneToFirstAvailableSlot(_loc2_);
               }
               this._runesTracker.incrementRunes_UserDragAndDropToAddTotal_Count_InASession();
            }
         }
      }
      
      private function onNativeDragEnter(param1:NativeDragEvent) : void
      {
         var _loc2_:SummonerRune = null;
         var _loc3_:RuneSlot = null;
         if(this._runeSlot.minLevel > this.runesViewController.getSummonerLevel())
         {
            return;
         }
         if(param1.clipboard.hasFormat(SummonerRune.DATA_FORMAT))
         {
            _loc2_ = param1.clipboard.getData(SummonerRune.DATA_FORMAT) as SummonerRune;
            if(_loc2_)
            {
               if(!this._rune && this.checkRuneType(_loc2_))
               {
                  _loc3_ = this._runeSlot;
               }
               else
               {
                  _loc3_ = this.runeTransportationController.getFirstEmptySlotByRune(_loc2_.rune);
               }
               if(_loc3_)
               {
                  NativeDragManager.acceptDragDrop(getInteractiveAsset());
                  this.runeTransportationController.setHighlightedDropTarget(new RuneDropTarget(_loc2_,_loc3_));
               }
            }
         }
      }
      
      private function checkRuneType(param1:SummonerRune) : Boolean
      {
         return param1.rune.runeType.runeTypeId == this._runeSlot.runeType.runeTypeId;
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         this.runeTransportationController = getDependency(RunesTransportationController);
         this.runesViewController = getDependency(RunesViewController);
         this.toolTipManager = getDependency(IToolTipManager);
         this._runesTracker = getDependency(IRunesTracker);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.runeImageRenderer = new RuneImageRenderer(this);
         setTimelineChildByName("runeImageRenderer",this.runeImageRenderer);
         this.runeImageRenderer.setRuneEffectGlowActive(true);
         this.runeImageRenderer.setMouseoverGlowActive(true);
         this.rendererSizer = new SpriteProxy(this);
         setTimelineChildByName("rendererSizer",this.rendererSizer);
         this.runeImageRenderer.setSizer(this.rendererSizer);
         this.highlightDrop = new GlowFilter(65280,0.8,11,11,4);
         this.watchControllers();
         this.refreshState();
      }
      
      private function mouseDoubleClickHandler(param1:MouseEvent) : void
      {
         if(Boolean(this._rune) && this.runesViewController.isLocalSummoner())
         {
            this._runesTracker.incrementRunes_UserDoubleClickedToRemove_Count_InASession();
            this.runeTransportationController.removeRuneFromSlot(this._runeSlot);
         }
      }
      
      private function mouseRightClickHandler(param1:MouseEvent) : void
      {
         if(Boolean(this._rune) && this.runesViewController.isLocalSummoner())
         {
            this._runesTracker.incrementRunes_UserRightClickedToRemove_Count_InASession();
            this.runeTransportationController.removeRuneFromSlot(this._runeSlot);
         }
      }
      
      private function mouseOverHandler(param1:MouseEvent) : void
      {
         var _loc2_:ToolTipHandler = null;
         var _loc3_:RuneToolTip = null;
         var _loc4_:RuneSlotTooltip = null;
         if(this._rune)
         {
            _loc3_ = new RuneToolTip(this);
            _loc2_ = new ToolTipHandler(_loc3_);
            _loc2_.showDelay = 0;
            _loc2_.hideDelay = 0;
            this.toolTipManager.assignToolTip(this,this._rune,_loc2_);
            this.runeImageRenderer.setMouseOver(true);
         }
         else if(this._runeSlot)
         {
            _loc4_ = new RuneSlotTooltip(this);
            _loc2_ = new ToolTipHandler(_loc4_);
            _loc2_.showDelay = 0;
            _loc2_.hideDelay = 0;
            this.toolTipManager.assignToolTip(this,this._runeSlot,_loc2_);
         }
      }
      
      private function mouseOutHandler(param1:MouseEvent) : void
      {
         this.runeImageRenderer.setMouseOver(false);
         this.toolTipManager.unassignToolTip(this);
      }
      
      public function getRuneSlot() : RuneSlot
      {
         return this._runeSlot;
      }
      
      public function setRuneSlot(param1:RuneSlot) : void
      {
         this._runeSlot = param1;
         if(this._runeSlot)
         {
            if(param1.runeType.runeTypeId == RuneType.BLACK_RUNE)
            {
               this.isQuintSlot = true;
               this.initEmptyQuintImage();
            }
            this.runeBookPageChangedHandler();
         }
         this.refreshState();
      }
      
      private function initEmptyQuintImage() : void
      {
         this.quintEmptyIconSizer = new SpriteProxy(this);
         setTimelineChildByName("quintEmptyIconSizer",this.quintEmptyIconSizer);
         this.quintEmptyIconSizer.getLayoutInvalidated().add(invalidateLayout);
         this.quintEmptyIconHolder = new ImageX(this);
         setTimelineChildByName("quintEmptyIconHolder",this.quintEmptyIconHolder);
         var _loc1_:String = RuneImageCache.getEmptyQuintessenceImage(this._runeSlot.minLevel);
         this.quintEmptyIconHolder.load(new URLRequest(_loc1_));
         this.quintEmptyIconHolder.getLayoutInvalidated().add(invalidateLayout);
         invalidateLayout();
      }
      
      private function setRune(param1:Rune) : void
      {
         if(this._rune == param1)
         {
            return;
         }
         setFilters([]);
         this._rune = param1;
         if(this._rune)
         {
            this.runeImageRenderer.setRune(param1);
         }
         this.refreshState();
      }
      
      private function watchControllers() : void
      {
         this.runesViewController.getSummonerLevelChanged().add(this.refreshState);
         this.runesViewController.getRuneBookRetrieved().add(this.runeBookPageChangedHandler);
         this.runesViewController.getCurrentRuneBookPageChanged().add(this.runeBookPageChangedHandler);
         this.runeBookPageChangedHandler();
         this.refreshState();
         this.runeTransportationController.getHighlightedDropTargetChanged().add(this.onHighlightedDropTargetChanged);
         this.runeTransportationController.getRuneAddedToPage().add(this.runeAddedHandler);
         this.runeTransportationController.getRuneRemovedFromPage().add(this.runeRemovedHandler);
      }
      
      private function onHighlightedDropTargetChanged(param1:RuneDropTarget) : void
      {
         if(param1 == null || param1.getTargetSlot() != this._runeSlot)
         {
            if(getFilters().length != 0)
            {
               setFilters([]);
            }
            return;
         }
         setFilters([this.highlightDrop]);
      }
      
      override public function destroy() : void
      {
         this.runesViewController.getSummonerLevelChanged().remove(this.refreshState);
         this.runesViewController.getRuneBookRetrieved().remove(this.runeBookPageChangedHandler);
         this.runesViewController.getCurrentRuneBookPageChanged().remove(this.runeBookPageChangedHandler);
         this.runeTransportationController.getHighlightedDropTargetChanged().remove(this.onHighlightedDropTargetChanged);
         this.runeTransportationController.getRuneAddedToPage().remove(this.runeAddedHandler);
         this.runeTransportationController.getRuneRemovedFromPage().remove(this.runeAddedHandler);
         super.destroy();
      }
      
      private function runeAddedHandler(param1:Rune, param2:RuneSlot) : void
      {
         if(param2 != this._runeSlot)
         {
            return;
         }
         this.isUserInteractionChange = true;
         this.setRune(param1);
         this.isUserInteractionChange = false;
      }
      
      private function runeRemovedHandler(param1:Rune, param2:RuneSlot) : void
      {
         if(param2 != this._runeSlot)
         {
            return;
         }
         this.isUserInteractionChange = true;
         this.setRune(null);
         this.isUserInteractionChange = false;
      }
      
      private function runeBookPageChangedHandler() : void
      {
         var _loc2_:Rune = null;
         if(this._runeSlot == null)
         {
            return;
         }
         var _loc1_:SpellBookPageDTO = this.runesViewController.getCurrentRuneBookPage();
         if(_loc1_)
         {
            _loc2_ = _loc1_.getRuneBySlotNumber(this._runeSlot.id);
            this.setRune(_loc2_);
         }
         else
         {
            this.setRune(null);
         }
      }
      
      private function refreshState(param1:Event = null) : void
      {
         if(Boolean(this._runeSlot) && Boolean(this.runesViewController.getSummoner()) && this.runesViewController.getSummonerLevel() >= this._runeSlot.minLevel)
         {
            if(this._rune)
            {
               if(this.isUserInteractionChange)
               {
                  setCurrentState("newlyFilled");
               }
               else
               {
                  setCurrentState("filled");
               }
            }
            else
            {
               setCurrentState("empty");
            }
         }
         else
         {
            setCurrentState("disabled");
         }
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         if(this.isQuintSlot)
         {
            this.quintEmptyIconHolder.setExplicitPosition(this.quintEmptyIconSizer.getX(),this.quintEmptyIconSizer.getY());
            this.quintEmptyIconHolder.setExplicitSize(this.quintEmptyIconSizer.getWidth(),this.quintEmptyIconSizer.getHeight());
         }
         return super.updateLayout(param1,param2);
      }
   }
}


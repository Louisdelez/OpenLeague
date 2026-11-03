package com.riotgames.pvpnet.runes.views.combiner
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.renderer.IDataRenderer;
   import blix.components.timeline.StatefulView;
   import blix.components.tooltip.ToolTipHandler;
   import blix.components.tooltip.assignToolTip;
   import blix.components.tooltip.unassignToolTip;
   import blix.context.IContext;
   import com.riotgames.platform.gameclient.domain.Rune;
   import com.riotgames.platform.gameclient.domain.SummonerRune;
   import com.riotgames.pvpnet.runes.tooltip.RuneToolTip;
   import com.riotgames.pvpnet.runes.viewcontroller.RuneCombinerViewController;
   import com.riotgames.pvpnet.runes.viewcontroller.RunesTransportationController;
   import com.riotgames.pvpnet.runes.viewcontroller.RunesViewController;
   import com.riotgames.pvpnet.runes.views.common.RuneImageRenderer;
   import com.riotgames.rust.drag.DragBehavior;
   import flash.desktop.Clipboard;
   import flash.desktop.NativeDragManager;
   import flash.desktop.NativeDragOptions;
   import flash.display.BitmapData;
   import flash.events.MouseEvent;
   import flash.events.NativeDragEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   public class RuneCombinerSlotView extends StatefulView implements IDataRenderer
   {
      
      private var _index:uint;
      
      private var _rune:Rune;
      
      private var runeImageRenderer:RuneImageRenderer;
      
      private var runeSizer:SpriteProxy;
      
      private var runeTransportationController:RunesTransportationController;
      
      private var runeCombinerViewController:RuneCombinerViewController;
      
      private var runesViewController:RunesViewController;
      
      private var dragBehavior:DragBehavior;
      
      public function RuneCombinerSlotView(param1:IContext, param2:uint)
      {
         super(param1);
         this._index = param2;
         setDoubleClickEnabled(true);
         setMouseChildren(false);
         setEnabled(true);
         setButtonMode(true);
         addEventListener(MouseEvent.RIGHT_CLICK,this.onMouseRightClick);
         addEventListener(MouseEvent.DOUBLE_CLICK,this.onMouseDoubleClick);
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER,this.onNativeDragEnter);
         addEventListener(NativeDragEvent.NATIVE_DRAG_DROP,this.onNativeDragDrop);
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
         if(Boolean(this._rune) && Boolean(this.runesViewController.isLocalSummoner()) && this.runeCombinerViewController.getRunesToCombine().getLength() - 1 == this._index)
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
            _loc8_.setData(Rune.DATA_FORMAT,this._rune);
            _loc9_ = new NativeDragOptions();
            _loc9_.allowCopy = false;
            _loc9_.allowLink = false;
            _loc9_.allowMove = true;
            NativeDragManager.doDrag(getInteractiveAsset(),_loc8_,_loc6_,new Point(-_loc6_.width / 2,-_loc6_.height / 2),_loc9_);
         }
      }
      
      public function getData() : *
      {
         return this._rune;
      }
      
      public function setData(param1:*) : void
      {
         if(param1 == this._rune)
         {
            return;
         }
         this._rune = param1 as Rune;
         this.runeImageRenderer.setRune(this._rune);
         if(!this._rune)
         {
            return;
         }
      }
      
      private function onMouseRightClick(param1:MouseEvent) : void
      {
         this.tryToRemoveRune();
      }
      
      private function tryToRemoveRune() : void
      {
         if(this._rune)
         {
            this.runeTransportationController.removeRuneFromCombiner(this._rune);
         }
      }
      
      private function onNativeDragDrop(param1:NativeDragEvent) : void
      {
         var _loc2_:SummonerRune = null;
         if(Boolean(param1.clipboard.hasFormat(SummonerRune.DATA_FORMAT)) && getCurrentState() == "active")
         {
            _loc2_ = param1.clipboard.getData(SummonerRune.DATA_FORMAT) as SummonerRune;
            if(_loc2_)
            {
               this.runeTransportationController.addRuneToFirstAvailableSlot(_loc2_);
            }
         }
      }
      
      private function onNativeDragEnter(param1:NativeDragEvent) : void
      {
         var _loc2_:SummonerRune = null;
         if(Boolean(param1.clipboard.hasFormat(SummonerRune.DATA_FORMAT)) && getCurrentState() == "active")
         {
            _loc2_ = param1.clipboard.getData(SummonerRune.DATA_FORMAT) as SummonerRune;
            if(Boolean(_loc2_) && !this._rune)
            {
               NativeDragManager.acceptDragDrop(getInteractiveAsset());
            }
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.runeImageRenderer = new RuneImageRenderer(this);
         setTimelineChildByName("runeImageRenderer",this.runeImageRenderer);
         this.runeImageRenderer.setRuneEffectGlowActive(true);
         this.runeImageRenderer.setMouseoverGlowActive(true);
         this.runeSizer = new SpriteProxy(this);
         setTimelineChildByName("runeSizer",this.runeSizer);
         this.runeImageRenderer.setSizer(this.runeSizer);
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         this.runeTransportationController = getDependency(RunesTransportationController);
         this.runeCombinerViewController = getDependency(RuneCombinerViewController);
         this.runesViewController = getDependency(RunesViewController);
      }
      
      private function onMouseDoubleClick(param1:MouseEvent) : void
      {
         this.tryToRemoveRune();
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         var _loc2_:ToolTipHandler = null;
         var _loc3_:RuneToolTip = null;
         var _loc4_:IResourceManager = null;
         if(this._rune)
         {
            _loc3_ = new RuneToolTip(this);
            _loc2_ = new ToolTipHandler(_loc3_);
            _loc2_.showDelay = 0;
            _loc2_.hideDelay = 0;
            assignToolTip(this,this._rune,_loc2_);
         }
         else if(getCurrentState() == "active")
         {
            _loc4_ = ResourceManager.getInstance();
            assignToolTip(this,_loc4_.getString("resources","runeCombiner_runeTargetTooltip"));
         }
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         unassignToolTip(this);
      }
      
      public function getIndex() : uint
      {
         return this._index;
      }
   }
}


package com.riotgames.pvpnet.runes.views.runespage
{
   import blix.assets.proxy.SpriteProxy;
   import blix.context.IContext;
   import com.riotgames.platform.gameclient.domain.RuneSlot;
   import com.riotgames.platform.gameclient.domain.RuneType;
   import com.riotgames.platform.gameclient.domain.SummonerRune;
   import com.riotgames.pvpnet.runes.viewcontroller.RuneDropTarget;
   import com.riotgames.pvpnet.runes.viewcontroller.RunesTransportationController;
   import com.riotgames.pvpnet.tracking.trackers.runes.IRunesTracker;
   import flash.desktop.NativeDragManager;
   import flash.events.NativeDragEvent;
   
   public class RuneAreasContainer extends SpriteProxy
   {
      
      private var marksArea:RunesArea;
      
      private var sealsArea:RunesArea;
      
      private var glyphsArea:RunesArea;
      
      private var quintsArea:RunesArea;
      
      private var dropArea:SpriteProxy;
      
      private var _runesTracker:IRunesTracker;
      
      private var runeTransportationController:RunesTransportationController;
      
      public function RuneAreasContainer(param1:IContext)
      {
         super(param1);
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         this._runesTracker = getDependency(IRunesTracker);
         this.runeTransportationController = getDependency(RunesTransportationController);
      }
      
      private function onNativeDragDrop(param1:NativeDragEvent) : void
      {
         var _loc2_:SummonerRune = null;
         if(param1.clipboard.hasFormat(SummonerRune.DATA_FORMAT))
         {
            _loc2_ = param1.clipboard.getData(SummonerRune.DATA_FORMAT) as SummonerRune;
            if(_loc2_)
            {
               this._runesTracker.incrementRunes_UserDragAndDropToAddNonSpecificSlot_Count_InASession();
               this.runeTransportationController.addRuneToFirstAvailableSlot(_loc2_);
               this._runesTracker.incrementRunes_UserDragAndDropToAddTotal_Count_InASession();
            }
         }
      }
      
      private function onNativeDragEnter(param1:NativeDragEvent) : void
      {
         var _loc2_:SummonerRune = null;
         var _loc3_:RuneSlot = null;
         if(param1.clipboard.hasFormat(SummonerRune.DATA_FORMAT))
         {
            _loc2_ = param1.clipboard.getData(SummonerRune.DATA_FORMAT) as SummonerRune;
            if(_loc2_)
            {
               _loc3_ = this.runeTransportationController.getFirstEmptySlotByRune(_loc2_.rune);
               if(_loc3_)
               {
                  NativeDragManager.acceptDragDrop(this.dropArea.getInteractiveAsset());
                  this.runeTransportationController.setHighlightedDropTarget(new RuneDropTarget(_loc2_,_loc3_));
               }
            }
         }
      }
      
      private function onNativeDragExit(param1:NativeDragEvent) : void
      {
         if(param1.clipboard.hasFormat(SummonerRune.DATA_FORMAT))
         {
            this.runeTransportationController.setHighlightedDropTarget(null);
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.marksArea = new RunesArea(this,RuneType.RED_RUNE,9);
         setTimelineChildByName("marksArea",this.marksArea);
         this.sealsArea = new RunesArea(this,RuneType.YELLOW_RUNE,9);
         setTimelineChildByName("sealsArea",this.sealsArea);
         this.glyphsArea = new RunesArea(this,RuneType.BLUE_RUNE,9);
         setTimelineChildByName("glyphsArea",this.glyphsArea);
         this.quintsArea = new RunesArea(this,RuneType.BLACK_RUNE,3);
         setTimelineChildByName("quintsArea",this.quintsArea);
         this.dropArea = new SpriteProxy(this);
         setTimelineChildByName("dropArea",this.dropArea);
         this.dropArea.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER,this.onNativeDragEnter);
         this.dropArea.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP,this.onNativeDragDrop);
         this.dropArea.addEventListener(NativeDragEvent.NATIVE_DRAG_EXIT,this.onNativeDragExit);
      }
   }
}


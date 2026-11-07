package com.riotgames.pvpnet.runes.views.runespage
{
   import blix.assets.proxy.SpriteProxy;
   import blix.context.IContext;
   import com.riotgames.platform.common.provider.IRuneBookController;
   import com.riotgames.platform.gameclient.domain.RuneSlot;
   
   public class RunesArea extends SpriteProxy
   {
      
      private var totalSlots:uint;
      
      private var runeType:int;
      
      private var runeBookController:IRuneBookController;
      
      private var runeSlots:Vector.<RuneSlotView>;
      
      public function RunesArea(param1:IContext, param2:int, param3:uint)
      {
         this.totalSlots = param3;
         this.runeType = param2;
         super(param1);
         this.watchController();
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         this.runeBookController = getDependency(IRuneBookController);
      }
      
      override protected function createChildren() : void
      {
         var _loc2_:RuneSlotView = null;
         super.createChildren();
         this.runeSlots = new Vector.<RuneSlotView>(this.totalSlots,true);
         var _loc1_:uint = 0;
         while(_loc1_ < this.totalSlots)
         {
            _loc2_ = new RuneSlotView(this,_loc1_);
            setTimelineChildByName("slot" + _loc1_,_loc2_);
            this.runeSlots[_loc1_] = _loc2_;
            _loc1_++;
         }
      }
      
      private function watchController() : void
      {
         var _loc2_:RuneSlot = null;
         var _loc1_:uint = 0;
         for each(_loc2_ in this.runeBookController.standardSpellBookPageConfiguration)
         {
            if(_loc2_.runeType.runeTypeId == this.runeType)
            {
               this.runeSlots[_loc1_].setRuneSlot(_loc2_);
               _loc1_++;
            }
         }
      }
   }
}


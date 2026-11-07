package com.riotgames.pvpnet.runes.viewcontroller
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.audio.AudioKeys;
   import com.riotgames.platform.common.provider.IRuneBookController;
   import com.riotgames.platform.common.provider.ISoundProvider;
   import com.riotgames.platform.gameclient.domain.Rune;
   import com.riotgames.platform.gameclient.domain.RuneSlot;
   import com.riotgames.platform.gameclient.domain.RuneType;
   import com.riotgames.platform.gameclient.domain.SlotEntry;
   import com.riotgames.platform.gameclient.domain.SpellBookPageDTO;
   import com.riotgames.platform.gameclient.domain.SummonerRune;
   import com.riotgames.platform.gameclient.events.RuneBookEvent;
   import com.riotgames.pvpnet.runes.controller.RuneCounter;
   
   public class RunesTransportationController
   {
      
      private var _runeAddedToPage:Signal = new Signal();
      
      private var _runeRemovedFromPage:Signal = new Signal();
      
      private var _runeAddedToCombiner:Signal = new Signal();
      
      private var _runeRemovedFromCombiner:Signal = new Signal();
      
      private var _runeBookStateChanged:Signal = new Signal();
      
      private var _highlightDropTargetChanged:Signal = new Signal();
      
      private var runeBookController:IRuneBookController;
      
      private var runesViewController:RunesViewController;
      
      private var runeCombinerViewController:RuneCombinerViewController;
      
      private var runeCounter:RuneCounter;
      
      private var soundProvider:ISoundProvider;
      
      private var _highlightedDropTarget:RuneDropTarget;
      
      public function RunesTransportationController(param1:IRuneBookController, param2:RunesViewController, param3:RuneCombinerViewController, param4:RuneCounter, param5:ISoundProvider)
      {
         super();
         this.runeBookController = param1;
         this.runesViewController = param2;
         this.runeCombinerViewController = param3;
         this.runeCounter = param4;
         this.soundProvider = param5;
         this.runeBookController.addEventListener(RuneBookEvent.RUNE_BOOK_STATE_CHANGED,this.handleRuneBookStateChanged);
      }
      
      public function getRuneAddedToPage() : ISignal
      {
         return this._runeAddedToPage;
      }
      
      public function getRuneRemovedFromPage() : ISignal
      {
         return this._runeRemovedFromPage;
      }
      
      public function getRuneAddedToCombiner() : ISignal
      {
         return this._runeAddedToCombiner;
      }
      
      public function getRuneRemovedFromCombiner() : ISignal
      {
         return this._runeRemovedFromCombiner;
      }
      
      public function getRuneBookStateChanged() : ISignal
      {
         return this._runeBookStateChanged;
      }
      
      private function addRuneToPage(param1:SummonerRune, param2:RuneSlot = null) : Boolean
      {
         var _loc3_:Rune = param1.rune;
         if(_loc3_ == null)
         {
            return false;
         }
         var _loc4_:SpellBookPageDTO = this.runesViewController.getCurrentRuneBookPage();
         if(_loc4_ == null)
         {
            return false;
         }
         var _loc5_:int = this.getUsedCount(_loc3_);
         if(_loc5_ >= param1.quantity)
         {
            return false;
         }
         if(param2 == null)
         {
            param2 = this.getFirstEmptySlotByRune(_loc3_);
         }
         if(param2 != null)
         {
            this.addRuneToPageBySlot(_loc3_,param2);
            return true;
         }
         return false;
      }
      
      public function getFirstEmptySlotByRune(param1:Rune) : RuneSlot
      {
         var _loc3_:RuneSlot = null;
         var _loc4_:RuneSlot = null;
         var _loc5_:Rune = null;
         var _loc2_:SpellBookPageDTO = this.runesViewController.getCurrentRuneBookPage();
         if(_loc2_ == null || param1 == null)
         {
            return null;
         }
         for each(_loc4_ in this.runeBookController.standardSpellBookPageConfiguration)
         {
            if(_loc4_.runeType.runeTypeId == param1.runeType.runeTypeId && _loc4_.minLevel <= this.runeBookController.summonerLevel)
            {
               _loc5_ = _loc2_.getRuneBySlotNumber(_loc4_.id);
               if(_loc5_ == null)
               {
                  _loc3_ = _loc4_;
                  break;
               }
            }
         }
         return _loc3_;
      }
      
      public function setHighlightedDropTarget(param1:RuneDropTarget) : void
      {
         this._highlightedDropTarget = param1;
         this._highlightDropTargetChanged.dispatch(this._highlightedDropTarget);
      }
      
      public function getHighlightedDropTargetChanged() : ISignal
      {
         return this._highlightDropTargetChanged;
      }
      
      public function getHighlightedDropTarget() : RuneDropTarget
      {
         return this._highlightedDropTarget;
      }
      
      private function addRuneToCombiner(param1:Rune) : Boolean
      {
         var _loc2_:Boolean = this.runeCombinerViewController.addRuneToCombiner(param1);
         if(_loc2_)
         {
            this._runeAddedToCombiner.dispatch(param1,null);
         }
         return _loc2_;
      }
      
      public function removeRuneFromCombiner(param1:Rune) : Boolean
      {
         var _loc2_:Boolean = this.runeCombinerViewController.removeRuneFromCombiner(param1);
         if(_loc2_)
         {
            this._runeRemovedFromCombiner.dispatch(param1,null);
         }
         return _loc2_;
      }
      
      public function addRuneToFirstAvailableSlot(param1:SummonerRune) : Boolean
      {
         if(this.runeBookController.combining)
         {
            return this.addRuneToCombiner(param1.rune);
         }
         if(this.runesViewController.isLocalSummoner())
         {
            return this.addRuneToPage(param1);
         }
         return false;
      }
      
      public function addRuneToSpecificSlot(param1:SummonerRune, param2:RuneSlot) : Boolean
      {
         if(this.runesViewController.isLocalSummoner())
         {
            return this.addRuneToPage(param1,param2);
         }
         return false;
      }
      
      private function addRuneToPageBySlot(param1:Rune, param2:RuneSlot) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(param1.runeType.runeTypeId == RuneType.BLACK_RUNE)
         {
            this.soundProvider.play(AudioKeys.RUNES_RUNE_DROP_2);
         }
         else
         {
            this.soundProvider.play(AudioKeys.RUNES_RUNE_DROP_1);
         }
         this.runesViewController.getCurrentRuneBookPage().setRuneBySlotNumber(param2,param1);
         this._runeAddedToPage.dispatch(param1,param2);
         this.reset();
      }
      
      public function getUsedCount(param1:Rune) : int
      {
         return this.runeCounter.getRuneUsedCount(param1);
      }
      
      public function removeRuneFromSlot(param1:RuneSlot) : Boolean
      {
         if(!this.runesViewController.isLocalSummoner())
         {
            return false;
         }
         var _loc2_:SpellBookPageDTO = this.runesViewController.getCurrentRuneBookPage();
         if(_loc2_ == null)
         {
            return false;
         }
         var _loc3_:Rune = _loc2_.getRuneBySlotNumber(param1.id);
         if(_loc3_ != null)
         {
            _loc2_.deleteRuneBySlotNumber(param1.id);
            this._runeRemovedFromPage.dispatch(_loc3_,param1);
            this.reset();
            return true;
         }
         return false;
      }
      
      public function clearPage() : void
      {
         var _loc3_:SlotEntry = null;
         var _loc4_:SlotEntry = null;
         var _loc1_:SpellBookPageDTO = this.runesViewController.getCurrentRuneBookPage();
         if(_loc1_ == null)
         {
            return;
         }
         var _loc2_:Vector.<SlotEntry> = new Vector.<SlotEntry>();
         for each(_loc3_ in _loc1_.getEntries())
         {
            if(_loc3_.getRune() != null)
            {
               _loc2_.push(_loc3_);
            }
         }
         for each(_loc4_ in _loc2_)
         {
            _loc1_.deleteRuneBySlotNumber(_loc4_.runeSlotId);
            this._runeRemovedFromPage.dispatch(_loc4_.getRune(),_loc4_.getRuneSlot());
         }
         this.reset();
      }
      
      private function handleRuneBookStateChanged(param1:RuneBookEvent) : void
      {
         this._runeBookStateChanged.dispatch(param1.editing,param1.combining);
      }
      
      private function reset() : void
      {
         this.runesViewController.resetFilteredRunes();
         this.runesViewController.setHasUnsavedChanges(true);
      }
   }
}


package com.riotgames.pvpnet.runes.viewcontroller
{
   import blix.ds.IListX;
   import blix.ds.ListView;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.provider.IRuneBookController;
   import com.riotgames.platform.gameclient.domain.Rune;
   import com.riotgames.rust.data.ListAdapter;
   import mx.collections.ArrayCollection;
   
   public class RuneCombinerViewController
   {
      
      private var runeBookController:IRuneBookController;
      
      private var runeFilter:RuneFilter;
      
      private var runesToCombine:ListView;
      
      private var _combinerButtonEnabled:Boolean;
      
      private var _combinerViewActive:Boolean = false;
      
      private var _combineSucceeded:Signal = new Signal();
      
      private var _combineFailed:Signal = new Signal();
      
      private var _combineStarted:Signal = new Signal();
      
      private var _combinerViewActiveChanged:Signal = new Signal();
      
      private var _runeAddedToCombiner:Signal = new Signal();
      
      private var _runeRemovedFromCombiner:Signal = new Signal();
      
      private var _combinerButtonEnabledChanged:Signal = new Signal();
      
      public function RuneCombinerViewController(param1:IRuneBookController, param2:RuneFilter, param3:ListView)
      {
         super();
         this._combinerButtonEnabled = true;
         this.runeBookController = param1;
         this.runeFilter = param2;
         this.runesToCombine = param3;
      }
      
      public function getRunesToCombine() : IListX
      {
         return this.runesToCombine;
      }
      
      public function startCombine() : void
      {
         this.runeBookController.combining = true;
      }
      
      public function combine() : void
      {
         this.setCombinerButtonEnabled(false);
         this._combineStarted.dispatch();
         this.runeBookController.combineRunes(new ArrayCollection(this.runesToCombine.toArray()),this.onRuneCombineComplete);
      }
      
      public function setRuneCombinerViewActive(param1:Boolean) : void
      {
         if(param1 == this._combinerViewActive || !this._combinerButtonEnabled)
         {
            return;
         }
         this._combinerViewActive = param1;
         this._combinerViewActiveChanged.dispatch(param1);
      }
      
      public function getRuneCombinerViewActiveChanged() : ISignal
      {
         return this._combinerViewActiveChanged;
      }
      
      public function getRuneCombinerViewActive() : Boolean
      {
         return this._combinerViewActive;
      }
      
      public function setCombinerButtonEnabled(param1:Boolean) : void
      {
         if(this._combinerButtonEnabled == param1)
         {
            return;
         }
         this._combinerButtonEnabled = param1;
         this._combinerButtonEnabledChanged.dispatch(param1);
      }
      
      public function getCombineStarted() : ISignal
      {
         return this._combineStarted;
      }
      
      private function onRuneCombineComplete(param1:Boolean) : void
      {
         if(!param1)
         {
            this.runesToCombine.removeAll();
            this.runesToCombine.reset();
            this.runeBookController.summonerRunesAwardedList = null;
            this._combineFailed.dispatch();
         }
         else if(this.runeBookController.summonerRunesAwardedList.length > 0)
         {
            this.runesToCombine.removeAll();
            this.runesToCombine.reset();
            this._combineSucceeded.dispatch(new ListAdapter(this.runeBookController.summonerRunesAwardedList));
         }
         this.setCombinerButtonEnabled(true);
         this.runeFilter.setExclusiveTier(0);
      }
      
      public function endCombine() : void
      {
         this.runesToCombine.removeAll();
         this.runeBookController.combining = false;
         this.runeBookController.summonerRunesAwardedList = null;
         this.runeFilter.setExclusiveTier(0);
      }
      
      public function addRuneToCombiner(param1:Rune) : Boolean
      {
         if(!this.canAddMoreRunes())
         {
            return false;
         }
         this.runesToCombine.addItem(param1);
         this.runeBookController.addRuneToCombiner(param1);
         this.runeFilter.setExclusiveTier(param1.tier);
         this._runeAddedToCombiner.dispatch();
         return true;
      }
      
      public function removeRuneFromCombiner(param1:Rune) : Boolean
      {
         this.runeBookController.removeRuneFromCombiner(param1);
         var _loc2_:Boolean = Boolean(this.runesToCombine.removeItem(param1));
         if(this.runesToCombine.getLength() == 0)
         {
            this.runeFilter.setExclusiveTier(0);
         }
         this._runeRemovedFromCombiner.dispatch();
         return _loc2_;
      }
      
      public function removeAllRunesFromCombiner() : void
      {
         var _loc1_:Rune = null;
         for each(_loc1_ in this.runesToCombine)
         {
            this.runeBookController.removeRuneFromCombiner(_loc1_);
         }
         this.runesToCombine.removeAll();
      }
      
      public function canAddMoreRunes() : Boolean
      {
         var _loc1_:Rune = this.runesToCombine.getItemAt(0) as Rune;
         var _loc2_:Rune = this.runesToCombine.getItemAt(1) as Rune;
         var _loc3_:Boolean = true;
         if(this.runesToCombine.getLength() < 2)
         {
            _loc3_ = true;
         }
         if(Boolean(_loc1_) && Boolean(_loc2_))
         {
            if(_loc1_.tier == _loc2_.tier && _loc1_.tier == 3)
            {
               _loc3_ = false;
            }
         }
         if(this.runesToCombine.getLength() >= 5)
         {
            _loc3_ = false;
         }
         return _loc3_;
      }
      
      public function getCombineSucceeded() : ISignal
      {
         return this._combineSucceeded;
      }
      
      public function getCombineFailed() : ISignal
      {
         return this._combineFailed;
      }
      
      public function getRuneAddedToCombiner() : ISignal
      {
         return this._runeAddedToCombiner;
      }
      
      public function getRuneRemovedFromCombiner() : ISignal
      {
         return this._runeRemovedFromCombiner;
      }
      
      public function getCombinerButtonEnabledChanged() : Signal
      {
         return this._combinerButtonEnabledChanged;
      }
   }
}


package com.riotgames.pvpnet.runes.viewcontroller
{
   import blix.ds.IListX;
   import blix.ds.ListView;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.gameclient.domain.RuneType;
   import com.riotgames.platform.gameclient.domain.SummonerRune;
   import com.riotgames.rust.data.ListAdapter;
   import mx.collections.ArrayCollection;
   import mx.utils.ObjectUtil;
   
   public class RuneViewModel
   {
      
      private var _summonerRunes:ListAdapter;
      
      private var _filteredSortedRunes:ListView;
      
      private var _runesToCombine:IListX;
      
      private var _runesFilter:RuneFilter;
      
      private var _marksChanged:Signal = new Signal();
      
      private var _glyphsChanged:Signal = new Signal();
      
      private var _sealsChanged:Signal = new Signal();
      
      private var _quintsChanged:Signal = new Signal();
      
      private var _marks:ListView;
      
      private var _glyphs:ListView;
      
      private var _seals:ListView;
      
      private var _quints:ListView;
      
      public function RuneViewModel(param1:ArrayCollection, param2:IListX, param3:RuneFilter)
      {
         super();
         this._runesToCombine = param2;
         this._runesFilter = param3;
         this._summonerRunes = new ListAdapter(param1);
         this.setSummonerRunes(param1);
      }
      
      public function getMarks() : IListX
      {
         return this._marks;
      }
      
      public function getSeals() : IListX
      {
         return this._seals;
      }
      
      public function getGlyphs() : IListX
      {
         return this._glyphs;
      }
      
      public function getQuints() : IListX
      {
         return this._quints;
      }
      
      public function getMarksChanged() : ISignal
      {
         return this._marksChanged;
      }
      
      public function getSealsChanged() : ISignal
      {
         return this._sealsChanged;
      }
      
      public function getGlyphsChanged() : ISignal
      {
         return this._glyphsChanged;
      }
      
      public function getQuintsChanged() : ISignal
      {
         return this._quintsChanged;
      }
      
      public function setSummonerRunes(param1:ArrayCollection) : void
      {
         this._summonerRunes.setList(param1);
         this.createSummonerRunes();
      }
      
      public function reset() : void
      {
         if(this._filteredSortedRunes)
         {
            this._filteredSortedRunes.reset();
         }
      }
      
      private function createRuneList(param1:IListX, param2:int) : ListView
      {
         var source:IListX = param1;
         var runeType:int = param2;
         var list:ListView = new ListView(source);
         list.filter(function(param1:SummonerRune, param2:int, param3:Array):Boolean
         {
            return param1.rune.runeType.runeTypeId == runeType;
         });
         list.reset();
         list.sortWithCompare(this.runeSort);
         return list;
      }
      
      private function createSummonerRunes() : void
      {
         if(this._filteredSortedRunes)
         {
            this._runesFilter.getChanged().remove(this._filteredSortedRunes.reset);
         }
         if(!this._summonerRunes)
         {
            return;
         }
         this._filteredSortedRunes = new ListView(this._summonerRunes);
         this._runesFilter.getChanged().add(this._filteredSortedRunes.reset);
         this._filteredSortedRunes.filter(this._runesFilter.filter);
         this.createRuneViews();
      }
      
      private function createRuneViews() : void
      {
         this._marks = this.createRuneList(this._filteredSortedRunes,RuneType.RED_RUNE);
         this._marksChanged.dispatch(this._marks);
         this._glyphs = this.createRuneList(this._filteredSortedRunes,RuneType.BLUE_RUNE);
         this._glyphsChanged.dispatch(this._glyphs);
         this._seals = this.createRuneList(this._filteredSortedRunes,RuneType.YELLOW_RUNE);
         this._sealsChanged.dispatch(this._seals);
         this._quints = this.createRuneList(this._filteredSortedRunes,RuneType.BLACK_RUNE);
         this._quintsChanged.dispatch(this._quints);
      }
      
      private function runeSort(param1:SummonerRune, param2:SummonerRune) : int
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(param1.rune == null || param2.rune == null)
         {
            return 0;
         }
         var _loc3_:int = int(ObjectUtil.numericCompare(param2.rune.tier,param1.rune.tier));
         if(_loc3_ == 0)
         {
            _loc4_ = -1;
            _loc5_ = -1;
            _loc3_ = int(ObjectUtil.numericCompare(_loc4_,_loc5_));
            if(_loc3_ == 0)
            {
               if(param1.rune.displayName != param2.rune.displayName)
               {
                  _loc3_ = param1.rune.displayName < param2.rune.displayName ? -1 : 1;
               }
               else
               {
                  _loc3_ = int(ObjectUtil.numericCompare(param1.quantity,param2.quantity));
               }
            }
         }
         return _loc3_;
      }
   }
}


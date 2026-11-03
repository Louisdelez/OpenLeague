package com.riotgames.platform.gameclient.controllers.game.model
{
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.Models.SearchTagData;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.ChampionWildCardEnums;
   import com.riotgames.platform.gameclient.domain.IChampionFilter;
   import com.riotgames.platform.gameclient.domain.game.ParticipantChampionSelection;
   import com.riotgames.platform.gameclient.domain.gameconfig.GameTypeConfig;
   import flash.utils.Dictionary;
   import mx.collections.ArrayCollection;
   import mx.collections.ArrayList;
   import mx.collections.Sort;
   
   public class ParticipantChampionListView extends ArrayCollection
   {
      
      private var _filterString:String = "";
      
      public var notOwned:Boolean = true;
      
      private var _almostExpired:Boolean = false;
      
      private var championMapping:Dictionary;
      
      private var _ownedByMyTeam:Boolean = false;
      
      private var _customFilterFunction:Function;
      
      public var owned:Boolean = true;
      
      private var _rented:Boolean = false;
      
      private var _source:Array;
      
      public var recentlyPurchased:Boolean = false;
      
      private var _ownedByEitherTeam:Boolean = false;
      
      private var championFilter:IChampionFilter;
      
      private var _showRandom:Boolean = false;
      
      private var championIdMapping:Dictionary;
      
      private var _gameTypeConfig:GameTypeConfig;
      
      private var _available:Boolean = false;
      
      private var _ownedByEnemyTeam:Boolean = false;
      
      private var _rentedExpired:Boolean = false;
      
      private var _allowFreeChampions:Boolean;
      
      public function ParticipantChampionListView(param1:GameTypeConfig, param2:Boolean, param3:IChampionFilter, param4:Array = null)
      {
         this._gameTypeConfig = param1;
         this._allowFreeChampions = param2;
         this.championFilter = param3;
         super(param4);
         this.filterFunction = null;
      }
      
      public function get ownedByEnemyTeam() : Boolean
      {
         return this._ownedByEnemyTeam;
      }
      
      public function set customFilterFunction(param1:Function) : void
      {
         if(this._customFilterFunction == param1)
         {
            return;
         }
         this.filterFunction = param1;
         this.championFilter.setCustomFilterFunction(param1);
      }
      
      public function get almostExpired() : Boolean
      {
         return this._almostExpired;
      }
      
      public function get rented() : Boolean
      {
         return this._rented;
      }
      
      public function set available(param1:Boolean) : void
      {
         if(this._available != param1)
         {
            this._available = param1;
         }
      }
      
      private function createParticipant(param1:Champion, param2:ArrayList, param3:Dictionary, param4:Dictionary) : void
      {
         var _loc5_:ParticipantChampionSelection = new ParticipantChampionSelection(this._gameTypeConfig,param1);
         param2.addItem(_loc5_);
         param3[param1] = _loc5_;
         param4[param1.championId] = _loc5_;
      }
      
      public function get showRandom() : Boolean
      {
         return this._showRandom;
      }
      
      public function set ownedByEnemyTeam(param1:Boolean) : void
      {
         if(this._ownedByEnemyTeam != param1)
         {
            this._ownedByEnemyTeam = param1;
         }
      }
      
      override public function get source() : Array
      {
         return this._source;
      }
      
      public function get filterString() : String
      {
         return this._filterString;
      }
      
      public function getSortTagDisplayString() : String
      {
         var _loc3_:SearchTagData = null;
         var _loc1_:int = 0;
         var _loc2_:String = "";
         for each(_loc3_ in this.championFilter.getSearchTags())
         {
            _loc2_ += _loc3_.searchTagDisplayName;
            if(_loc1_ < this.championFilter.getSearchTags().length - 1)
            {
               _loc2_ += ", ";
            }
         }
         return _loc2_;
      }
      
      public function set almostExpired(param1:Boolean) : void
      {
         if(this._almostExpired != param1)
         {
            this._almostExpired = param1;
         }
      }
      
      private function createAbstainChampion() : Champion
      {
         var _loc1_:Champion = new Champion();
         _loc1_.setAsWildCardChampion(ChampionWildCardEnums.ID_ABSTAIN_CHAMPION);
         _loc1_.displayName = RiotResourceLoader.getString("championSelection_abstainChampion_displayName");
         return _loc1_;
      }
      
      public function getSelectionByChampionId(param1:int) : ParticipantChampionSelection
      {
         if(Boolean(this.championIdMapping))
         {
            return this.championIdMapping[param1];
         }
         return null;
      }
      
      public function get ownedByMyTeam() : Boolean
      {
         return this._ownedByMyTeam;
      }
      
      override public function set source(param1:Array) : void
      {
         this._source = param1;
         list = this.createChampionList(param1);
      }
      
      private function championFilterFunction(param1:Object) : Boolean
      {
         var _loc2_:Champion = param1.champion as Champion;
         var _loc3_:Boolean = this.recentlyPurchased == true && !_loc2_.recentPurchase() == true;
         _loc3_ ||= this.owned == true && this.notOwned == false && _loc2_.owned == false;
         _loc3_ ||= this.owned == false && this.notOwned == true && _loc2_.owned == true;
         _loc3_ ||= this.available == true && !_loc2_.isAvailable(this._allowFreeChampions);
         _loc3_ ||= Boolean(_loc2_.isRandomChampion()) && !this.showRandom;
         _loc3_ ||= this.ownedByMyTeam && !param1.ownedByYourTeam;
         _loc3_ ||= this.ownedByEnemyTeam && !param1.ownedByEnemyTeam;
         _loc3_ ||= this.ownedByEitherTeam && !(Boolean(param1.ownedByYourTeam) || Boolean(param1.ownedByEnemyTeam));
         _loc3_ ||= this.rented && !_loc2_.isRented();
         _loc3_ ||= this.rentedExpired && !_loc2_.isExpired();
         _loc3_ ||= this.almostExpired && !_loc2_.isAlmostExpired();
         if(Boolean(this.championFilter))
         {
            _loc3_ ||= !this.championFilter.filter(_loc2_,-1,null);
         }
         if(Boolean(_loc2_.isWildCardChampion()) && this.showRandom)
         {
            _loc3_ = false;
         }
         return !_loc3_;
      }
      
      public function get ownedByEitherTeam() : Boolean
      {
         return this._ownedByEitherTeam;
      }
      
      public function set showRandom(param1:Boolean) : void
      {
         if(this._showRandom != param1)
         {
            this._showRandom = param1;
         }
      }
      
      private function createChampionList(param1:Array) : ArrayList
      {
         var _loc2_:ArrayList = null;
         var _loc3_:Dictionary = null;
         var _loc4_:Dictionary = null;
         var _loc5_:Champion = null;
         if(Boolean(param1))
         {
            _loc2_ = new ArrayList();
            _loc3_ = new Dictionary(true);
            _loc4_ = new Dictionary(true);
            for each(_loc5_ in param1)
            {
               this.createParticipant(_loc5_,_loc2_,_loc3_,_loc4_);
            }
            if(this._gameTypeConfig != null && Boolean(this._gameTypeConfig.votePickGameTypeConfig))
            {
               this.createParticipant(this.createAbstainChampion(),_loc2_,_loc3_,_loc4_);
            }
            else
            {
               this.createParticipant(this.createRandomChampion(),_loc2_,_loc3_,_loc4_);
            }
            if(sort == null)
            {
               sort = this.createNameSort();
            }
            this.championMapping = _loc3_;
            this.championIdMapping = _loc4_;
         }
         else
         {
            this.championMapping = null;
            this.championIdMapping = null;
         }
         return _loc2_;
      }
      
      public function set rented(param1:Boolean) : void
      {
         if(this._rented != param1)
         {
            this._rented = param1;
         }
      }
      
      public function get available() : Boolean
      {
         return this._available;
      }
      
      public function set filterString(param1:String) : void
      {
         if(param1 != this._filterString)
         {
            this._filterString = param1;
            this.championFilter.setFilterString(param1.toLowerCase());
         }
      }
      
      public function getSelectionByChampion(param1:Champion) : ParticipantChampionSelection
      {
         if(Boolean(this.championIdMapping))
         {
            return this.championMapping[param1];
         }
         return null;
      }
      
      public function set rentedExpired(param1:Boolean) : void
      {
         if(this._rentedExpired != param1)
         {
            this._rentedExpired = param1;
         }
      }
      
      public function findRandomUnselectedChampion() : Champion
      {
         var _loc2_:ParticipantChampionSelection = null;
         var _loc5_:ParticipantChampionSelection = null;
         var _loc1_:uint = 0;
         for each(_loc2_ in this)
         {
            if(this.championAvailableToBeRandomed(_loc2_))
            {
               _loc1_++;
            }
         }
         if(_loc1_ == 0)
         {
            for each(_loc2_ in this)
            {
               if(Boolean(_loc2_.participant) && Boolean(_loc2_.participant.isMe))
               {
                  return _loc2_.champion;
               }
            }
            return null;
         }
         var _loc3_:int = Math.floor(Math.random() * _loc1_);
         var _loc4_:uint = 0;
         for each(_loc5_ in this)
         {
            if(this.championAvailableToBeRandomed(_loc5_))
            {
               if(_loc4_ == _loc3_)
               {
                  return _loc5_.champion;
               }
               _loc4_++;
            }
         }
         return null;
      }
      
      override public function set filterFunction(param1:Function) : void
      {
         this._customFilterFunction = param1;
         super.filterFunction = this.championFilterFunction;
      }
      
      public function get customFilterFunction() : Function
      {
         return this._customFilterFunction;
      }
      
      private function createNameSort() : Sort
      {
         var _loc1_:Sort = new Sort();
         if(null != this.championFilter)
         {
            _loc1_.compareFunction = this.championFilter.sortByDisplayName;
         }
         return _loc1_;
      }
      
      public function set ownedByMyTeam(param1:Boolean) : void
      {
         if(this._ownedByMyTeam != param1)
         {
            this._ownedByMyTeam = param1;
         }
      }
      
      public function get rentedExpired() : Boolean
      {
         return this._rentedExpired;
      }
      
      private function createRandomChampion() : Champion
      {
         var _loc1_:Champion = new Champion();
         _loc1_.setAsRandomChampion();
         _loc1_.displayName = RiotResourceLoader.getString("championSelection_randomChampion_displayName");
         return _loc1_;
      }
      
      private function championAvailableToBeRandomed(param1:ParticipantChampionSelection) : Boolean
      {
         return param1.participant == null && !param1.champion.isRandomChampion() && !param1.banned && !param1.disabledForGame && Boolean(param1.champion.active) && Boolean(param1.champion.isAvailable(this._allowFreeChampions));
      }
      
      public function set ownedByEitherTeam(param1:Boolean) : void
      {
         if(this._ownedByEitherTeam != param1)
         {
            this._ownedByEitherTeam = param1;
         }
      }
   }
}


package com.riotgames.pvpnet.matchhistoryiron.model
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.gameItems.model.GameItem;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.PlayerGameStats;
   import com.riotgames.platform.gameclient.domain.Spell;
   
   public class MatchHistoryStatModel
   {
      
      private var _stat:PlayerGameStats;
      
      private var _champion:Champion;
      
      private var _goldScore:String;
      
      private var _killScore:int;
      
      private var _deathScore:int;
      
      private var _assistScore:int;
      
      private var _minionKilled:int;
      
      private var _dominionScore:int;
      
      private var _captureScore:int;
      
      private var _neutralizedScore:int;
      
      private var _duration:int;
      
      private var _dominionRank:int;
      
      private var _isVictory:Boolean;
      
      private var _itemList:Vector.<GameItem>;
      
      private var _teamList:Vector.<MatchHistoryPlayerModel>;
      
      private var _otherTeamList:Vector.<MatchHistoryPlayerModel>;
      
      private var _statRendererModelList:Vector.<MatchHistoryStatRendererModel>;
      
      private var _spellCast1:Spell;
      
      private var _spellCast2:Spell;
      
      private var _onReady:Signal;
      
      private var _isReady:Boolean = false;
      
      public function MatchHistoryStatModel()
      {
         super();
         this._onReady = new Signal();
      }
      
      public function setAsReady() : void
      {
         this._isReady = true;
         this._onReady.dispatch(this);
      }
      
      public function get stat() : PlayerGameStats
      {
         return this._stat;
      }
      
      public function set stat(param1:PlayerGameStats) : void
      {
         this._stat = param1;
      }
      
      public function set goldScore(param1:String) : void
      {
         this._goldScore = param1;
      }
      
      public function get goldScore() : String
      {
         return this._goldScore;
      }
      
      public function get killScore() : int
      {
         return this._killScore;
      }
      
      public function set killScore(param1:int) : void
      {
         this._killScore = param1;
      }
      
      public function get deathScore() : int
      {
         return this._deathScore;
      }
      
      public function set deathScore(param1:int) : void
      {
         this._deathScore = param1;
      }
      
      public function get assistScore() : int
      {
         return this._assistScore;
      }
      
      public function set assistScore(param1:int) : void
      {
         this._assistScore = param1;
      }
      
      public function get minionKilled() : int
      {
         return this._minionKilled;
      }
      
      public function set minionKilled(param1:int) : void
      {
         this._minionKilled = param1;
      }
      
      public function get isVictory() : Boolean
      {
         return this._isVictory;
      }
      
      public function set isVictory(param1:Boolean) : void
      {
         this._isVictory = param1;
      }
      
      public function get spellCast1() : Spell
      {
         return this._spellCast1;
      }
      
      public function set spellCast1(param1:Spell) : void
      {
         this._spellCast1 = param1;
      }
      
      public function get spellCast2() : Spell
      {
         return this._spellCast2;
      }
      
      public function set spellCast2(param1:Spell) : void
      {
         this._spellCast2 = param1;
      }
      
      public function get itemList() : Vector.<GameItem>
      {
         return this._itemList;
      }
      
      public function set itemList(param1:Vector.<GameItem>) : void
      {
         this._itemList = param1;
      }
      
      public function get teamList() : Vector.<MatchHistoryPlayerModel>
      {
         return this._teamList;
      }
      
      public function set teamList(param1:Vector.<MatchHistoryPlayerModel>) : void
      {
         this._teamList = param1;
      }
      
      public function get otherTeamList() : Vector.<MatchHistoryPlayerModel>
      {
         return this._otherTeamList;
      }
      
      public function set otherTeamList(param1:Vector.<MatchHistoryPlayerModel>) : void
      {
         this._otherTeamList = param1;
      }
      
      public function get champion() : Champion
      {
         return this._champion;
      }
      
      public function set champion(param1:Champion) : void
      {
         this._champion = param1;
      }
      
      public function get duration() : int
      {
         return this._duration;
      }
      
      public function set duration(param1:int) : void
      {
         this._duration = param1;
      }
      
      public function get onReady() : ISignal
      {
         return this._onReady;
      }
      
      public function get isReady() : Boolean
      {
         return this._isReady;
      }
      
      public function set isReady(param1:Boolean) : void
      {
         this._isReady = param1;
      }
      
      public function get dominionScore() : int
      {
         return this._dominionScore;
      }
      
      public function set dominionScore(param1:int) : void
      {
         this._dominionScore = param1;
      }
      
      public function get captureScore() : int
      {
         return this._captureScore;
      }
      
      public function set captureScore(param1:int) : void
      {
         this._captureScore = param1;
      }
      
      public function get neutralizedScore() : int
      {
         return this._neutralizedScore;
      }
      
      public function set neutralizedScore(param1:int) : void
      {
         this._neutralizedScore = param1;
      }
      
      public function get dominionRank() : int
      {
         return this._dominionRank;
      }
      
      public function set dominionRank(param1:int) : void
      {
         this._dominionRank = param1;
      }
      
      public function get statRendererModelList() : Vector.<MatchHistoryStatRendererModel>
      {
         return this._statRendererModelList;
      }
      
      public function set statRendererModelList(param1:Vector.<MatchHistoryStatRendererModel>) : void
      {
         this._statRendererModelList = param1;
      }
      
      public function get isLocalSummoner() : Boolean
      {
         return this.stat.userId == Session.instance.summoner.sumId;
      }
   }
}


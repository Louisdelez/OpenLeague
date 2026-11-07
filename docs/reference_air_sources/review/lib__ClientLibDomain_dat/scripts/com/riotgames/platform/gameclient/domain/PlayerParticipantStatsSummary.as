package com.riotgames.platform.gameclient.domain
{
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamInfo;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.getQualifiedClassName;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   [RemoteClass(alias="com.riotgames.platform.statistics.PlayerParticipantStatsSummary")]
   public class PlayerParticipantStatsSummary implements IEventDispatcher
   {
      
      private var _1106736996leaves:Number;
      
      private var _1405834120botPlayer:Boolean;
      
      private var _100520elo:int;
      
      private var _3649559wins:Number;
      
      private var _3241058isMe:Boolean = false;
      
      private var _1599104296_summonerName:String;
      
      private var _1185220067inChat:Boolean = false;
      
      private var _1106736997leaver:Boolean;
      
      private var _gameItems:ArrayCollection;
      
      private var _1668897621teamInfo:TeamInfo;
      
      private var _1909092390numItems:Number;
      
      private var _1173460360eloChange:int;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var _1096968431losses:Number;
      
      private var _877713320teamId:Number;
      
      private var _2124524859spell2Id:Number;
      
      private var _1797213037reportEnabled:Boolean = true;
      
      private var _102865796level:Number;
      
      private var _1359356291profileIconId:int;
      
      private var _1253236563gameId:Number;
      
      private var _statistics:ArrayCollection;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _2124525820spell1Id:Number;
      
      private var _2143407528skinName:String;
      
      private var _1483641405kudosEnabled:Boolean = true;
      
      private var _836030906userId:Number;
      
      public function PlayerParticipantStatsSummary()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get spell1Id() : Number
      {
         return this._2124525820spell1Id;
      }
      
      public function set level(param1:Number) : void
      {
         var _loc2_:Object = this._102865796level;
         if(_loc2_ !== param1)
         {
            this._102865796level = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"level",_loc2_,param1));
         }
      }
      
      public function set spell1Id(param1:Number) : void
      {
         var _loc2_:Object = this._2124525820spell1Id;
         if(_loc2_ !== param1)
         {
            this._2124525820spell1Id = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"spell1Id",_loc2_,param1));
         }
      }
      
      public function set botPlayer(param1:Boolean) : void
      {
         var _loc2_:Object = this._1405834120botPlayer;
         if(_loc2_ !== param1)
         {
            this._1405834120botPlayer = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"botPlayer",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get losses() : Number
      {
         return this._1096968431losses;
      }
      
      [Bindable(event="propertyChange")]
      public function get wins() : Number
      {
         return this._3649559wins;
      }
      
      private function set _504377593summonerName(param1:String) : void
      {
         this._summonerName = param1;
      }
      
      public function set losses(param1:Number) : void
      {
         var _loc2_:Object = this._1096968431losses;
         if(_loc2_ !== param1)
         {
            this._1096968431losses = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"losses",_loc2_,param1));
         }
      }
      
      public function get statistics() : ArrayCollection
      {
         return this._statistics;
      }
      
      [Bindable(event="propertyChange")]
      public function get inChat() : Boolean
      {
         return this._1185220067inChat;
      }
      
      public function set wins(param1:Number) : void
      {
         var _loc2_:Object = this._3649559wins;
         if(_loc2_ !== param1)
         {
            this._3649559wins = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"wins",_loc2_,param1));
         }
      }
      
      public function set leaver(param1:Boolean) : void
      {
         var _loc2_:Object = this._1106736997leaver;
         if(_loc2_ !== param1)
         {
            this._1106736997leaver = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"leaver",_loc2_,param1));
         }
      }
      
      public function set leaves(param1:Number) : void
      {
         var _loc2_:Object = this._1106736996leaves;
         if(_loc2_ !== param1)
         {
            this._1106736996leaves = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"leaves",_loc2_,param1));
         }
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function set inChat(param1:Boolean) : void
      {
         var _loc2_:Object = this._1185220067inChat;
         if(_loc2_ !== param1)
         {
            this._1185220067inChat = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"inChat",_loc2_,param1));
         }
      }
      
      private function set _94588637statistics(param1:ArrayCollection) : void
      {
         this._statistics = param1;
         this.convertRawStatDTOsToPlayerStats(this._statistics);
         this.findItems();
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      private function convertRawStatDTOsToPlayerStats(param1:ArrayCollection) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            if(param1[_loc2_] is RawStatDTO)
            {
               param1[_loc2_] = new PlayerStat((param1[_loc2_] as RawStatDTO).statTypeName,(param1[_loc2_] as RawStatDTO).value);
            }
            _loc2_++;
         }
      }
      
      public function set skinName(param1:String) : void
      {
         var _loc2_:Object = this._2143407528skinName;
         if(_loc2_ !== param1)
         {
            this._2143407528skinName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"skinName",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get userId() : Number
      {
         return this._836030906userId;
      }
      
      public function set teamInfo(param1:TeamInfo) : void
      {
         var _loc2_:Object = this._1668897621teamInfo;
         if(_loc2_ !== param1)
         {
            this._1668897621teamInfo = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"teamInfo",_loc2_,param1));
         }
      }
      
      public function set elo(param1:int) : void
      {
         var _loc2_:Object = this._100520elo;
         if(_loc2_ !== param1)
         {
            this._100520elo = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"elo",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get teamId() : Number
      {
         return this._877713320teamId;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      [Bindable(event="propertyChange")]
      public function set statistics(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this.statistics;
         if(_loc2_ !== param1)
         {
            this._94588637statistics = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"statistics",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get isMe() : Boolean
      {
         return this._3241058isMe;
      }
      
      public function set gameId(param1:Number) : void
      {
         var _loc2_:Object = this._1253236563gameId;
         if(_loc2_ !== param1)
         {
            this._1253236563gameId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameId",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get reportEnabled() : Boolean
      {
         return this._1797213037reportEnabled;
      }
      
      [Bindable(event="propertyChange")]
      public function get eloChange() : int
      {
         return this._1173460360eloChange;
      }
      
      [Bindable(event="propertyChange")]
      public function get profileIconId() : int
      {
         return this._1359356291profileIconId;
      }
      
      public function isBotPlayer() : Boolean
      {
         return this.botPlayer;
      }
      
      public function set kudosEnabled(param1:Boolean) : void
      {
         var _loc2_:Object = this._1483641405kudosEnabled;
         if(_loc2_ !== param1)
         {
            this._1483641405kudosEnabled = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"kudosEnabled",_loc2_,param1));
         }
      }
      
      private function findItems() : void
      {
         var _loc2_:PlayerStat = null;
         this._gameItems = new ArrayCollection();
         if(isNaN(this.numItems))
         {
            this.numItems = 7;
         }
         var _loc1_:Number = 0;
         while(_loc1_ < this.numItems)
         {
            _loc2_ = PlayerStat.findStat("ITEM" + _loc1_,this._statistics);
            if(_loc2_ != null && _loc2_.value > 0)
            {
               this.gameItems.addItem(_loc2_.value);
            }
            _loc1_++;
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get botPlayer() : Boolean
      {
         return this._1405834120botPlayer;
      }
      
      public function set spell2Id(param1:Number) : void
      {
         var _loc2_:Object = this._2124524859spell2Id;
         if(_loc2_ !== param1)
         {
            this._2124524859spell2Id = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"spell2Id",_loc2_,param1));
         }
      }
      
      public function set userId(param1:Number) : void
      {
         var _loc2_:Object = this._836030906userId;
         if(_loc2_ !== param1)
         {
            this._836030906userId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"userId",_loc2_,param1));
         }
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get level() : Number
      {
         return this._102865796level;
      }
      
      [Bindable(event="propertyChange")]
      public function get leaver() : Boolean
      {
         return this._1106736997leaver;
      }
      
      [Bindable(event="propertyChange")]
      public function get leaves() : Number
      {
         return this._1106736996leaves;
      }
      
      public function updateSummary(param1:String, param2:String, param3:int, param4:int, param5:int, param6:int) : PlayerParticipantStatsSummary
      {
         this.summonerName = param1;
         this.level = param3;
         this.skinName = param2;
         return this;
      }
      
      [Bindable(event="propertyChange")]
      public function get skinName() : String
      {
         return this._2143407528skinName;
      }
      
      [Bindable(event="propertyChange")]
      public function get teamInfo() : TeamInfo
      {
         return this._1668897621teamInfo;
      }
      
      [Bindable(event="propertyChange")]
      public function get gameId() : Number
      {
         return this._1253236563gameId;
      }
      
      [Bindable(event="propertyChange")]
      public function get elo() : int
      {
         return this._100520elo;
      }
      
      public function set _summonerName(param1:String) : void
      {
         var _loc2_:Object = this._1599104296_summonerName;
         if(_loc2_ !== param1)
         {
            this._1599104296_summonerName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_summonerName",_loc2_,param1));
         }
      }
      
      public function set teamId(param1:Number) : void
      {
         var _loc2_:Object = this._877713320teamId;
         if(_loc2_ !== param1)
         {
            this._877713320teamId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"teamId",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get kudosEnabled() : Boolean
      {
         return this._1483641405kudosEnabled;
      }
      
      [Bindable(event="propertyChange")]
      public function get spell2Id() : Number
      {
         return this._2124524859spell2Id;
      }
      
      public function set isMe(param1:Boolean) : void
      {
         var _loc2_:Object = this._3241058isMe;
         if(_loc2_ !== param1)
         {
            this._3241058isMe = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isMe",_loc2_,param1));
         }
      }
      
      public function get teamTagText() : String
      {
         if(Boolean(this.teamInfo))
         {
            return "[" + this.teamInfo.tag + "] ";
         }
         return "";
      }
      
      public function set numItems(param1:Number) : void
      {
         var _loc2_:Object = this._1909092390numItems;
         if(_loc2_ !== param1)
         {
            this._1909092390numItems = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"numItems",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get _summonerName() : String
      {
         return this._1599104296_summonerName;
      }
      
      public function set reportEnabled(param1:Boolean) : void
      {
         var _loc2_:Object = this._1797213037reportEnabled;
         if(_loc2_ !== param1)
         {
            this._1797213037reportEnabled = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"reportEnabled",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get numItems() : Number
      {
         return this._1909092390numItems;
      }
      
      public function get gameItems() : ArrayCollection
      {
         return this._gameItems;
      }
      
      public function set eloChange(param1:int) : void
      {
         var _loc2_:Object = this._1173460360eloChange;
         if(_loc2_ !== param1)
         {
            this._1173460360eloChange = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"eloChange",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set summonerName(param1:String) : void
      {
         var _loc2_:Object = this.summonerName;
         if(_loc2_ !== param1)
         {
            this._504377593summonerName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerName",_loc2_,param1));
         }
      }
      
      public function get summonerName() : String
      {
         if(!this.isBotPlayer())
         {
            return this._summonerName;
         }
         return RiotResourceLoader.getChampionResourceString("name",this._summonerName,"**Unknown");
      }
      
      public function set profileIconId(param1:int) : void
      {
         var _loc2_:Object = this._1359356291profileIconId;
         if(_loc2_ !== param1)
         {
            this._1359356291profileIconId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"profileIconId",_loc2_,param1));
         }
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
   }
}


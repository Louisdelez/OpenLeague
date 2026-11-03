package com.riotgames.platform.gameclient.chat.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class PresenceStatusData implements IEventDispatcher
   {
      
      public var dropInSpectateId:String;
      
      public var featuredGameData:String;
      
      public var skinname:String;
      
      private var _172704580rankedLosses:int;
      
      private var _2070216145statusMsg:String;
      
      public var isGameObservable:String;
      
      private var _1844818161odinWins:int;
      
      private var _424427300rankedLeagueTier:String;
      
      private var _102865796level:int;
      
      private var _2030596687rankedQueueName:String;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _13838520rankedRating:int;
      
      private var _1852403033rankedLeagueDivision:String;
      
      private var _1769142708gameType:String;
      
      public var rankedSoloRestricted:Boolean;
      
      private var _3649559wins:int;
      
      private var _1750791887rankedLeagueQueueType:String;
      
      private var _3559906tier:String;
      
      public var queueType:String;
      
      private var _25573622timeStamp:Number;
      
      private var _1738687618rankedWins:int;
      
      private var _424613499rankedLeagueName:String;
      
      public var profileIconId:int;
      
      public function PresenceStatusData()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get rankedWins() : int
      {
         return this._1738687618rankedWins;
      }
      
      [Bindable(event="propertyChange")]
      public function get level() : int
      {
         return this._102865796level;
      }
      
      [Bindable(event="propertyChange")]
      public function get rankedLeagueName() : String
      {
         return this._424613499rankedLeagueName;
      }
      
      public function set rankedWins(param1:int) : void
      {
         var _loc2_:Object = this._1738687618rankedWins;
         if(_loc2_ !== param1)
         {
            this._1738687618rankedWins = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rankedWins",_loc2_,param1));
         }
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get wins() : int
      {
         return this._3649559wins;
      }
      
      public function set gameType(param1:String) : void
      {
         var _loc2_:Object = this._1769142708gameType;
         if(_loc2_ !== param1)
         {
            this._1769142708gameType = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameType",_loc2_,param1));
         }
      }
      
      public function set level(param1:int) : void
      {
         var _loc2_:Object = this._102865796level;
         if(_loc2_ !== param1)
         {
            this._102865796level = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"level",_loc2_,param1));
         }
      }
      
      public function set rankedLeagueName(param1:String) : void
      {
         var _loc2_:Object = this._424613499rankedLeagueName;
         if(_loc2_ !== param1)
         {
            this._424613499rankedLeagueName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rankedLeagueName",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rankedLeagueDivision() : String
      {
         return this._1852403033rankedLeagueDivision;
      }
      
      public function set rankedRating(param1:int) : void
      {
         var _loc2_:Object = this._13838520rankedRating;
         if(_loc2_ !== param1)
         {
            this._13838520rankedRating = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rankedRating",_loc2_,param1));
         }
      }
      
      public function set wins(param1:int) : void
      {
         var _loc2_:Object = this._3649559wins;
         if(_loc2_ !== param1)
         {
            this._3649559wins = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"wins",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get statusMsg() : String
      {
         return this._2070216145statusMsg;
      }
      
      [Bindable(event="propertyChange")]
      public function get rankedQueueName() : String
      {
         return this._2030596687rankedQueueName;
      }
      
      [Bindable(event="propertyChange")]
      public function get rankedLeagueQueueType() : String
      {
         return this._1750791887rankedLeagueQueueType;
      }
      
      public function set rankedLeagueTier(param1:String) : void
      {
         var _loc2_:Object = this._424427300rankedLeagueTier;
         if(_loc2_ !== param1)
         {
            this._424427300rankedLeagueTier = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rankedLeagueTier",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get tier() : String
      {
         return this._3559906tier;
      }
      
      [Bindable(event="propertyChange")]
      public function get rankedLosses() : int
      {
         return this._172704580rankedLosses;
      }
      
      [Bindable(event="propertyChange")]
      public function get gameType() : String
      {
         return this._1769142708gameType;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function set rankedLeagueDivision(param1:String) : void
      {
         var _loc2_:Object = this._1852403033rankedLeagueDivision;
         if(_loc2_ !== param1)
         {
            this._1852403033rankedLeagueDivision = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rankedLeagueDivision",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rankedRating() : int
      {
         return this._13838520rankedRating;
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function set tier(param1:String) : void
      {
         var _loc2_:Object = this._3559906tier;
         if(_loc2_ !== param1)
         {
            this._3559906tier = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tier",_loc2_,param1));
         }
      }
      
      public function set rankedLeagueQueueType(param1:String) : void
      {
         var _loc2_:Object = this._1750791887rankedLeagueQueueType;
         if(_loc2_ !== param1)
         {
            this._1750791887rankedLeagueQueueType = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rankedLeagueQueueType",_loc2_,param1));
         }
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function set statusMsg(param1:String) : void
      {
         var _loc2_:Object = this._2070216145statusMsg;
         if(_loc2_ !== param1)
         {
            this._2070216145statusMsg = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"statusMsg",_loc2_,param1));
         }
      }
      
      public function set odinWins(param1:int) : void
      {
         var _loc2_:Object = this._1844818161odinWins;
         if(_loc2_ !== param1)
         {
            this._1844818161odinWins = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"odinWins",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rankedLeagueTier() : String
      {
         return this._424427300rankedLeagueTier;
      }
      
      public function set rankedQueueName(param1:String) : void
      {
         var _loc2_:Object = this._2030596687rankedQueueName;
         if(_loc2_ !== param1)
         {
            this._2030596687rankedQueueName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rankedQueueName",_loc2_,param1));
         }
      }
      
      public function set timeStamp(param1:Number) : void
      {
         var _loc2_:Object = this._25573622timeStamp;
         if(_loc2_ !== param1)
         {
            this._25573622timeStamp = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"timeStamp",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get odinWins() : int
      {
         return this._1844818161odinWins;
      }
      
      [Bindable(event="propertyChange")]
      public function get timeStamp() : Number
      {
         return this._25573622timeStamp;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function set rankedLosses(param1:int) : void
      {
         var _loc2_:Object = this._172704580rankedLosses;
         if(_loc2_ !== param1)
         {
            this._172704580rankedLosses = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rankedLosses",_loc2_,param1));
         }
      }
   }
}


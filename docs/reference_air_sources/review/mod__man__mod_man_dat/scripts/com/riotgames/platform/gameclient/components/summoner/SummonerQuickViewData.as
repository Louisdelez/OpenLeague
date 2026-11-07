package com.riotgames.platform.gameclient.components.summoner
{
   import com.riotgames.platform.gameclient.buddyImages.BuddyImages;
   import com.riotgames.platform.gameclient.chat.controllers.PresenceController;
   import com.riotgames.platform.gameclient.chat.domain.PresenceStatusData;
   import com.riotgames.platform.gameclient.domain.invite.InviteParticipant;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   import org.igniterealtime.xiff.conference.RoomOccupant;
   
   public class SummonerQuickViewData implements IEventDispatcher
   {
      
      private var _504377593summonerName:String;
      
      private var _172704580rankedLosses:int;
      
      private var _501509644iconSource:Object;
      
      private var _1844818161odinWins:int;
      
      private var _424427300rankedLeagueTier:String;
      
      private var _102865796level:int;
      
      private var _13838520rankedRating:int = 0;
      
      private var _1852403033rankedLeagueDivision:String;
      
      private var _3649559wins:int;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _3559906tier:String;
      
      private var _2030394784rankedQueueType:String;
      
      private var _80971529summonerId:Number;
      
      private var _1738687618rankedWins:int;
      
      private var _424613499rankedLeagueName:String;
      
      public function SummonerQuickViewData()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get rankedWins() : int
      {
         return this._1738687618rankedWins;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
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
      
      public function set level(param1:int) : void
      {
         var _loc2_:Object = this._102865796level;
         if(_loc2_ !== param1)
         {
            this._102865796level = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"level",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get summonerId() : Number
      {
         return this._80971529summonerId;
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
      
      public function set rankedRating(param1:int) : void
      {
         var _loc2_:Object = this._13838520rankedRating;
         if(_loc2_ !== param1)
         {
            this._13838520rankedRating = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rankedRating",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get wins() : int
      {
         return this._3649559wins;
      }
      
      public function set summonerId(param1:Number) : void
      {
         var _loc2_:Object = this._80971529summonerId;
         if(_loc2_ !== param1)
         {
            this._80971529summonerId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerId",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rankedLeagueDivision() : String
      {
         return this._1852403033rankedLeagueDivision;
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
      
      public function fillSummonerData(param1:RoomOccupant, param2:InviteParticipant = null) : void
      {
         var _loc3_:PresenceStatusData = PresenceController.getPresenceData(param1.rosterItem.status);
         this.wins = _loc3_.wins;
         this.odinWins = _loc3_.odinWins;
         this.rankedQueueType = _loc3_.rankedQueueName;
         this.rankedWins = _loc3_.rankedWins;
         this.rankedLosses = _loc3_.rankedLosses;
         this.rankedRating = _loc3_.rankedRating;
         this.summonerId = parseInt(param1.jid.node.substring(3));
         this.summonerName = param1.displayName;
         this.iconSource = BuddyImages.getSummonerIconSafely(param2 ? int(param2.profileIconId) : int(_loc3_.profileIconId));
         this.tier = _loc3_.tier;
         this.level = _loc3_.level;
      }
      
      [Bindable(event="propertyChange")]
      public function get rankedLosses() : int
      {
         return this._172704580rankedLosses;
      }
      
      public function set rankedQueueType(param1:String) : void
      {
         var _loc2_:Object = this._2030394784rankedQueueType;
         if(_loc2_ !== param1)
         {
            this._2030394784rankedQueueType = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rankedQueueType",_loc2_,param1));
         }
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
      
      public function set rankedLeagueTier(param1:String) : void
      {
         var _loc2_:Object = this._424427300rankedLeagueTier;
         if(_loc2_ !== param1)
         {
            this._424427300rankedLeagueTier = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rankedLeagueTier",_loc2_,param1));
         }
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
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get rankedQueueType() : String
      {
         return this._2030394784rankedQueueType;
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
      
      public function set iconSource(param1:Object) : void
      {
         var _loc2_:Object = this._501509644iconSource;
         if(_loc2_ !== param1)
         {
            this._501509644iconSource = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"iconSource",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get odinWins() : int
      {
         return this._1844818161odinWins;
      }
      
      public function set summonerName(param1:String) : void
      {
         var _loc2_:Object = this._504377593summonerName;
         if(_loc2_ !== param1)
         {
            this._504377593summonerName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerName",_loc2_,param1));
         }
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
      
      [Bindable(event="propertyChange")]
      public function get summonerName() : String
      {
         return this._504377593summonerName;
      }
      
      [Bindable(event="propertyChange")]
      public function get tier() : String
      {
         return this._3559906tier;
      }
      
      [Bindable(event="propertyChange")]
      public function get iconSource() : Object
      {
         return this._501509644iconSource;
      }
   }
}


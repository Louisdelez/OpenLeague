package com.riotgames.platform.gameclient.domain
{
   import com.riotgames.platform.gameclient.domain.social.SummonerSocialNetworkUserId;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.summoner.Summoner")]
   public class Summoner extends BaseSummoner
   {
      
      public static const SUMMONER_INTERNAL_NAME_PREFIX:String = "sum";
      
      public static const TIER_UNRANKED:String = "UNRANKED";
      
      private var _1770591271nameChangeFlag:Boolean;
      
      private var _109797574sumId:Number;
      
      private var _1757632812advancedTutorialFlag:Boolean;
      
      private var _1507445162revisionId:Number;
      
      private var _1250970071revisionDate:Date;
      
      private var _790185395helpFlag:Boolean;
      
      private var _3241058isMe:Boolean;
      
      private var _192252332socialNetworkUserIds:ArrayCollection;
      
      private var _608550890tutorialFlag:Boolean;
      
      private var _871602060previousSeasonHighestTier:String;
      
      private var _804874102lastGameDate:Date;
      
      private var _953848601displayEloQuestionaire:Boolean;
      
      private var _2060623338previousSeasonHighestTeamReward:int;
      
      public function Summoner()
      {
         super();
      }
      
      public function set sumId(param1:Number) : void
      {
         var _loc2_:Object = this._109797574sumId;
         if(_loc2_ !== param1)
         {
            this._109797574sumId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"sumId",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get previousSeasonHighestTier() : String
      {
         return this._871602060previousSeasonHighestTier;
      }
      
      [Bindable(event="propertyChange")]
      public function get previousSeasonHighestTeamReward() : int
      {
         return this._2060623338previousSeasonHighestTeamReward;
      }
      
      public function set previousSeasonHighestTier(param1:String) : void
      {
         var _loc2_:Object = this._871602060previousSeasonHighestTier;
         if(_loc2_ !== param1)
         {
            this._871602060previousSeasonHighestTier = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"previousSeasonHighestTier",_loc2_,param1));
         }
      }
      
      public function set helpFlag(param1:Boolean) : void
      {
         var _loc2_:Object = this._790185395helpFlag;
         if(_loc2_ !== param1)
         {
            this._790185395helpFlag = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"helpFlag",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get nameChangeFlag() : Boolean
      {
         return this._1770591271nameChangeFlag;
      }
      
      [Bindable(event="propertyChange")]
      public function get revisionDate() : Date
      {
         return this._1250970071revisionDate;
      }
      
      [Bindable(event="propertyChange")]
      public function get socialNetworkUserIds() : ArrayCollection
      {
         return this._192252332socialNetworkUserIds;
      }
      
      public function set previousSeasonHighestTeamReward(param1:int) : void
      {
         var _loc2_:Object = this._2060623338previousSeasonHighestTeamReward;
         if(_loc2_ !== param1)
         {
            this._2060623338previousSeasonHighestTeamReward = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"previousSeasonHighestTeamReward",_loc2_,param1));
         }
      }
      
      public function set revisionId(param1:Number) : void
      {
         var _loc2_:Object = this._1507445162revisionId;
         if(_loc2_ !== param1)
         {
            this._1507445162revisionId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"revisionId",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get advancedTutorialFlag() : Boolean
      {
         return this._1757632812advancedTutorialFlag;
      }
      
      [Bindable(event="propertyChange")]
      public function get sumId() : Number
      {
         return this._109797574sumId;
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
      
      [Bindable(event="propertyChange")]
      public function get helpFlag() : Boolean
      {
         return this._790185395helpFlag;
      }
      
      public function set revisionDate(param1:Date) : void
      {
         var _loc2_:Object = this._1250970071revisionDate;
         if(_loc2_ !== param1)
         {
            this._1250970071revisionDate = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"revisionDate",_loc2_,param1));
         }
      }
      
      public function set tutorialFlag(param1:Boolean) : void
      {
         var _loc2_:Object = this._608550890tutorialFlag;
         if(_loc2_ !== param1)
         {
            this._608550890tutorialFlag = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tutorialFlag",_loc2_,param1));
         }
      }
      
      public function set displayEloQuestionaire(param1:Boolean) : void
      {
         var _loc2_:Object = this._953848601displayEloQuestionaire;
         if(_loc2_ !== param1)
         {
            this._953848601displayEloQuestionaire = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"displayEloQuestionaire",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get revisionId() : Number
      {
         return this._1507445162revisionId;
      }
      
      public function set socialNetworkUserIds(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._192252332socialNetworkUserIds;
         if(_loc2_ !== param1)
         {
            this._192252332socialNetworkUserIds = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"socialNetworkUserIds",_loc2_,param1));
         }
      }
      
      public function set nameChangeFlag(param1:Boolean) : void
      {
         var _loc2_:Object = this._1770591271nameChangeFlag;
         if(_loc2_ !== param1)
         {
            this._1770591271nameChangeFlag = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"nameChangeFlag",_loc2_,param1));
         }
      }
      
      public function getInternalName() : String
      {
         return Summoner.SUMMONER_INTERNAL_NAME_PREFIX + this.sumId.toString();
      }
      
      public function set advancedTutorialFlag(param1:Boolean) : void
      {
         var _loc2_:Object = this._1757632812advancedTutorialFlag;
         if(_loc2_ !== param1)
         {
            this._1757632812advancedTutorialFlag = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"advancedTutorialFlag",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get displayEloQuestionaire() : Boolean
      {
         return this._953848601displayEloQuestionaire;
      }
      
      [Bindable(event="propertyChange")]
      public function get isMe() : Boolean
      {
         return this._3241058isMe;
      }
      
      public function populate(param1:BasePublicSummonerDTO) : void
      {
         this.sumId = param1.sumId;
         this.acctId = param1.acctId;
         this.name = param1.name;
         this.internalName = param1.internalName;
         this.profileIconId = param1.profileIconId;
         this.previousSeasonHighestTier = param1.previousSeasonHighestTier;
      }
      
      public function set lastGameDate(param1:Date) : void
      {
         var _loc2_:Object = this._804874102lastGameDate;
         if(_loc2_ !== param1)
         {
            this._804874102lastGameDate = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lastGameDate",_loc2_,param1));
         }
      }
      
      public function getSocialNetworkUserId(param1:String) : Object
      {
         var _loc2_:SummonerSocialNetworkUserId = null;
         if(Boolean(this.socialNetworkUserIds))
         {
            for each(_loc2_ in this.socialNetworkUserIds)
            {
               if(_loc2_.network == param1)
               {
                  return _loc2_.networkUserId;
               }
            }
         }
         return null;
      }
      
      [Bindable(event="propertyChange")]
      public function get lastGameDate() : Date
      {
         return this._804874102lastGameDate;
      }
      
      [Bindable(event="propertyChange")]
      public function get tutorialFlag() : Boolean
      {
         return this._608550890tutorialFlag;
      }
   }
}


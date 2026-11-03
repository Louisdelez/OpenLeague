package com.riotgames.platform.gameclient.domain.rankedTeams
{
   import com.riotgames.platform.gameclient.domain.AbstractDomainObject;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.getTimer;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.team.dto.TeamDTO")]
   public class Team extends AbstractDomainObject implements IEventDispatcher
   {
      
      public static const MIN_SUMMONER_LEVEL_FOR_RANKED_TEAMS:Number = 30;
      
      public static const MAX_NUMBER_OF_MEMBERS:int = 9;
      
      public static const MAX_SIMULTANEOUS_INVITES:int = 3;
      
      public static const INACTIVE_WARNING_SECONDS:int = 60 * 60 * 24 * 7;
      
      public static const ONE_WEEK_IN_MILLISECONDS:int = 1000 * 60 * 60 * 24 * 7;
      
      public static const STATUS_ACTIVE:int = 0;
      
      public static const STATUS_PENDING_INACTIVE:int = 1;
      
      public static const STATUS_INACTIVE:int = 2;
      
      private var _892481550status:String;
      
      private var _3373707name:String;
      
      private var _1368729290createDate:Date;
      
      private var _1210904456modifyDate:Date;
      
      private var _1508348907teamStatSummary:TeamStatSummary;
      
      private var _968683201secondsUntilEligibleForDeletion:Number;
      
      private var _877713320teamId:TeamId;
      
      private var _2030302449matchHistory:ArrayCollection;
      
      private var localCreateTime:uint;
      
      private var _1172282542lastJoinDate:Date;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _114586tag:String;
      
      private var _804874102lastGameDate:Date;
      
      private var _925192565roster:Roster;
      
      private var _633395390secondLastJoinDate:Date;
      
      private var _450270133thirdLastJoinDate:Date;
      
      public function Team()
      {
         super();
         this.localCreateTime = getTimer();
      }
      
      public function set secondsUntilEligibleForDeletion(param1:Number) : void
      {
         var _loc2_:Object = this._968683201secondsUntilEligibleForDeletion;
         if(_loc2_ !== param1)
         {
            this._968683201secondsUntilEligibleForDeletion = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"secondsUntilEligibleForDeletion",_loc2_,param1));
         }
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function calculateFilledRosterSlots() : int
      {
         var _loc2_:TeamMemberInfo = null;
         var _loc1_:int = 0;
         for each(_loc2_ in this.roster.memberList)
         {
            if(_loc2_.status == TeamMemberStatus.MEMBER)
            {
               _loc1_++;
            }
         }
         return _loc1_;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get modifyDate() : Date
      {
         return this._1210904456modifyDate;
      }
      
      [Bindable(event="propertyChange")]
      public function get name() : String
      {
         return this._3373707name;
      }
      
      [Bindable(event="propertyChange")]
      public function get matchHistory() : ArrayCollection
      {
         return this._2030302449matchHistory;
      }
      
      public function set modifyDate(param1:Date) : void
      {
         var _loc2_:Object = this._1210904456modifyDate;
         if(_loc2_ !== param1)
         {
            this._1210904456modifyDate = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"modifyDate",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get roster() : Roster
      {
         return this._925192565roster;
      }
      
      public function set secondLastJoinDate(param1:Date) : void
      {
         var _loc2_:Object = this._633395390secondLastJoinDate;
         if(_loc2_ !== param1)
         {
            this._633395390secondLastJoinDate = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"secondLastJoinDate",_loc2_,param1));
         }
      }
      
      public function set createDate(param1:Date) : void
      {
         var _loc2_:Object = this._1368729290createDate;
         if(_loc2_ !== param1)
         {
            this._1368729290createDate = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"createDate",_loc2_,param1));
         }
      }
      
      public function calculateTotalGamesPlayed() : int
      {
         var _loc2_:TeamStatDetail = null;
         var _loc1_:int = 0;
         if(Boolean(this.teamStatSummary) && Boolean(this.teamStatSummary.teamStatDetails))
         {
            for each(_loc2_ in this.teamStatSummary.teamStatDetails)
            {
               _loc1_ += _loc2_.wins + _loc2_.losses;
            }
         }
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get tag() : String
      {
         return this._114586tag;
      }
      
      public function calculateNumRelevantJoinsInLastWeek() : int
      {
         var _loc1_:Date = new Date();
         var _loc2_:Number = _loc1_.getTime();
         var _loc3_:int = 0;
         if(this.lastJoinDate == null)
         {
            return _loc3_;
         }
         if(_loc2_ - this.lastJoinDate.getTime() < ONE_WEEK_IN_MILLISECONDS)
         {
            _loc3_++;
         }
         if(this.secondLastJoinDate == null)
         {
            return _loc3_;
         }
         if(_loc2_ - this.secondLastJoinDate.getTime() < ONE_WEEK_IN_MILLISECONDS)
         {
            _loc3_++;
         }
         if(this.thirdLastJoinDate == null)
         {
            return _loc3_;
         }
         if(_loc2_ - this.thirdLastJoinDate.getTime() < ONE_WEEK_IN_MILLISECONDS)
         {
            _loc3_++;
         }
         return _loc3_;
      }
      
      public function set name(param1:String) : void
      {
         var _loc2_:Object = this._3373707name;
         if(_loc2_ !== param1)
         {
            this._3373707name = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"name",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get teamStatSummary() : TeamStatSummary
      {
         return this._1508348907teamStatSummary;
      }
      
      public function set roster(param1:Roster) : void
      {
         var _loc2_:Object = this._925192565roster;
         if(_loc2_ !== param1)
         {
            this._925192565roster = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"roster",_loc2_,param1));
         }
      }
      
      public function set teamStatSummary(param1:TeamStatSummary) : void
      {
         var _loc2_:Object = this._1508348907teamStatSummary;
         if(_loc2_ !== param1)
         {
            this._1508348907teamStatSummary = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"teamStatSummary",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get lastJoinDate() : Date
      {
         return this._1172282542lastJoinDate;
      }
      
      public function getFormattedTag() : String
      {
         return "[" + this.tag + "]";
      }
      
      [Bindable(event="propertyChange")]
      public function get thirdLastJoinDate() : Date
      {
         return this._450270133thirdLastJoinDate;
      }
      
      public function set matchHistory(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._2030302449matchHistory;
         if(_loc2_ !== param1)
         {
            this._2030302449matchHistory = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"matchHistory",_loc2_,param1));
         }
      }
      
      public function set teamId(param1:TeamId) : void
      {
         var _loc2_:Object = this._877713320teamId;
         if(_loc2_ !== param1)
         {
            this._877713320teamId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"teamId",_loc2_,param1));
         }
      }
      
      public function calculateNumInvitesCurrentlyPending() : int
      {
         var _loc2_:TeamMemberInfo = null;
         var _loc1_:int = 0;
         for each(_loc2_ in this.roster.memberList)
         {
            if(_loc2_.status == TeamMemberStatus.INVITED)
            {
               _loc1_++;
            }
         }
         return _loc1_;
      }
      
      public function getInactivityStatus() : int
      {
         var _loc1_:int = this.calculateSecondsUntilEligibleForDeletion();
         if(_loc1_ <= 0)
         {
            return STATUS_INACTIVE;
         }
         if(_loc1_ <= INACTIVE_WARNING_SECONDS)
         {
            return STATUS_PENDING_INACTIVE;
         }
         return STATUS_ACTIVE;
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get secondsUntilEligibleForDeletion() : Number
      {
         return this._968683201secondsUntilEligibleForDeletion;
      }
      
      public function set tag(param1:String) : void
      {
         var _loc2_:Object = this._114586tag;
         if(_loc2_ !== param1)
         {
            this._114586tag = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tag",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get secondLastJoinDate() : Date
      {
         return this._633395390secondLastJoinDate;
      }
      
      [Bindable(event="propertyChange")]
      public function get createDate() : Date
      {
         return this._1368729290createDate;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      [Bindable(event="propertyChange")]
      public function get teamId() : TeamId
      {
         return this._877713320teamId;
      }
      
      public function calculateNextInvite() : Date
      {
         var _loc1_:Date = new Date();
         if(!this.thirdLastJoinDate || this.status == TeamStatus.PROVISIONAL)
         {
            return null;
         }
         var _loc2_:Number = this.thirdLastJoinDate.getTime() + ONE_WEEK_IN_MILLISECONDS;
         if(_loc2_ < _loc1_.getTime())
         {
            return null;
         }
         var _loc3_:Date = new Date();
         _loc3_.setTime(_loc2_);
         return _loc3_;
      }
      
      public function set lastJoinDate(param1:Date) : void
      {
         var _loc2_:Object = this._1172282542lastJoinDate;
         if(_loc2_ !== param1)
         {
            this._1172282542lastJoinDate = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lastJoinDate",_loc2_,param1));
         }
      }
      
      public function calculateInvitesAvailable() : int
      {
         var _loc1_:int = 0;
         if(this.status == TeamStatus.PROVISIONAL)
         {
            return this.calculateOpenRosterSlots() - this.calculateNumInvitesCurrentlyPending();
         }
         _loc1_ = MAX_SIMULTANEOUS_INVITES - this.calculateNumRelevantJoinsInLastWeek() - this.calculateNumInvitesCurrentlyPending();
         return Math.max(0,_loc1_);
      }
      
      public function set thirdLastJoinDate(param1:Date) : void
      {
         var _loc2_:Object = this._450270133thirdLastJoinDate;
         if(_loc2_ !== param1)
         {
            this._450270133thirdLastJoinDate = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"thirdLastJoinDate",_loc2_,param1));
         }
      }
      
      public function set status(param1:String) : void
      {
         var _loc2_:Object = this._892481550status;
         if(_loc2_ !== param1)
         {
            this._892481550status = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"status",_loc2_,param1));
         }
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
      
      [Bindable(event="propertyChange")]
      public function get lastGameDate() : Date
      {
         return this._804874102lastGameDate;
      }
      
      [Bindable(event="propertyChange")]
      public function get status() : String
      {
         return this._892481550status;
      }
      
      public function calculateOpenRosterSlots() : int
      {
         return MAX_NUMBER_OF_MEMBERS - this.calculateFilledRosterSlots();
      }
      
      public function calculateSecondsUntilEligibleForDeletion() : Number
      {
         var _loc1_:uint = uint(getTimer());
         var _loc2_:Number = (_loc1_ - this.localCreateTime) * 0.001;
         return Math.max(0,this.secondsUntilEligibleForDeletion - _loc2_);
      }
   }
}


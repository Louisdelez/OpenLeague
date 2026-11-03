package com.riotgames.platform.gameclient.module.rt.model
{
   import blix.signals.Signal;
   import com.riotgames.platform.gameclient.domain.rankedTeams.Team;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamMemberInfo;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamMemberStatus;
   import com.riotgames.platform.gameclient.module.rt.RTFacade;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   import org.puremvc.as3.multicore.patterns.proxy.Proxy;
   
   public class ProfileTeamProxy extends Proxy implements IEventDispatcher
   {
      
      public static const NAME:String = "ProfileTeamProxy";
      
      public static const PROFILE_TEAM_CHANGE:String = "PROFILE_TEAM_CHANGE";
      
      private var _isDataOnly:Boolean = false;
      
      private var _teamLoaded:Signal = new Signal();
      
      private var _isViewExternal:Boolean = false;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _team:Team;
      
      public function ProfileTeamProxy(param1:String = "ProfileTeamProxy", param2:Object = null)
      {
         super(param1,param2);
      }
      
      public static function findLocalMember(param1:Team) : TeamMemberInfo
      {
         var _loc3_:TeamMemberInfo = null;
         var _loc2_:TeamMemberInfo = null;
         if(Boolean(param1) && Boolean(RTFacade.playerProxy.localPlayer()))
         {
            for each(_loc3_ in param1.roster.memberList)
            {
               if(_loc3_.playerId == RTFacade.playerProxy.localPlayer().playerId)
               {
                  _loc2_ = _loc3_;
                  break;
               }
            }
         }
         return _loc2_;
      }
      
      private static function get profilePlayerProxy() : ProfilePlayerProxy
      {
         return RTFacade.instance.retrieveProxy(ProfilePlayerProxy.NAME) as ProfilePlayerProxy;
      }
      
      public static function findOwnerCandidates(param1:Team) : ArrayCollection
      {
         var _loc3_:TeamMemberInfo = null;
         var _loc2_:ArrayCollection = new ArrayCollection();
         for each(_loc3_ in param1.roster.memberList)
         {
            if(_loc3_.playerId != param1.roster.ownerId && _loc3_.status == TeamMemberStatus.MEMBER)
            {
               _loc2_.addItem(_loc3_);
            }
         }
         return _loc2_;
      }
      
      public static function countTeamMembers(param1:Team) : uint
      {
         var _loc3_:TeamMemberInfo = null;
         var _loc2_:uint = 0;
         if(param1)
         {
            for each(_loc3_ in param1.roster.memberList)
            {
               if(_loc3_.status == TeamMemberStatus.MEMBER)
               {
                  _loc2_++;
               }
            }
         }
         return _loc2_;
      }
      
      public function get isDataOnly() : Boolean
      {
         return this._isDataOnly;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function set teamLoaded(param1:Signal) : void
      {
         this._teamLoaded = param1;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function set isDataOnly(param1:Boolean) : void
      {
         this._isDataOnly = param1;
      }
      
      public function get teamLoaded() : Signal
      {
         return this._teamLoaded;
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function get teamProxy() : TeamProxy
      {
         return facade.retrieveProxy(TeamProxy.NAME) as TeamProxy;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function get isViewExternal() : Boolean
      {
         return this._isViewExternal;
      }
      
      public function refresh() : void
      {
         this.teamProxy.showTeamById(this.team.teamId,true);
      }
      
      public function get team() : Team
      {
         return this._team;
      }
      
      private function set _3555933team(param1:Team) : void
      {
         var _loc2_:Boolean = true;
         if(this._team == null && param1 == null)
         {
            _loc2_ = false;
         }
         else if(this.team != null && param1 != null && Boolean(this.team.teamId.Compare(param1.teamId)))
         {
            _loc2_ = false;
         }
         this._team = param1;
         this._teamLoaded.dispatch(this._team);
         if(!this._isDataOnly)
         {
            sendNotification(PROFILE_TEAM_CHANGE,_loc2_);
         }
      }
      
      public function set isViewExternal(param1:Boolean) : void
      {
         this._isViewExternal = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function set team(param1:Team) : void
      {
         var _loc2_:Object = this.team;
         if(_loc2_ !== param1)
         {
            this._3555933team = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"team",_loc2_,param1));
         }
      }
   }
}


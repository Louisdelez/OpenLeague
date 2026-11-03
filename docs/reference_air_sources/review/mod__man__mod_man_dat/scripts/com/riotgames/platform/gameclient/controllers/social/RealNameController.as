package com.riotgames.platform.gameclient.controllers.social
{
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.chat.controllers.INameController;
   import com.riotgames.platform.gameclient.domain.SummonerSummary;
   import com.riotgames.platform.gameclient.domain.social.SocialNetworkCache;
   import com.riotgames.platform.gameclient.domain.social.SocialNetworkContact;
   import com.riotgames.platform.gameclient.domain.social.SocialNetworkSummonerDTO;
   import com.riotgames.platform.gameclient.domain.social.SocialNetworkUserDTO;
   import com.riotgames.platform.gameclient.domain.social.SummonerSocialNetworkUserId;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import mx.collections.ArrayCollection;
   import mx.events.CollectionEvent;
   import mx.events.PropertyChangeEvent;
   import mx.rpc.events.ResultEvent;
   import org.igniterealtime.xiff.data.im.RosterItemVO;
   import org.igniterealtime.xiff.events.RosterEvent;
   import org.igniterealtime.xiff.im.Roster;
   
   public class RealNameController implements INameController, IEventDispatcher
   {
      
      private var _1840095445nameData:ArrayCollection;
      
      private var dataDirty:Boolean = false;
      
      private var saveTimer:Timer;
      
      public var serviceProxy:ServiceProxy;
      
      [Inject]
      public var chatController:ChatController;
      
      public var session:Session;
      
      private var clientConfig:ClientConfig;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function RealNameController()
      {
         super();
         this.serviceProxy = ServiceProxy.instance;
         this.session = Session.instance;
         this.clientConfig = ClientConfig.instance;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      private function get roster() : Roster
      {
         return this.chatController.roster;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function resolveContactList(param1:ArrayCollection) : void
      {
         var _loc2_:SocialNetworkContact = null;
         var _loc3_:SocialNetworkContact = null;
         for each(_loc2_ in param1)
         {
            _loc3_ = this.getContactByNetworkId(_loc2_.network,_loc2_.networkId);
            if(_loc3_)
            {
               _loc2_.invited = _loc3_.invited;
            }
         }
      }
      
      private function onSocialNetworkFriendsRetrieved(param1:ResultEvent) : void
      {
         var _loc4_:SocialNetworkUserDTO = null;
         var _loc5_:SocialNetworkContact = null;
         if(!this.nameData)
         {
            this.nameData = new ArrayCollection();
         }
         this.nameData.removeAll();
         var _loc2_:ArrayCollection = param1.result as ArrayCollection;
         var _loc3_:int = 0;
         for each(_loc4_ in _loc2_)
         {
            _loc5_ = new SocialNetworkContact();
            _loc5_.displayName = _loc4_.realName;
            _loc5_.networkId = _loc4_.networkUserId;
            _loc5_.hashedNetworkId = _loc4_.hashedNetworkUserId;
            _loc5_.network = _loc4_.network;
            _loc5_.invited = _loc4_.invitedTime;
            _loc5_.summoners = _loc4_.summoners;
            this.nameData.addItem(_loc5_);
         }
         this.updateRoster();
      }
      
      [PostConstruct]
      public function initialize() : void
      {
         this.chatController.addEventListener(RosterEvent.ROSTER_LOADED,this.onRosterLoaded);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      private function onRosterChange(param1:CollectionEvent) : void
      {
         this.updateRoster();
      }
      
      public function getContactByHashedNetworkId(param1:String, param2:String) : SocialNetworkContact
      {
         var _loc3_:SocialNetworkContact = null;
         for each(_loc3_ in this.nameData)
         {
            if(_loc3_.network == param1 && _loc3_.hashedNetworkId == param2)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      [Bindable(event="propertyChange")]
      public function get nameData() : ArrayCollection
      {
         return this._1840095445nameData;
      }
      
      public function getContactByNetworkId(param1:String, param2:String) : SocialNetworkContact
      {
         var _loc3_:SocialNetworkContact = null;
         for each(_loc3_ in this.nameData)
         {
            if(_loc3_.network == param1 && _loc3_.networkId == param2)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      private function internalSave(param1:TimerEvent) : void
      {
         var _loc2_:SocialNetworkCache = null;
         if(this.dataDirty)
         {
            _loc2_ = new SocialNetworkCache();
            _loc2_.contacts = this.nameData;
            this.serviceProxy.summonerService.saveSocialNetworkFriendList(_loc2_.getContactIds(),_loc2_.getInviteTimes(),"Facebook",null,null,null);
            this.dataDirty = false;
         }
         if(this.saveTimer)
         {
            this.saveTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.internalSave);
            this.saveTimer.stop();
            this.saveTimer = null;
         }
      }
      
      public function cleanup() : void
      {
         this.chatController.removeEventListener(RosterEvent.ROSTER_LOADED,this.onRosterLoaded);
         if(this.roster)
         {
            this.roster.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.onRosterChange);
         }
      }
      
      public function set nameData(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1840095445nameData;
         if(_loc2_ !== param1)
         {
            this._1840095445nameData = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"nameData",_loc2_,param1));
         }
      }
      
      private function onRosterLoaded(param1:Event) : void
      {
         if(this.roster)
         {
            this.roster.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onRosterChange);
         }
         if(this.nameData)
         {
            this.updateRoster();
         }
         else
         {
            this.retrieveNameData();
         }
      }
      
      private function retrieveNameData() : void
      {
         var _loc1_:Boolean = this.session.summoner.socialNetworkUserIds != null && this.session.summoner.socialNetworkUserIds.length > 0;
         if(Boolean(this.clientConfig.socialIntegrationEnabled) && _loc1_)
         {
            this.serviceProxy.summonerService.getSocialNetworkFriends(this.onSocialNetworkFriendsRetrieved,null,null);
         }
      }
      
      private function saveNameData() : void
      {
         this.dataDirty = true;
         if(!this.saveTimer)
         {
            this.saveTimer = new Timer(500,1);
            this.saveTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.internalSave);
            this.saveTimer.start();
         }
      }
      
      private function updateRoster() : void
      {
         var _loc1_:SocialNetworkContact = null;
         var _loc2_:SocialNetworkSummonerDTO = null;
         var _loc3_:RosterItemVO = null;
         if(this.nameData)
         {
            for each(_loc1_ in this.nameData)
            {
               if(_loc1_.summoners != null && _loc1_.summoners.length > 0)
               {
                  for each(_loc2_ in _loc1_.summoners)
                  {
                     _loc3_ = this.chatController.getBuddyBySummonerId(_loc2_.sumId);
                     if(_loc3_)
                     {
                        _loc3_.localUserData = _loc1_;
                     }
                  }
               }
            }
         }
      }
      
      public function attemptToConnectSummoner(param1:SummonerSummary) : SocialNetworkContact
      {
         var _loc2_:SummonerSocialNetworkUserId = null;
         var _loc3_:SocialNetworkContact = null;
         var _loc4_:SocialNetworkSummonerDTO = null;
         if(!this.nameData || !param1.socialNetworkUserIds)
         {
            return null;
         }
         for each(_loc2_ in param1.socialNetworkUserIds)
         {
            _loc3_ = this.getContactByHashedNetworkId(_loc2_.network,_loc2_.networkUserId.toString());
            if(_loc3_)
            {
               _loc4_ = new SocialNetworkSummonerDTO();
               _loc4_.name = param1.name;
               _loc4_.sumId = parseInt(param1.internalName.substr(3));
               _loc4_.internalName = param1.internalName;
               if(_loc3_.addSummonerIfMissing(_loc4_))
               {
                  this.saveNameData();
               }
               return _loc3_;
            }
         }
         return null;
      }
      
      public function friendListUpdated(param1:ArrayCollection) : void
      {
         this.nameData = param1;
         this.saveNameData();
         this.updateRoster();
      }
   }
}


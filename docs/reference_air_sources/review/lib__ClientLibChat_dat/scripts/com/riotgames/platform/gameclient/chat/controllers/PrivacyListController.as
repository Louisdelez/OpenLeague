package com.riotgames.platform.gameclient.chat.controllers
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.xmpp.data.privacy.PrivacyExtension;
   import com.riotgames.platform.common.xmpp.data.privacy.PrivacyList;
   import com.riotgames.platform.common.xmpp.data.privacy.PrivacyListItem;
   import com.riotgames.platform.common.xmpp.data.privacy.PrivacyListItemAction;
   import com.riotgames.platform.common.xmpp.data.privacy.PrivacyListItemType;
   import com.riotgames.platform.common.xmpp.privacy.PrivacyListNode;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.tracking.ICrossModuleTrackerProvider;
   import com.riotgames.pvpnet.tracking.trackers.friend.IFriendListBehaviorTracker;
   import flash.events.EventDispatcher;
   import flash.utils.getQualifiedClassName;
   import flash.xml.XMLNode;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.rpc.AsyncToken;
   import mx.rpc.events.ResultEvent;
   import mx.utils.StringUtil;
   import org.igniterealtime.xiff.core.EscapedJID;
   import org.igniterealtime.xiff.core.UnescapedJID;
   import org.igniterealtime.xiff.core.XMPPConnection;
   import org.igniterealtime.xiff.data.IQ;
   import org.igniterealtime.xiff.data.XMPPStanza;
   import org.igniterealtime.xiff.events.DisconnectionEvent;
   import org.igniterealtime.xiff.events.IQEvent;
   import org.igniterealtime.xiff.events.LoginEvent;
   
   public class PrivacyListController extends EventDispatcher
   {
      
      private static const DEFAULT_PRIVACY_LIST_NAME:String = "LOL";
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var _activePrivacyListChanged:Signal = new Signal();
      
      public var chatController:ChatController;
      
      private var _serviceProxy:ServiceProxy;
      
      private var _activePrivacyListUpdated:Signal = new Signal();
      
      private var _activePrivacyListInitialized:Signal = new Signal();
      
      private var isActive:Boolean;
      
      private var _friendTracker:IFriendListBehaviorTracker;
      
      private var _activePrivacyList:PrivacyList;
      
      public function PrivacyListController()
      {
         super();
         PrivacyExtension.enable();
         this.activePrivacyList = this.createPrivacyList();
         this.serviceProxy = ServiceProxy.instance;
      }
      
      private function onPrivacyListRetrieved(param1:IQ) : void
      {
         var _loc2_:PrivacyExtension = param1.getExtension(PrivacyExtension.ELEMENT) as PrivacyExtension;
         var _loc3_:PrivacyList = _loc2_.privacyListMap[DEFAULT_PRIVACY_LIST_NAME];
         if(Boolean(_loc3_))
         {
            this.activePrivacyList = _loc3_;
            this.retrieveSummonerNames(this.activePrivacyList);
         }
         this._activePrivacyListInitialized.dispatch();
      }
      
      private function savePrivacyList() : void
      {
         var _loc1_:IQ = new IQ(new EscapedJID(ClientConfig.JABBER_DOMAIN),IQ.SET_TYPE,XMPPStanza.generateID("privacy_"),null,null,this.onPrivacyListUpdated);
         var _loc2_:PrivacyExtension = new PrivacyExtension();
         var _loc3_:XMLNode = _loc2_.getNode();
         var _loc4_:PrivacyListNode = new PrivacyListNode(this.activePrivacyList.name,PrivacyListNode.LIST,this.activePrivacyList.items);
         _loc4_.serialize(_loc3_);
         _loc1_.addExtension(_loc2_);
         this.serviceProxy.chatService.getConnection().send(_loc1_);
      }
      
      public function logout() : void
      {
         this.activePrivacyList = null;
      }
      
      public function block(param1:String, param2:String) : Boolean
      {
         var _loc4_:PrivacyListItem = null;
         var _loc5_:String = null;
         var _loc3_:Boolean = false;
         if(this.canBlock(param1) && this.activePrivacyList != null)
         {
            _loc4_ = new PrivacyListItem();
            _loc4_.displayName = param2;
            _loc4_.action = PrivacyListItemAction.DENY;
            _loc4_.type = PrivacyListItemType.JID;
            _loc4_.value = param1;
            this.activePrivacyList.addPrivacyListItem(_loc4_);
            this.chatController.removeBuddyWithJID(new UnescapedJID(_loc4_.value));
            this.addPrivacyItems();
            _loc3_ = true;
            this._friendTracker.incrementFriendIgnored_InASession();
            _loc5_ = ResourceManager.getInstance().getString("resources","chat_buddyWindow_ignoreUserAlertMessage",[param2]);
            this.chatController.showPromptMessage("resources",_loc5_,"chat_ignoreUserWindow_title","PVP.NET","common_button_close");
         }
         return _loc3_;
      }
      
      private function getPrivacyList() : void
      {
         if(!this.activePrivacyList)
         {
            return;
         }
         var _loc1_:IQ = new IQ(new EscapedJID(ClientConfig.JABBER_DOMAIN),IQ.GET_TYPE,XMPPStanza.generateID("privacy_"),null,null,this.onPrivacyListRetrieved);
         var _loc2_:PrivacyExtension = new PrivacyExtension();
         var _loc3_:XMLNode = _loc2_.getNode();
         var _loc4_:PrivacyListNode = new PrivacyListNode(this.activePrivacyList.name);
         _loc4_.serialize(_loc3_);
         _loc1_.addExtension(_loc2_);
         this.serviceProxy.chatService.getConnection().send(_loc1_);
      }
      
      private function onConnectionDisconnect(param1:DisconnectionEvent) : void
      {
         this.isActive = false;
      }
      
      private function onBlockAndConfirmCompleted(param1:AlertAction) : void
      {
         var _loc2_:Boolean = false;
         if(param1.affirmativeResponse)
         {
            _loc2_ = this.block(param1.data.jid,param1.data.displayName);
            if(Boolean(param1.data.asyncObject))
            {
               param1.data.onConfirm.call(null,_loc2_,param1.data.asyncObject);
            }
            else
            {
               param1.data.onConfirm.call(null,_loc2_);
            }
         }
      }
      
      public function canBlock(param1:String) : Boolean
      {
         return this.isActive ? !this.isBlocked(param1) && !this.isMe(param1) : false;
      }
      
      private function onLoginCompleted(param1:LoginEvent) : void
      {
         this.isActive = true;
         this.getPrivacyList();
         ProviderLookup.getProvider(ICrossModuleTrackerProvider,this.onGetCrossModuleTrackerProvider);
      }
      
      public function unblock(param1:String) : Boolean
      {
         var _loc3_:PrivacyListItem = null;
         var _loc2_:Boolean = false;
         if(this.canUnblock(param1))
         {
            _loc3_ = this.activePrivacyList.getPrivacyItem(param1);
            if(_loc3_ != null)
            {
               this.activePrivacyList.removePrivacyListItem(_loc3_);
               this.removePrivacyItems();
               _loc2_ = true;
               this._friendTracker.incrementFriendUnignored_InASession();
            }
         }
         return _loc2_;
      }
      
      public function canUnblock(param1:String) : Boolean
      {
         return this.isActive ? this.isBlocked(param1) && !this.isMe(param1) : false;
      }
      
      public function isSummonerNameBlocked(param1:String) : Boolean
      {
         var _loc3_:PrivacyListItem = null;
         if(!this.isActive || !this.activePrivacyList || !this.activePrivacyList.items)
         {
            return false;
         }
         var _loc2_:String = param1.toLowerCase();
         for each(_loc3_ in this.activePrivacyList.items)
         {
            if(Boolean(_loc3_.displayName) && _loc2_ == _loc3_.displayName.toLowerCase())
            {
               return true;
            }
         }
         return false;
      }
      
      public function getActivePrivacyListChanged() : ISignal
      {
         return this._activePrivacyListChanged;
      }
      
      public function blockSummonerName(param1:String, param2:Boolean = false) : void
      {
         if(param1.length == 0)
         {
            return;
         }
         this.serviceProxy.summonerService.getSummonerInternalNameByName(param1,this.onSummonerInternalNameRetrievedForBlock,null,null,{
            "summonerName":param1,
            "confirmationRequired":param2
         });
      }
      
      public function blockSummonerNameAndConfirm(param1:String) : void
      {
         this.blockSummonerName(param1,true);
      }
      
      private function filterPrivacyItems(param1:PrivacyListItem) : Boolean
      {
         return Boolean(param1) && param1.action == "deny";
      }
      
      public function getActivePrivacyListUpdated() : ISignal
      {
         return this._activePrivacyListUpdated;
      }
      
      private function onServiceRequestComplete(param1:Boolean) : void
      {
      }
      
      private function onGetCrossModuleTrackerProvider(param1:ICrossModuleTrackerProvider) : void
      {
         this._friendTracker = param1.getFriendListBehaviorTracker();
      }
      
      private function onSummonerInternalNameRetrievedForBlock(param1:ResultEvent) : void
      {
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc2_:String = param1.result as String;
         var _loc3_:AsyncToken = param1.token;
         if(_loc3_ == null)
         {
            return;
         }
         var _loc4_:String = _loc3_.asyncObject.summonerName as String;
         var _loc5_:Boolean = _loc3_.asyncObject.confirmationRequired as Boolean;
         if(_loc2_ != null)
         {
            _loc6_ = StringUtil.trim(_loc2_) + "@" + ClientConfig.JABBER_DOMAIN;
            if(_loc5_)
            {
               this.blockAndConfirm(_loc6_,_loc4_);
            }
            else
            {
               this.block(_loc6_,_loc4_);
            }
         }
         else
         {
            _loc7_ = ResourceManager.getInstance().getString("resources","chat_buddyWindow_errorOnAddBuddyAlertMessage",[_loc4_]);
            this.chatController.showPromptMessage("resources",_loc7_,"chat_buddyWindow_errorOnIgnoreUserAlertTitle","PVP.NET","common_button_close");
         }
      }
      
      private function set _576262816activePrivacyList(param1:PrivacyList) : void
      {
         if(Boolean(this._activePrivacyList))
         {
            this._activePrivacyList.getItemsChanged().remove(this._activePrivacyListChanged.dispatch);
         }
         this._activePrivacyList = param1;
         if(this.activePrivacyList != null)
         {
            this.activePrivacyList.items.filterFunction = this.filterPrivacyItems;
            this.activePrivacyList.items.refresh();
            this._activePrivacyList.getItemsChanged().add(this._activePrivacyListChanged.dispatch);
         }
         this._activePrivacyListChanged.dispatch();
      }
      
      public function get serviceProxy() : ServiceProxy
      {
         return this._serviceProxy;
      }
      
      public function unblockSummonerName(param1:String) : void
      {
         if(param1.length == 0)
         {
            return;
         }
         this.serviceProxy.summonerService.getSummonerInternalNameByName(param1,this.onSummonerInternalNameRetrievedForUnblock,null,null,param1);
      }
      
      private function onSummonerInternalNameRetrievedForUnblock(param1:ResultEvent) : void
      {
         var _loc4_:String = null;
         var _loc2_:String = param1.result as String;
         var _loc3_:AsyncToken = param1.token;
         if(_loc3_ == null)
         {
            return;
         }
         if(_loc2_ != null)
         {
            _loc4_ = StringUtil.trim(_loc2_) + "@" + ClientConfig.JABBER_DOMAIN;
            this.unblock(_loc4_);
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set activePrivacyList(param1:PrivacyList) : void
      {
         var _loc2_:Object = this.activePrivacyList;
         if(_loc2_ !== param1)
         {
            this._576262816activePrivacyList = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"activePrivacyList",_loc2_,param1));
         }
      }
      
      private function onIQMessageReceived(param1:IQEvent) : void
      {
         var _loc6_:IQ = null;
         var _loc2_:XMPPConnection = this.serviceProxy.chatService.getConnection();
         var _loc3_:String = _loc2_.username + "@" + _loc2_.server;
         var _loc4_:IQ = param1.iq;
         if(_loc2_.username == _loc4_.from.node && _loc4_.type == IQ.SET_TYPE)
         {
            _loc6_ = new IQ(new EscapedJID(_loc3_),IQ.RESULT_TYPE,_loc4_.id);
            _loc2_.send(_loc6_);
         }
         var _loc5_:String = _loc2_.resource;
         if(_loc2_.username == _loc4_.from.node && _loc4_.type == IQ.SET_TYPE && _loc5_ != _loc4_.from.resource)
         {
            this.getPrivacyList();
         }
      }
      
      private function removePrivacyItems() : void
      {
         var _loc2_:IQ = null;
         var _loc3_:PrivacyExtension = null;
         var _loc4_:XMLNode = null;
         var _loc5_:PrivacyListNode = null;
         var _loc1_:ArrayCollection = new ArrayCollection(this.activePrivacyList.getPendingRemoveItemsAndClear());
         if(_loc1_.length > 0)
         {
            _loc2_ = new IQ(new EscapedJID(ClientConfig.JABBER_DOMAIN),IQ.SET_TYPE,XMPPStanza.generateID("privacy_"),null,null,this.onPrivacyListUpdated);
            _loc3_ = new PrivacyExtension();
            _loc4_ = _loc3_.getNode();
            _loc5_ = new PrivacyListNode(this.activePrivacyList.name,PrivacyListNode.REMOVE,_loc1_);
            _loc5_.serialize(_loc4_);
            _loc2_.addExtension(_loc3_);
            this.serviceProxy.chatService.getConnection().send(_loc2_);
         }
      }
      
      private function retrieveSummonerNames(param1:PrivacyList) : void
      {
         var _loc3_:PrivacyListItem = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:Number = NaN;
         var _loc2_:Array = new Array();
         for each(_loc3_ in param1.items)
         {
            if(!(_loc3_.type != PrivacyListItemType.JID || _loc3_.displayName != null))
            {
               _loc4_ = int(_loc3_.value.indexOf("@"));
               _loc5_ = _loc3_.value.substring(0,_loc4_);
               _loc6_ = parseInt(_loc5_.substring(3));
               _loc2_.push(_loc6_);
            }
         }
         if(_loc2_.length > 0)
         {
            this.serviceProxy.summonerService.getSummonerNames(_loc2_,this.onSummonerNamesRetrieved,this.onServiceRequestComplete);
         }
      }
      
      public function getActivePrivacyListInitialized() : ISignal
      {
         return this._activePrivacyListInitialized;
      }
      
      private function createPrivacyList() : PrivacyList
      {
         var _loc1_:PrivacyList = new PrivacyList(PrivacyListController.DEFAULT_PRIVACY_LIST_NAME);
         _loc1_.items = new ArrayCollection();
         return _loc1_;
      }
      
      private function onPrivacyListUpdated(param1:IQ) : void
      {
         if(!this.activePrivacyList)
         {
            return;
         }
         this._activePrivacyListUpdated.dispatch();
      }
      
      public function blockAndConfirm(param1:String, param2:String, param3:Function = null, param4:Object = null) : void
      {
         var jid:String = param1;
         var displayName:String = param2;
         var onConfirm:Function = param3;
         var asyncObject:Object = param4;
         onConfirm = onConfirm != null ? onConfirm : function():void
         {
         };
         var rM:IResourceManager = ResourceManager.getInstance();
         var alertAction:AlertAction = new AlertAction(rM.getString("resources","chat_buddyWindow_ignoreUserVerifyTitle"),rM.getString("resources","chat_buddyWindow_ignoreUserVerifyMessage",[displayName]));
         alertAction.showNegative = true;
         alertAction.affirmativeDefault = false;
         alertAction.setYesNoLabels();
         alertAction.getCompleted().addOnce(this.onBlockAndConfirmCompleted);
         alertAction.data = {
            "jid":jid,
            "displayName":displayName,
            "onConfirm":onConfirm,
            "asyncObject":asyncObject
         };
         alertAction.add();
      }
      
      private function addPrivacyItems() : void
      {
         var _loc2_:IQ = null;
         var _loc3_:PrivacyExtension = null;
         var _loc4_:XMLNode = null;
         var _loc5_:PrivacyListNode = null;
         var _loc1_:ArrayCollection = new ArrayCollection(this.activePrivacyList.getPendingAddItemsAndClear());
         if(_loc1_.length > 0)
         {
            _loc2_ = new IQ(new EscapedJID(ClientConfig.JABBER_DOMAIN),IQ.SET_TYPE,XMPPStanza.generateID("privacy_"),null,null,this.onPrivacyListUpdated);
            _loc3_ = new PrivacyExtension();
            _loc4_ = _loc3_.getNode();
            _loc5_ = new PrivacyListNode(this.activePrivacyList.name,PrivacyListNode.ADD,_loc1_);
            _loc5_.serialize(_loc4_);
            _loc2_.addExtension(_loc3_);
            this.serviceProxy.chatService.getConnection().send(_loc2_);
         }
      }
      
      public function get activePrivacyList() : PrivacyList
      {
         return this._activePrivacyList;
      }
      
      public function isMe(param1:String) : Boolean
      {
         var _loc2_:XMPPConnection = this.serviceProxy.chatService.getConnection();
         var _loc3_:String = _loc2_.jid.bareJID;
         return param1 == _loc3_;
      }
      
      public function isBlocked(param1:String) : Boolean
      {
         return this.isActive && Boolean(this.activePrivacyList) ? Boolean(this.activePrivacyList.contains(param1)) : false;
      }
      
      private function onSummonerNamesRetrieved(param1:ResultEvent) : void
      {
         var _loc4_:PrivacyListItem = null;
         var _loc5_:String = null;
         var _loc2_:ArrayCollection = param1.result as ArrayCollection;
         if(!this.activePrivacyList)
         {
            return;
         }
         var _loc3_:int = 0;
         for each(_loc4_ in this.activePrivacyList.items)
         {
            if(!(_loc4_.type != PrivacyListItemType.JID || _loc4_.displayName != null))
            {
               _loc5_ = _loc3_ >= _loc2_.length ? _loc4_.value : _loc2_.getItemAt(_loc3_) as String;
               _loc4_.displayName = _loc5_;
               _loc3_++;
            }
         }
      }
      
      public function set serviceProxy(param1:ServiceProxy) : void
      {
         this._serviceProxy = param1;
         if(this._serviceProxy.chatService != null)
         {
            this._serviceProxy.chatService.addConnectionEventListener(LoginEvent.LOGIN,this.onLoginCompleted);
            this._serviceProxy.chatService.addConnectionEventListener(DisconnectionEvent.DISCONNECT,this.onConnectionDisconnect);
            this._serviceProxy.chatService.addConnectionEventListener(PrivacyExtension.NS,this.onIQMessageReceived);
         }
      }
   }
}


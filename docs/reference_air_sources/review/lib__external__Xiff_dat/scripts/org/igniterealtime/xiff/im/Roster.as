package org.igniterealtime.xiff.im
{
   import flash.xml.XMLNode;
   import mx.collections.ArrayCollection;
   import mx.collections.Sort;
   import mx.collections.SortField;
   import mx.events.PropertyChangeEvent;
   import org.igniterealtime.xiff.core.EscapedJID;
   import org.igniterealtime.xiff.core.UnescapedJID;
   import org.igniterealtime.xiff.core.XMPPConnection;
   import org.igniterealtime.xiff.data.ExtensionClassRegistry;
   import org.igniterealtime.xiff.data.IQ;
   import org.igniterealtime.xiff.data.Presence;
   import org.igniterealtime.xiff.data.XMLStanza;
   import org.igniterealtime.xiff.data.XMPPStanza;
   import org.igniterealtime.xiff.data.im.RosterExtension;
   import org.igniterealtime.xiff.data.im.RosterGroup;
   import org.igniterealtime.xiff.data.im.RosterItemVO;
   import org.igniterealtime.xiff.events.*;
   
   [Event("userAvailable")]
   [Event("userUnavailable")]
   [Event("subscriptionDenial")]
   [Event("subscriptionRequest")]
   [Event("subscriptionRevocation")]
   public class Roster extends ArrayCollection
   {
      
      public static var multiPresence:Boolean = true;
      
      private static const staticConstructorDependencies:Array = [ExtensionClassRegistry,RosterExtension];
      
      private static var rosterStaticConstructed:Boolean = RosterStaticConstructor();
      
      private static var counter:int = 0;
      
      private var myConnection:XMPPConnection;
      
      private var pendingSubscriptionRequestJID:UnescapedJID;
      
      private var _presenceMap:Array = new Array();
      
      private var rosterLoaded:Boolean = false;
      
      private var pendingPresence:Array = [];
      
      private var _1237460524groups:ArrayCollection = new ArrayCollection();
      
      public var updateAllGroupsPriorities:Boolean = false;
      
      public function Roster(param1:XMPPConnection = null)
      {
         super();
         this.rosterLoaded = false;
         if(param1 != null)
         {
            this.connection = param1;
         }
         var _loc2_:Sort = new Sort();
         _loc2_.fields = [new SortField("priority",true),new SortField("label",true)];
         this.groups.sort = _loc2_;
         this.groups.refresh();
      }
      
      private static function RosterStaticConstructor() : Boolean
      {
         ExtensionClassRegistry.register(RosterExtension);
         return true;
      }
      
      public function addContact(param1:UnescapedJID, param2:String, param3:String, param4:int, param5:Boolean = true) : void
      {
         if(this.updateAllGroupsPriorities)
         {
            this.changeGroupsPriorities([],[]);
         }
         if(param2 == null)
         {
            param2 = param1.toString();
         }
         var _loc6_:Roster = null;
         var _loc7_:String = null;
         var _loc8_:String = RosterExtension.SUBSCRIBE_TYPE_NONE;
         var _loc9_:String = RosterExtension.ASK_TYPE_NONE;
         if(param5 == true)
         {
            _loc6_ = this;
            _loc7_ = "addContact_result";
            this.pendingSubscriptionRequestJID = param1;
            _loc8_ = RosterExtension.SUBSCRIBE_TYPE_TO;
            _loc9_ = RosterExtension.ASK_TYPE_SUBSCRIBE;
         }
         var _loc10_:IQ = new IQ(null,IQ.SET_TYPE,XMPPStanza.generateID("add_user_"),_loc7_,_loc6_);
         var _loc11_:RosterExtension = new RosterExtension(_loc10_.getNode());
         _loc11_.addItem(param1.escaped,null,param2,[param3],[param4]);
         _loc10_.addExtension(_loc11_);
         this.myConnection.send(_loc10_);
         this.addRosterItem(param1,param2,RosterExtension.SHOW_PENDING,RosterExtension.SHOW_PENDING,[param3],[param4],_loc8_,_loc9_);
      }
      
      public function requestSubscription(param1:UnescapedJID, param2:Boolean = false) : void
      {
         var _loc3_:Presence = null;
         if(param2)
         {
            _loc3_ = new Presence(param1.escaped,null,Presence.SUBSCRIBE_TYPE);
            this.myConnection.send(_loc3_);
            return;
         }
         if(contains(RosterItemVO.get(param1,false)))
         {
            _loc3_ = new Presence(param1.escaped,null,Presence.SUBSCRIBE_TYPE);
            this.myConnection.send(_loc3_);
         }
      }
      
      public function removeContact(param1:RosterItemVO) : void
      {
         var _loc2_:IQ = null;
         var _loc3_:RosterExtension = null;
         if(contains(param1))
         {
            if(this.updateAllGroupsPriorities)
            {
               this.changeGroupsPriorities([],[]);
            }
            _loc2_ = new IQ(null,IQ.SET_TYPE,XMPPStanza.generateID("remove_user_"),"unsubscribe_result",this);
            _loc3_ = new RosterExtension(_loc2_.getNode());
            _loc3_.addItem(new EscapedJID(param1.jid.bareJID),RosterExtension.SUBSCRIBE_TYPE_REMOVE);
            _loc2_.addExtension(_loc3_);
            this.myConnection.send(_loc2_);
         }
      }
      
      public function moveGroupMembers(param1:String, param2:String) : void
      {
         var _loc3_:IQ = new IQ(null,IQ.SET_TYPE,XMPPStanza.generateID("move_group_members_"));
         var _loc4_:RosterExtension = new RosterExtension(_loc3_.getNode());
         var _loc5_:XMLNode = XMLStanza.XMLFactory.createElement("");
         _loc5_.nodeName = "group";
         _loc5_.attributes["old"] = param1;
         _loc5_.attributes["new"] = param2;
         _loc4_.getNode().appendChild(_loc5_);
         _loc3_.addExtension(_loc4_);
         this.myConnection.send(_loc3_);
      }
      
      public function changeGroupsPriorities(param1:Array, param2:Array) : void
      {
         var _loc5_:int = 0;
         var _loc6_:RosterGroup = null;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc9_:XMLNode = null;
         if(this.updateAllGroupsPriorities)
         {
            param1 = [];
            param2 = [];
            for each(_loc6_ in this.groups)
            {
               param1.push(_loc6_.label);
               param2.push(_loc6_.priority);
            }
         }
         if(param1.length != param2.length)
         {
            return;
         }
         var _loc3_:IQ = new IQ(null,IQ.SET_TYPE,XMPPStanza.generateID("group_reorder_"));
         var _loc4_:RosterExtension = new RosterExtension(_loc3_.getNode());
         _loc5_ = 0;
         while(_loc5_ < param1.length)
         {
            _loc7_ = param1[_loc5_];
            _loc8_ = int(param2[_loc5_]);
            _loc9_ = XMLStanza.XMLFactory.createElement("");
            _loc9_.nodeName = "group";
            _loc9_.attributes["name"] = _loc7_;
            _loc9_.attributes["priority"] = _loc8_;
            _loc4_.getNode().appendChild(_loc9_);
            _loc5_++;
         }
         _loc3_.addExtension(_loc4_);
         this.updateAllGroupsPriorities = false;
         this.myConnection.send(_loc3_);
      }
      
      public function fetchRoster() : void
      {
         var _loc1_:IQ = new IQ(null,IQ.GET_TYPE,XMPPStanza.generateID("roster_"),"fetchRoster_result",this);
         _loc1_.addExtension(new RosterExtension(_loc1_.getNode()));
         this.myConnection.send(_loc1_);
      }
      
      public function grantSubscription(param1:UnescapedJID, param2:Boolean = true) : void
      {
         var _loc3_:Presence = new Presence(param1.escaped,null,Presence.SUBSCRIBED_TYPE);
         this.myConnection.send(_loc3_);
         if(param2)
         {
            this.requestSubscription(param1,true);
         }
      }
      
      public function denySubscription(param1:UnescapedJID) : void
      {
         var _loc2_:Presence = new Presence(param1.escaped,null,Presence.UNSUBSCRIBED_TYPE);
         this.myConnection.send(_loc2_);
      }
      
      public function withdrawSubscription(param1:UnescapedJID) : void
      {
         var _loc2_:Presence = new Presence(param1.escaped,null,Presence.UNSUBSCRIBE_TYPE);
         this.myConnection.send(_loc2_);
      }
      
      private function updateContact(param1:RosterItemVO, param2:String, param3:Array) : void
      {
         var _loc7_:String = null;
         var _loc8_:RosterGroup = null;
         if(this.updateAllGroupsPriorities)
         {
            this.changeGroupsPriorities([],[]);
         }
         var _loc4_:IQ = new IQ(null,IQ.SET_TYPE,XMPPStanza.generateID("update_contact_"));
         var _loc5_:RosterExtension = new RosterExtension(_loc4_.getNode());
         var _loc6_:Array = [];
         for each(_loc7_ in param3)
         {
            for each(_loc8_ in this.groups)
            {
               if(_loc8_.label == _loc7_)
               {
                  _loc6_.push(_loc8_.priority);
                  break;
               }
            }
         }
         _loc5_.addItem(param1.jid.escaped,param1.subscribeType,param2,param3,_loc6_);
         _loc4_.addExtension(_loc5_);
         this.myConnection.send(_loc4_);
      }
      
      public function updateContactName(param1:RosterItemVO, param2:String) : void
      {
         var _loc4_:RosterGroup = null;
         var _loc3_:Array = [];
         for each(_loc4_ in this.getContainingGroups(param1))
         {
            _loc3_.push(_loc4_.label);
         }
         this.updateContact(param1,param2,_loc3_);
      }
      
      public function getContainingGroups(param1:RosterItemVO) : Array
      {
         var _loc3_:RosterGroup = null;
         var _loc2_:Array = [];
         for each(_loc3_ in this.groups)
         {
            if(_loc3_.contains(param1))
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      public function updateContactGroups(param1:RosterItemVO, param2:Array) : void
      {
         this.updateContact(param1,param1.displayName,param2);
      }
      
      public function setPresence(param1:String, param2:String, param3:Number) : void
      {
         var _loc4_:Presence = new Presence(null,null,null,param1,param2,param3);
         this.myConnection.send(_loc4_);
      }
      
      public function fetchRoster_result(param1:IQ) : void
      {
         var ext:RosterExtension = null;
         var ev:RosterEvent = null;
         var item:* = undefined;
         var note:String = null;
         var resultIQ:IQ = param1;
         this.rosterLoaded = true;
         removeAll();
         try
         {
            disableAutoUpdate();
            for each(ext in resultIQ.getAllExtensionsByNS(RosterExtension.NS))
            {
               for each(item in ext.getAllItems())
               {
                  if(!(!item is XMLStanza))
                  {
                     note = "";
                     if(Boolean(item.note))
                     {
                        note = item.note;
                     }
                     this.addRosterItem(new UnescapedJID(item.jid),item.name,RosterExtension.SHOW_UNAVAILABLE,"Offline",item.groupNames,item.groupPriorities,item.subscription.toLowerCase(),item.askType != null ? item.askType.toLowerCase() : RosterExtension.ASK_TYPE_NONE,note);
                  }
               }
            }
            this.initializeGroupPriorities();
            enableAutoUpdate();
            ev = new RosterEvent(RosterEvent.ROSTER_LOADED,false,false);
            dispatchEvent(ev);
            if(this.pendingPresence.length > 0)
            {
               this.handlePresences(this.pendingPresence);
               this.pendingPresence = [];
            }
         }
         catch(e:Error)
         {
         }
      }
      
      public function addContact_result(param1:IQ) : void
      {
         this.requestSubscription(this.pendingSubscriptionRequestJID);
         this.pendingSubscriptionRequestJID = null;
      }
      
      public function unsubscribe_result(param1:IQ) : void
      {
      }
      
      override public function set filterFunction(param1:Function) : void
      {
         throw new Error("Setting the filterFunction on Roster is not allowed; Wrap it in a ListCollectionView and filter that.");
      }
      
      private function handleEvent(param1:*) : void
      {
         var ext:RosterExtension = null;
         var item:* = undefined;
         var rosterItemVO:RosterItemVO = null;
         var ev:RosterEvent = null;
         var group:RosterGroup = null;
         var groups:Array = null;
         var eventObj:* = param1;
         switch(eventObj.type)
         {
            case "presence":
               this.handlePresences(eventObj.data);
               break;
            case "login":
               if(!this.rosterLoaded)
               {
                  this.fetchRoster();
               }
               break;
            case RosterExtension.NS:
               try
               {
                  ext = (eventObj.iq as IQ).getAllExtensionsByNS(RosterExtension.NS)[0] as RosterExtension;
                  for each(item in ext.getAllItems())
                  {
                     rosterItemVO = RosterItemVO.get(new UnescapedJID(item.jid),true);
                     rosterItemVO.note = item.note;
                     if(contains(rosterItemVO))
                     {
                        switch(item.subscription.toLowerCase())
                        {
                           case RosterExtension.SUBSCRIBE_TYPE_NONE:
                              ev = new RosterEvent(RosterEvent.SUBSCRIPTION_REVOCATION);
                              ev.jid = item.jid is UnescapedJID ? item.jid : new UnescapedJID(item.jid);
                              dispatchEvent(ev);
                              break;
                           case RosterExtension.SUBSCRIBE_TYPE_REMOVE:
                              ev = new RosterEvent(RosterEvent.USER_REMOVED);
                              for each(group in this.getContainingGroups(rosterItemVO))
                              {
                                 group.removeItem(rosterItemVO);
                              }
                              ev.data = removeItemAt(getItemIndex(rosterItemVO));
                              ev.jid = item.jid is UnescapedJID ? item.jid : new UnescapedJID(item.jid);
                              RosterItemVO.remove(ev.jid);
                              dispatchEvent(ev);
                              break;
                           default:
                              this.updateRosterItemSubscription(rosterItemVO,item.subscription.toLowerCase(),item.name,item.groupNames,item.groupPriorities);
                        }
                     }
                     else
                     {
                        groups = item.groupNames;
                        if(item.subscription.toLowerCase() != RosterExtension.SUBSCRIBE_TYPE_REMOVE && item.subscription.toLowerCase() != RosterExtension.SUBSCRIBE_TYPE_NONE)
                        {
                           this.addRosterItem(new UnescapedJID(item.jid),item.name,RosterExtension.SHOW_UNAVAILABLE,"Offline",groups,item.subscription.toLowerCase(),item.askType != null ? item.askType.toLowerCase() : RosterExtension.ASK_TYPE_NONE);
                        }
                        else if((item.subscription.toLowerCase() == RosterExtension.SUBSCRIBE_TYPE_NONE || item.subscription.toLowerCase() == RosterExtension.SUBSCRIBE_TYPE_FROM) && item.askType == RosterExtension.ASK_TYPE_SUBSCRIBE)
                        {
                           this.addRosterItem(new UnescapedJID(item.jid),item.name,RosterExtension.SHOW_PENDING,"Pending",groups,item.subscription.toLowerCase(),item.askType != null ? item.askType.toLowerCase() : RosterExtension.ASK_TYPE_NONE);
                        }
                     }
                  }
               }
               catch(e:Error)
               {
               }
         }
      }
      
      private function initializeGroupPriorities() : void
      {
         var _loc1_:RosterGroup = null;
         var _loc2_:int = 0;
         for each(_loc1_ in this.groups)
         {
            if(_loc1_.priority != RosterGroup.UNDEFINED_PRIORITY)
            {
               return;
            }
         }
         _loc2_ = 0;
         while(_loc2_ < this.groups.length)
         {
            this.groups[_loc2_].priority = this.groups.length - _loc2_;
            _loc2_++;
         }
         this.updateAllGroupsPriorities = true;
      }
      
      private function setAutoUpdateOnGroups(param1:Boolean) : void
      {
         var _loc2_:RosterGroup = null;
         for each(_loc2_ in this.groups)
         {
            if(param1)
            {
               _loc2_.enableAutoUpdate();
            }
            else
            {
               _loc2_.disableAutoUpdate();
            }
         }
      }
      
      private function handlePresences(param1:Array) : void
      {
         var _loc2_:Presence = null;
         var _loc3_:String = null;
         var _loc4_:RosterEvent = null;
         var _loc5_:RosterEvent = null;
         var _loc6_:RosterEvent = null;
         var _loc7_:RosterItemVO = null;
         var _loc8_:RosterEvent = null;
         var _loc9_:RosterItemVO = null;
         disableAutoUpdate();
         this.groups.disableAutoUpdate();
         this.setAutoUpdateOnGroups(false);
         for each(_loc2_ in param1)
         {
            if(_loc2_.from.resource == "game")
            {
               continue;
            }
            if(!this.rosterLoaded)
            {
               this.pendingPresence.push(_loc2_);
               continue;
            }
            _loc3_ = Boolean(_loc2_.type) ? _loc2_.type.toLowerCase() : null;
            switch(_loc3_)
            {
               case Presence.SUBSCRIBE_TYPE:
                  _loc4_ = new RosterEvent(RosterEvent.SUBSCRIPTION_REQUEST);
                  _loc4_.jid = _loc2_.from.unescaped;
                  dispatchEvent(_loc4_);
                  break;
               case Presence.UNSUBSCRIBED_TYPE:
                  _loc5_ = new RosterEvent(RosterEvent.SUBSCRIPTION_DENIAL);
                  _loc5_.jid = _loc2_.from.unescaped;
                  dispatchEvent(_loc5_);
                  break;
               case Presence.UNAVAILABLE_TYPE:
                  _loc6_ = new RosterEvent(RosterEvent.USER_UNAVAILABLE);
                  _loc6_.jid = _loc2_.from.unescaped;
                  dispatchEvent(_loc6_);
                  _loc7_ = RosterItemVO.get(_loc2_.from.unescaped,false);
                  if(_loc7_)
                  {
                     this.updateRosterItemPresence(_loc7_,_loc2_);
                  }
                  break;
               default:
                  _loc8_ = new RosterEvent(RosterEvent.USER_AVAILABLE);
                  _loc8_.jid = _loc2_.from.unescaped;
                  _loc8_.data = _loc2_;
                  dispatchEvent(_loc8_);
                  _loc9_ = RosterItemVO.get(_loc2_.from.unescaped,false);
                  if(_loc9_)
                  {
                     this.updateRosterItemPresence(_loc9_,_loc2_);
                  }
            }
         }
         this.setAutoUpdateOnGroups(true);
         enableAutoUpdate();
         this.groups.enableAutoUpdate();
      }
      
      private function addRosterItem(param1:UnescapedJID, param2:String, param3:String, param4:String, param5:Array, param6:Array, param7:String, param8:String = "none", param9:String = "") : Boolean
      {
         if(!param1)
         {
            return false;
         }
         var _loc10_:RosterItemVO = RosterItemVO.get(param1,true);
         if(!contains(_loc10_))
         {
            addItem(_loc10_);
         }
         if(Boolean(param2))
         {
            _loc10_.displayName = param2;
         }
         _loc10_.subscribeType = param7;
         _loc10_.askType = param8;
         _loc10_.note = param9;
         this.setContactGroups(_loc10_,param5,param6);
         var _loc11_:RosterEvent = new RosterEvent(RosterEvent.USER_ADDED);
         _loc11_.jid = param1;
         _loc11_.data = _loc10_;
         dispatchEvent(_loc11_);
         return true;
      }
      
      private function setContactGroups(param1:RosterItemVO, param2:Array, param3:Array) : void
      {
         var _loc4_:String = null;
         var _loc5_:RosterGroup = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         this.groups.disableAutoUpdate();
         if(!param2 || param2.length == 0)
         {
            param2 = ["**Default"];
         }
         if(!param3 || param3.length == 0)
         {
            param3 = [RosterGroup.UNDEFINED_PRIORITY];
         }
         for each(_loc4_ in param2)
         {
            _loc6_ = int(param3[param2.indexOf(_loc4_)]);
            if(!this.getGroup(_loc4_))
            {
               this.groups.addItem(new RosterGroup(_loc4_,_loc6_));
            }
         }
         this.groups.enableAutoUpdate();
         this.groups.disableAutoUpdate();
         for each(_loc5_ in this.groups)
         {
            if(param2.indexOf(_loc5_.label) >= 0)
            {
               _loc5_.addItem(param1);
            }
            else
            {
               _loc5_.removeItem(param1);
               if(_loc5_.length == 0)
               {
                  _loc7_ = int(this.groups.getItemIndex(_loc5_));
                  if(_loc7_ > -1)
                  {
                     this.groups.removeItemAt(_loc7_);
                  }
               }
            }
         }
         this.groups.refresh();
         this.groups.enableAutoUpdate();
      }
      
      private function updateRosterItemSubscription(param1:RosterItemVO, param2:String, param3:String, param4:Array, param5:Array) : void
      {
         param1.subscribeType = param2;
         this.setContactGroups(param1,param4,param5);
         if(Boolean(param3))
         {
            param1.displayName = param3;
         }
         var _loc6_:RosterEvent = new RosterEvent(RosterEvent.USER_SUBSCRIPTION_UPDATED);
         _loc6_.jid = param1.jid;
         _loc6_.data = param1;
         dispatchEvent(_loc6_);
      }
      
      private function updateRosterItemPresence(param1:RosterItemVO, param2:Presence) : void
      {
         var dispatchPresenceOnline:Boolean = false;
         var event:RosterEvent = null;
         var item:RosterItemVO = param1;
         var presence:Presence = param2;
         try
         {
            dispatchPresenceOnline = false;
            if(item.status == "Offline" && presence.status != "Offline")
            {
               dispatchPresenceOnline = true;
            }
            if(!multiPresence)
            {
               item.status = presence.status;
               item.show = presence.show;
               item.priority = presence.priority;
               if(!presence.type || presence.type == Presence.MOBILE_TYPE)
               {
                  item.online = true;
               }
               else if(presence.type == Presence.UNAVAILABLE_TYPE)
               {
                  item.online = false;
               }
               item.isOnMobile = presence.type == Presence.MOBILE_TYPE;
            }
            else
            {
               item.registerPresence(presence);
            }
            event = new RosterEvent(RosterEvent.USER_PRESENCE_UPDATED);
            event.jid = item.jid;
            event.data = item;
            this._presenceMap[item.jid.toString()] = presence;
            dispatchEvent(event);
            if(dispatchPresenceOnline)
            {
               event = new RosterEvent(RosterEvent.USER_PRESENCE_ONLINE);
               event.jid = item.jid;
               event.data = item;
               dispatchEvent(event);
            }
         }
         catch(e:Error)
         {
         }
      }
      
      public function getPresence(param1:UnescapedJID) : Presence
      {
         var _loc2_:RosterItemVO = null;
         var _loc3_:Presence = null;
         if(!multiPresence)
         {
            return this._presenceMap[param1.toString()];
         }
         _loc2_ = RosterItemVO.get(param1,false);
         if(!_loc2_)
         {
            return undefined;
         }
         _loc3_ = _loc2_.getPrimaryPresence();
         if(!_loc3_)
         {
            return undefined;
         }
         return _loc3_;
      }
      
      public function get connection() : XMPPConnection
      {
         return this.myConnection;
      }
      
      public function set connection(param1:XMPPConnection) : void
      {
         if(this.myConnection != null)
         {
            this.myConnection.removeEventListener(PresenceEvent.PRESENCE,this.handleEvent);
            this.myConnection.removeEventListener(LoginEvent.LOGIN,this.handleEvent);
            this.myConnection.removeEventListener(RosterExtension.NS,this.handleEvent);
         }
         this.myConnection = param1;
         if(this.myConnection != null)
         {
            this.myConnection.addEventListener(PresenceEvent.PRESENCE,this.handleEvent);
            this.myConnection.addEventListener(LoginEvent.LOGIN,this.handleEvent);
            this.myConnection.addEventListener(RosterExtension.NS,this.handleEvent);
         }
         else
         {
            RosterItemVO.removeAll();
         }
      }
      
      public function getGroup(param1:String) : RosterGroup
      {
         var _loc2_:RosterGroup = null;
         for each(_loc2_ in this.groups)
         {
            if(_loc2_.label == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      [Bindable(event="propertyChange")]
      public function get groups() : ArrayCollection
      {
         return this._1237460524groups;
      }
      
      public function set groups(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1237460524groups;
         if(_loc2_ !== param1)
         {
            this._1237460524groups = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"groups",_loc2_,param1));
            }
         }
      }
   }
}


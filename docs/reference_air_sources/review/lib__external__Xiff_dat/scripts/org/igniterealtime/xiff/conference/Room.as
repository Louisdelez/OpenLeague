package org.igniterealtime.xiff.conference
{
   import flash.events.Event;
   import mx.collections.ArrayCollection;
   import org.igniterealtime.xiff.core.EscapedJID;
   import org.igniterealtime.xiff.core.UnescapedJID;
   import org.igniterealtime.xiff.core.XMPPConnection;
   import org.igniterealtime.xiff.data.*;
   import org.igniterealtime.xiff.data.forms.FormExtension;
   import org.igniterealtime.xiff.data.im.RosterItemVO;
   import org.igniterealtime.xiff.data.muc.*;
   import org.igniterealtime.xiff.events.DisconnectionEvent;
   import org.igniterealtime.xiff.events.MessageEvent;
   import org.igniterealtime.xiff.events.PresenceEvent;
   import org.igniterealtime.xiff.events.RoomEvent;
   
   [Event(name="declined",type="org.igniterealtime.xiff.events.RoomEvent")]
   [Event(name="configureForm",type="org.igniterealtime.xiff.events.RoomEvent")]
   [Event(name="nickConflict",type="org.igniterealtime.xiff.events.RoomEvent")]
   [Event(name="userBanned",type="org.igniterealtime.xiff.events.RoomEvent")]
   [Event(name="userKicked",type="org.igniterealtime.xiff.events.RoomEvent")]
   [Event(name="userDeparture",type="org.igniterealtime.xiff.events.RoomEvent")]
   [Event(name="userJoin",type="org.igniterealtime.xiff.events.RoomEvent")]
   [Event(name="lockedError",type="org.igniterealtime.xiff.events.RoomEvent")]
   [Event(name="maxUsersError",type="org.igniterealtime.xiff.events.RoomEvent")]
   [Event(name="bannedError",type="org.igniterealtime.xiff.events.RoomEvent")]
   [Event(name="registrationReqError",type="org.igniterealtime.xiff.events.RoomEvent")]
   [Event(name="passwordError",type="org.igniterealtime.xiff.events.RoomEvent")]
   [Event(name="adminError",type="org.igniterealtime.xiff.events.RoomEvent")]
   [Event(name="affiliations",type="org.igniterealtime.xiff.events.RoomEvent")]
   [Event(name="roomLeave",type="org.igniterealtime.xiff.events.RoomEvent")]
   [Event(name="roomJoin",type="org.igniterealtime.xiff.events.RoomEvent")]
   [Event(name="privateMessage",type="org.igniterealtime.xiff.events.RoomEvent")]
   [Event(name="groupMessage",type="org.igniterealtime.xiff.events.RoomEvent")]
   [Event(name="subjectChange",type="org.igniterealtime.xiff.events.RoomEvent")]
   public class Room extends ArrayCollection
   {
      
      public static const NO_AFFILIATION:String = MUC.NO_AFFILIATION;
      
      public static const MEMBER_AFFILIATION:String = MUC.MEMBER_AFFILIATION;
      
      public static const ADMIN_AFFILIATION:String = MUC.ADMIN_AFFILIATION;
      
      public static const OWNER_AFFILIATION:String = MUC.OWNER_AFFILIATION;
      
      public static const OUTCAST_AFFILIATION:String = MUC.OUTCAST_AFFILIATION;
      
      public static const NO_ROLE:String = MUC.NO_ROLE;
      
      public static const MODERATOR_ROLE:String = MUC.MODERATOR_ROLE;
      
      public static const PARTICIPANT_ROLE:String = MUC.PARTICIPANT_ROLE;
      
      public static const VISITOR_ROLE:String = MUC.VISITOR_ROLE;
      
      private static var staticConstructorDependencies:Array = [FormExtension,MUC];
      
      private static var roomStaticConstructed:Boolean = RoomStaticConstructor();
      
      private var myConnection:XMPPConnection;
      
      private var myJID:UnescapedJID;
      
      private var myNickname:String;
      
      private var myPassword:String;
      
      private var myRole:String;
      
      private var myAffiliation:String;
      
      private var myIsReserved:Boolean;
      
      private var mySubject:String;
      
      private var _anonymous:Boolean = true;
      
      private var _active:Boolean;
      
      private var pendingNickname:String;
      
      public function Room(param1:XMPPConnection = null)
      {
         super();
         this.setActive(false);
         if(Boolean(param1))
         {
            this.connection = param1;
         }
      }
      
      private static function RoomStaticConstructor() : Boolean
      {
         MUC.enable();
         FormExtension.enable();
         return true;
      }
      
      public function set connection(param1:XMPPConnection) : void
      {
         if(this.myConnection != null)
         {
            this.myConnection.removeEventListener(MessageEvent.MESSAGE,this.handleEvent);
            this.myConnection.removeEventListener(PresenceEvent.PRESENCE,this.handleEvent);
            this.myConnection.removeEventListener(DisconnectionEvent.DISCONNECT,this.handleEvent);
         }
         this.myConnection = param1;
         this.myConnection.addEventListener(MessageEvent.MESSAGE,this.handleEvent,false,0,true);
         this.myConnection.addEventListener(PresenceEvent.PRESENCE,this.handleEvent,false,0,true);
         this.myConnection.addEventListener(DisconnectionEvent.DISCONNECT,this.handleEvent,false,0,true);
      }
      
      public function get connection() : XMPPConnection
      {
         return this.myConnection;
      }
      
      public function join(param1:Boolean = false, param2:Array = null, param3:String = null) : Boolean
      {
         var _loc6_:* = undefined;
         if(!this.myConnection.isActive() || this.isActive)
         {
            return false;
         }
         this.myIsReserved = param1 == true ? true : false;
         var _loc4_:Presence = new Presence(this.userJID.escaped);
         if(param2 != null)
         {
            for each(_loc6_ in param2)
            {
               _loc4_.addExtension(_loc6_);
            }
         }
         var _loc5_:MUCExtension = new MUCExtension();
         if(this.password != null)
         {
            _loc5_.password = this.password;
         }
         _loc4_.addExtension(_loc5_);
         if(param3 != null)
         {
            _loc4_.status = param3;
         }
         this.myConnection.send(_loc4_);
         return true;
      }
      
      public function leave() : void
      {
         var _loc1_:Presence = null;
         if(this.isActive)
         {
            _loc1_ = new Presence(this.userJID.escaped,null,Presence.UNAVAILABLE_TYPE);
            this.myConnection.send(_loc1_);
            this.myConnection.removeEventListener(MessageEvent.MESSAGE,this.handleEvent);
            this.myConnection.removeEventListener(DisconnectionEvent.DISCONNECT,this.handleEvent);
         }
         else if(this.myConnection != null)
         {
            this.myConnection.removeEventListener(PresenceEvent.PRESENCE,this.handleEvent);
            this.myConnection.removeEventListener(MessageEvent.MESSAGE,this.handleEvent);
            this.myConnection.removeEventListener(DisconnectionEvent.DISCONNECT,this.handleEvent);
         }
         removeAll();
      }
      
      public function getMessage(param1:String = null, param2:String = null) : Message
      {
         return new Message(this.roomJID.escaped,null,param1,param2,Message.GROUPCHAT_TYPE);
      }
      
      public function sendMessage(param1:String = null, param2:String = null) : void
      {
         var _loc3_:Message = new Message(this.roomJID.escaped,null,param1,param2,Message.GROUPCHAT_TYPE);
         this.myConnection.send(_loc3_);
      }
      
      public function sendMessageWithExtension(param1:Message) : void
      {
         if(this.isActive)
         {
            this.myConnection.send(param1);
         }
      }
      
      public function sendPrivateMessage(param1:String, param2:String = null, param3:String = null) : void
      {
         var _loc4_:Message = null;
         if(this.isActive)
         {
            _loc4_ = new Message(new EscapedJID(this.roomJID + "/" + param1),null,param2,param3,Message.CHAT_TYPE);
            this.myConnection.send(_loc4_);
         }
      }
      
      public function changeSubject(param1:String) : void
      {
         var _loc2_:Message = null;
         if(this.isActive)
         {
            _loc2_ = new Message(this.roomJID.escaped,null,null,null,Message.GROUPCHAT_TYPE,param1);
            this.myConnection.send(_loc2_);
         }
      }
      
      public function kickOccupant(param1:String, param2:String) : void
      {
         var _loc3_:IQ = null;
         var _loc4_:MUCAdminExtension = null;
         if(this.isActive)
         {
            _loc3_ = new IQ(this.roomJID.escaped,IQ.SET_TYPE,XMPPStanza.generateID("kick_occupant_"));
            _loc4_ = new MUCAdminExtension(_loc3_.getNode());
            _loc4_.addItem(null,MUC.NO_ROLE,param1,null,null,param2);
            _loc3_.addExtension(_loc4_);
            this.myConnection.send(_loc3_);
         }
      }
      
      public function setOccupantVoice(param1:String, param2:Boolean) : void
      {
         var _loc3_:IQ = null;
         var _loc4_:MUCAdminExtension = null;
         if(this.isActive)
         {
            _loc3_ = new IQ(this.roomJID.escaped,IQ.SET_TYPE,XMPPStanza.generateID("voice_"));
            _loc4_ = new MUCAdminExtension(_loc3_.getNode());
            _loc4_.addItem(null,param2 ? MUC.PARTICIPANT_ROLE : MUC.VISITOR_ROLE);
            _loc3_.addExtension(_loc4_);
            this.myConnection.send(_loc3_);
         }
      }
      
      public function invite(param1:UnescapedJID, param2:String) : void
      {
         var _loc3_:Message = new Message(this.roomJID.escaped);
         var _loc4_:MUCUserExtension = new MUCUserExtension();
         _loc4_.invite(param1.escaped,undefined,param2);
         _loc3_.addExtension(_loc4_);
         this.myConnection.send(_loc3_);
      }
      
      public function decline(param1:UnescapedJID, param2:String) : void
      {
         var _loc3_:Message = new Message(this.roomJID.escaped);
         var _loc4_:MUCUserExtension = new MUCUserExtension();
         _loc4_.decline(param1.escaped,undefined,param2);
         _loc3_.addExtension(_loc4_);
         this.myConnection.send(_loc3_);
      }
      
      public function get fullRoomName() : String
      {
         return this.roomJID.toString();
      }
      
      public function get roomJID() : UnescapedJID
      {
         return this.myJID;
      }
      
      public function set roomJID(param1:UnescapedJID) : void
      {
         this.myJID = param1;
      }
      
      public function get userJID() : UnescapedJID
      {
         return new UnescapedJID(this.roomJID.bareJID + "/" + this.nickname);
      }
      
      [Bindable(event="roleSet")]
      public function get role() : String
      {
         return this.myRole;
      }
      
      [Bindable(event="affiliationSet")]
      public function get affiliation() : String
      {
         return this.myAffiliation;
      }
      
      [Bindable(event="activeStateUpdated")]
      public function get isActive() : Boolean
      {
         return this._active;
      }
      
      private function setActive(param1:Boolean) : void
      {
         this._active = param1;
         dispatchEvent(new Event("activeStateUpdated"));
      }
      
      private function handleEvent(param1:Object) : void
      {
         var _loc2_:Message = null;
         var _loc3_:RoomEvent = null;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:Array = null;
         var _loc8_:MUCUserExtension = null;
         var _loc9_:Presence = null;
         var _loc10_:MUCUserExtension = null;
         var _loc11_:MUCStatus = null;
         switch(param1.type)
         {
            case "message":
               _loc2_ = param1.data;
               _loc2_.body = this.unwrapCDATA(_loc2_.body);
               if(this.isThisRoom(_loc2_.from.unescaped))
               {
                  if(_loc2_.type == Message.GROUPCHAT_TYPE)
                  {
                     if(_loc2_.subject != null)
                     {
                        this.mySubject = _loc2_.subject;
                        _loc3_ = new RoomEvent(RoomEvent.SUBJECT_CHANGE);
                        _loc3_.subject = _loc2_.subject;
                        dispatchEvent(_loc3_);
                     }
                     else
                     {
                        _loc4_ = _loc2_.getAllExtensionsByNS(MUCUserExtension.NS);
                        if(!_loc4_ || _loc4_.length == 0 || !_loc4_[0].hasStatusCode(100))
                        {
                           _loc3_ = new RoomEvent(RoomEvent.GROUP_MESSAGE);
                           _loc3_.data = _loc2_;
                           dispatchEvent(_loc3_);
                        }
                     }
                  }
                  else if(_loc2_.type == Message.NORMAL_TYPE)
                  {
                     _loc5_ = _loc2_.getAllExtensionsByNS(FormExtension.NS);
                     _loc6_ = null;
                     if(Boolean(_loc5_))
                     {
                        _loc6_ = _loc5_[0];
                     }
                     if(Boolean(_loc6_))
                     {
                        _loc3_ = new RoomEvent(RoomEvent.CONFIGURE_ROOM);
                        _loc3_.data = _loc6_;
                        dispatchEvent(_loc3_);
                     }
                  }
               }
               else if(this.isThisUser(_loc2_.to.unescaped) && _loc2_.type == Message.CHAT_TYPE)
               {
                  _loc3_ = new RoomEvent(RoomEvent.PRIVATE_MESSAGE);
                  _loc3_.data = _loc2_;
                  dispatchEvent(_loc3_);
               }
               else
               {
                  _loc7_ = _loc2_.getAllExtensionsByNS(MUCUserExtension.NS);
                  if(_loc7_ != null && _loc7_.length > 0)
                  {
                     _loc8_ = _loc7_[0];
                     if(Boolean(_loc8_) && _loc8_.type == MUCUserExtension.DECLINE_TYPE)
                     {
                        _loc3_ = new RoomEvent(RoomEvent.DECLINED);
                        _loc3_.from = _loc8_.reason;
                        _loc3_.reason = _loc8_.reason;
                        _loc3_.data = _loc2_;
                        dispatchEvent(_loc3_);
                     }
                  }
               }
               break;
            case "presence":
               for each(_loc9_ in param1.data)
               {
                  if(_loc9_.type == Presence.ERROR_TYPE)
                  {
                     switch(_loc9_.errorCode)
                     {
                        case 401:
                           _loc3_ = new RoomEvent(RoomEvent.PASSWORD_ERROR);
                           break;
                        case 403:
                           _loc3_ = new RoomEvent(RoomEvent.BANNED_ERROR);
                           break;
                        case 404:
                           _loc3_ = new RoomEvent(RoomEvent.LOCKED_ERROR);
                           break;
                        case 407:
                           _loc3_ = new RoomEvent(RoomEvent.REGISTRATION_REQ_ERROR);
                           break;
                        case 409:
                           _loc3_ = new RoomEvent(RoomEvent.NICK_CONFLICT);
                           _loc3_.nickname = this.nickname;
                           break;
                        default:
                           _loc3_ = new RoomEvent("MUC Error of type: " + _loc9_.errorCode);
                     }
                     if(503 == _loc9_.errorCode && Presence.MUC_ROOM_FULL == _loc9_.errorMessage)
                     {
                        _loc3_ = new RoomEvent(RoomEvent.MAX_USERS_ERROR);
                     }
                     _loc3_.errorCode = _loc9_.errorCode;
                     _loc3_.errorMessage = _loc9_.errorMessage;
                     _loc3_.errorInThisRoom = this.isThisRoom(_loc9_.from.unescaped);
                     dispatchEvent(_loc3_);
                  }
                  else if(this.isThisRoom(_loc9_.from.unescaped))
                  {
                     if(_loc9_.from.resource == this.pendingNickname)
                     {
                        this.myNickname = this.pendingNickname;
                        this.pendingNickname = null;
                     }
                     _loc10_ = _loc9_.getAllExtensionsByNS(MUCUserExtension.NS)[0];
                     for each(_loc11_ in _loc10_.statuses)
                     {
                        switch(_loc11_.code)
                        {
                           case 100:
                           case 172:
                              this.anonymous = false;
                              break;
                           case 174:
                              this.anonymous = true;
                              break;
                           case 201:
                              break;
                           case 307:
                              _loc3_ = new RoomEvent(RoomEvent.USER_KICKED);
                              _loc3_.nickname = _loc9_.from.resource;
                              dispatchEvent(_loc3_);
                              break;
                           case 301:
                              _loc3_ = new RoomEvent(RoomEvent.USER_BANNED);
                              _loc3_.nickname = _loc9_.from.resource;
                              dispatchEvent(_loc3_);
                        }
                     }
                     this.updateRoomRoster(_loc9_);
                     if(_loc9_.type == Presence.UNAVAILABLE_TYPE && this.isActive && this.isThisUser(_loc9_.from.unescaped))
                     {
                        this.setActive(false);
                        if(_loc10_.type == MUCUserExtension.DESTROY_TYPE)
                        {
                           _loc3_ = new RoomEvent(RoomEvent.ROOM_DESTROYED);
                        }
                        else
                        {
                           _loc3_ = new RoomEvent(RoomEvent.ROOM_LEAVE);
                        }
                        dispatchEvent(_loc3_);
                        this.myConnection.removeEventListener(PresenceEvent.PRESENCE,this.handleEvent);
                     }
                  }
               }
               break;
            case "disconnection":
               this.setActive(false);
               removeAll();
               _loc3_ = new RoomEvent(RoomEvent.ROOM_LEAVE);
               dispatchEvent(_loc3_);
         }
      }
      
      private function unlockRoom(param1:Boolean) : void
      {
         var _loc2_:IQ = null;
         var _loc3_:MUCOwnerExtension = null;
         var _loc4_:FormExtension = null;
         if(param1)
         {
            this.requestConfiguration();
         }
         else
         {
            _loc2_ = new IQ(this.roomJID.escaped,IQ.SET_TYPE);
            _loc3_ = new MUCOwnerExtension();
            _loc4_ = new FormExtension();
            _loc4_.type = FormExtension.SUBMIT_TYPE;
            _loc3_.addExtension(_loc4_);
            _loc2_.addExtension(_loc3_);
            this.myConnection.send(_loc2_);
         }
      }
      
      public function requestConfiguration() : void
      {
         var _loc1_:IQ = new IQ(this.roomJID.escaped,IQ.GET_TYPE);
         var _loc2_:MUCOwnerExtension = new MUCOwnerExtension();
         _loc1_.callbackScope = this;
         _loc1_.callbackName = "finish_requestConfiguration";
         _loc1_.addExtension(_loc2_);
         this.myConnection.send(_loc1_);
      }
      
      public function finish_requestConfiguration(param1:IQ) : void
      {
         var _loc4_:RoomEvent = null;
         if(param1.type == IQ.ERROR_TYPE)
         {
            this.finish_admin(param1);
            return;
         }
         var _loc2_:MUCOwnerExtension = param1.getAllExtensionsByNS(MUCOwnerExtension.NS)[0];
         var _loc3_:FormExtension = _loc2_.getAllExtensionsByNS(FormExtension.NS)[0];
         if(_loc3_.type == FormExtension.REQUEST_TYPE)
         {
            _loc4_ = new RoomEvent(RoomEvent.CONFIGURE_ROOM);
            _loc4_.data = _loc3_;
            dispatchEvent(_loc4_);
         }
      }
      
      public function configure(param1:Object) : void
      {
         var _loc4_:FormExtension = null;
         var _loc2_:IQ = new IQ(this.roomJID.escaped,IQ.SET_TYPE);
         var _loc3_:MUCOwnerExtension = new MUCOwnerExtension();
         if(param1 is FormExtension)
         {
            _loc4_ = FormExtension(param1);
         }
         else
         {
            _loc4_ = new FormExtension();
            param1["FORM_TYPE"] = [MUCOwnerExtension.NS];
            _loc4_.setFields(param1);
         }
         _loc4_.type = FormExtension.SUBMIT_TYPE;
         _loc3_.addExtension(_loc4_);
         _loc2_.addExtension(_loc3_);
         this.myConnection.send(_loc2_);
      }
      
      public function cancelConfiguration() : void
      {
         var _loc1_:IQ = new IQ(this.roomJID.escaped,IQ.SET_TYPE);
         var _loc2_:MUCOwnerExtension = new MUCOwnerExtension();
         var _loc3_:FormExtension = new FormExtension();
         _loc3_.type = FormExtension.CANCEL_TYPE;
         _loc2_.addExtension(_loc3_);
         _loc1_.addExtension(_loc2_);
         this.myConnection.send(_loc1_);
      }
      
      public function grant(param1:String, param2:Array) : void
      {
         var _loc5_:UnescapedJID = null;
         var _loc3_:IQ = new IQ(this.roomJID.escaped,IQ.SET_TYPE);
         var _loc4_:MUCOwnerExtension = new MUCOwnerExtension();
         _loc3_.callbackScope = this;
         _loc3_.callback = this.finish_admin;
         for each(_loc5_ in param2)
         {
            _loc4_.addItem(param1,null,null,_loc5_.escaped,null,null);
         }
         _loc3_.addExtension(_loc4_);
         this.connection.send(_loc3_);
      }
      
      public function revoke(param1:Array) : void
      {
         this.grant(Room.NO_AFFILIATION,param1);
      }
      
      public function ban(param1:Array) : void
      {
         var _loc4_:UnescapedJID = null;
         var _loc2_:IQ = new IQ(this.roomJID.escaped,IQ.SET_TYPE);
         var _loc3_:MUCAdminExtension = new MUCAdminExtension();
         _loc2_.callbackScope = this;
         _loc2_.callback = this.finish_admin;
         for each(_loc4_ in param1)
         {
            _loc3_.addItem(Room.OUTCAST_AFFILIATION,null,null,_loc4_.escaped,null,null);
         }
         _loc2_.addExtension(_loc3_);
         this.connection.send(_loc2_);
      }
      
      public function allow(param1:Array) : void
      {
         this.grant(Room.NO_AFFILIATION,param1);
      }
      
      private function finish_admin(param1:IQ) : void
      {
         var _loc2_:RoomEvent = null;
         if(param1.type == IQ.ERROR_TYPE)
         {
            _loc2_ = new RoomEvent(RoomEvent.ADMIN_ERROR);
            _loc2_.errorCondition = param1.errorCondition;
            _loc2_.errorMessage = param1.errorMessage;
            _loc2_.errorType = param1.errorType;
            _loc2_.errorCode = param1.errorCode;
            dispatchEvent(_loc2_);
         }
      }
      
      public function requestAffiliations(param1:String) : void
      {
         var _loc2_:IQ = new IQ(this.roomJID.escaped,IQ.GET_TYPE);
         var _loc3_:MUCOwnerExtension = new MUCOwnerExtension();
         _loc2_.callbackScope = this;
         _loc2_.callbackName = "finish_requestAffiliates";
         _loc3_.addItem(param1);
         _loc2_.addExtension(_loc3_);
         this.connection.send(_loc2_);
      }
      
      private function finish_requestAffiliates(param1:IQ) : void
      {
         var _loc2_:MUCOwnerExtension = null;
         var _loc3_:Array = null;
         var _loc4_:RoomEvent = null;
         this.finish_admin(param1);
         if(param1.type == IQ.RESULT_TYPE)
         {
            _loc2_ = param1.getAllExtensionsByNS(MUCOwnerExtension.NS)[0];
            _loc3_ = _loc2_.getAllItems();
            _loc4_ = new RoomEvent(RoomEvent.AFFILIATIONS);
            _loc4_.data = _loc3_;
            dispatchEvent(_loc4_);
         }
      }
      
      public function destroy(param1:String, param2:UnescapedJID = null, param3:Function = null) : void
      {
         var _loc4_:IQ = new IQ(this.roomJID.escaped,IQ.SET_TYPE);
         var _loc5_:MUCOwnerExtension = new MUCOwnerExtension();
         _loc4_.callback = param3;
         _loc5_.destroy(param1,param2.escaped);
         _loc4_.addExtension(_loc5_);
         this.myConnection.send(_loc4_);
      }
      
      private function getOccupantNamed(param1:String) : RoomOccupant
      {
         var _loc2_:RoomOccupant = null;
         for each(_loc2_ in this)
         {
            if(_loc2_.displayName == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      private function updateRoomRoster(param1:Presence) : void
      {
         var _loc5_:RoomEvent = null;
         var _loc7_:MUCUserExtension = null;
         var _loc8_:MUCStatus = null;
         var _loc2_:String = param1.from.unescaped.resource;
         var _loc3_:Array = param1.getAllExtensionsByNS(MUCUserExtension.NS);
         var _loc4_:MUCItem = _loc3_[0].getAllItems()[0];
         if(this.isThisUser(param1.from.unescaped))
         {
            this.myAffiliation = _loc4_.affiliation;
            dispatchEvent(new Event("affiliationSet"));
            this.myRole = _loc4_.role;
            dispatchEvent(new Event("roleSet"));
            if(!this.isActive && param1.type != Presence.UNAVAILABLE_TYPE)
            {
               this.setActive(true);
               _loc5_ = new RoomEvent(RoomEvent.ROOM_JOIN);
               dispatchEvent(_loc5_);
            }
         }
         var _loc6_:RoomOccupant = this.getOccupantNamed(_loc2_);
         if(Boolean(_loc6_))
         {
            if(param1.type == Presence.UNAVAILABLE_TYPE)
            {
               removeItemAt(getItemIndex(_loc6_));
               _loc7_ = param1.getAllExtensionsByNS(MUCUserExtension.NS)[0];
               for each(_loc8_ in _loc7_.statuses)
               {
                  if(_loc8_.code == 307 || _loc8_.code == 301)
                  {
                     return;
                  }
               }
               this.cleanRosterItemShowStatus(_loc6_.jid);
               _loc5_ = new RoomEvent(RoomEvent.USER_DEPARTURE);
               _loc5_.nickname = _loc2_;
               _loc5_.data = param1;
               dispatchEvent(_loc5_);
            }
            else
            {
               _loc6_.affiliation = _loc4_.affiliation;
               _loc6_.role = _loc4_.role;
               _loc6_.show = param1.show;
               _loc6_.status = param1.status;
            }
         }
         else if(param1.type != Presence.UNAVAILABLE_TYPE)
         {
            addItem(new RoomOccupant(_loc2_,param1.show,_loc4_.affiliation,_loc4_.role,Boolean(_loc4_.jid) ? _loc4_.jid.unescaped : null,this,param1.status));
            _loc5_ = new RoomEvent(RoomEvent.USER_JOIN);
            _loc5_.nickname = _loc2_;
            _loc5_.data = param1;
            dispatchEvent(_loc5_);
         }
      }
      
      private function cleanRosterItemShowStatus(param1:UnescapedJID) : *
      {
         var _loc2_:RosterItemVO = RosterItemVO.get(param1,false);
         if(Boolean(_loc2_) && Boolean(_loc2_.pending) && _loc2_.show == Presence.SHOW_DND)
         {
            _loc2_.show = null;
         }
      }
      
      public function isThisRoom(param1:UnescapedJID) : Boolean
      {
         return Boolean(this.roomJID) && param1.bareJID.toLowerCase() == this.roomJID.bareJID.toLowerCase();
      }
      
      public function isThisUser(param1:UnescapedJID) : Boolean
      {
         return param1.toString().toLowerCase() == this.userJID.toString().toLowerCase();
      }
      
      public function get conferenceServer() : String
      {
         return this.myJID.domain;
      }
      
      public function set conferenceServer(param1:String) : void
      {
         this.roomJID = new UnescapedJID(this.roomName + "@" + param1);
      }
      
      public function get roomName() : String
      {
         return this.myJID.node;
      }
      
      public function set roomName(param1:String) : void
      {
         this.roomJID = new UnescapedJID(param1 + "@" + this.conferenceServer);
      }
      
      public function get nickname() : String
      {
         return this.myNickname == null ? this.myConnection.username : this.myNickname;
      }
      
      public function set nickname(param1:String) : void
      {
         var _loc2_:Presence = null;
         if(this.isActive)
         {
            this.pendingNickname = param1;
            _loc2_ = new Presence(new EscapedJID(this.userJID + "/" + this.pendingNickname));
            this.myConnection.send(_loc2_);
         }
         else
         {
            this.myNickname = param1;
         }
      }
      
      public function get password() : String
      {
         return this.myPassword;
      }
      
      public function set password(param1:String) : void
      {
         this.myPassword = param1;
      }
      
      [Bindable(event="subjectChange")]
      public function get subject() : String
      {
         return this.mySubject;
      }
      
      public function get anonymous() : Boolean
      {
         return this._anonymous;
      }
      
      public function set anonymous(param1:Boolean) : void
      {
         this._anonymous = param1;
      }
      
      override public function toString() : String
      {
         return "[object Room]";
      }
      
      private function wrapWithCDATA(param1:String) : String
      {
         return param1 == null ? param1 : "<![CDATA[" + param1 + "]]>";
      }
      
      private function unwrapCDATA(param1:String) : String
      {
         var _loc3_:int = 0;
         var _loc2_:String = param1;
         if(param1 != null && param1.indexOf("CDATA") > -1)
         {
            _loc3_ = _loc2_.lastIndexOf("]]");
            _loc2_ = param1.substring(9,_loc3_);
         }
         return _loc2_;
      }
   }
}


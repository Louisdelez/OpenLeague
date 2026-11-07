package org.igniterealtime.xiff.conference
{
   import flash.events.EventDispatcher;
   import mx.events.PropertyChangeEvent;
   import org.igniterealtime.xiff.core.UnescapedJID;
   import org.igniterealtime.xiff.data.im.Contact;
   import org.igniterealtime.xiff.data.im.RosterItemVO;
   
   public class RoomOccupant extends EventDispatcher implements Contact
   {
      
      private var _nickname:String;
      
      private var _show:String;
      
      private var _status:String;
      
      private var _affiliation:String;
      
      private var _role:String;
      
      private var _jid:UnescapedJID;
      
      private var _uid:String;
      
      private var _room:Room;
      
      public function RoomOccupant(param1:String, param2:String, param3:String, param4:String, param5:UnescapedJID, param6:Room, param7:String)
      {
         super();
         this.displayName = param1;
         this.show = param2;
         this.affiliation = param3;
         this.role = param4;
         this.jid = param5;
         this.room = param6;
         this.status = param7;
      }
      
      private function set _1012222381online(param1:Boolean) : void
      {
      }
      
      [Bindable(event="propertyChange")]
      public function get online() : Boolean
      {
         return true;
      }
      
      public function set uid(param1:String) : void
      {
         this._uid = param1;
      }
      
      public function get uid() : String
      {
         return this._uid;
      }
      
      public function get rosterItem() : RosterItemVO
      {
         if(!this.jid)
         {
            return null;
         }
         var _loc1_:RosterItemVO = RosterItemVO.get(this.jid,true);
         if(Boolean(_loc1_))
         {
            _loc1_.displayName = this.displayName;
            if(this.show != null)
            {
               _loc1_.show = this.show;
            }
            if(this.status != null && (_loc1_.status == null || _loc1_.status == "" || _loc1_.status == "Offline"))
            {
               _loc1_.status = this.status;
            }
         }
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get jid() : UnescapedJID
      {
         return this._jid;
      }
      
      private function set _105221jid(param1:UnescapedJID) : void
      {
         this._jid = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function get displayName() : String
      {
         return this._nickname;
      }
      
      private function set _1714148973displayName(param1:String) : void
      {
         this._nickname = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function get show() : String
      {
         return this._show;
      }
      
      private function set _3529469show(param1:String) : void
      {
         this._show = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function get status() : String
      {
         return this._status;
      }
      
      private function set _892481550status(param1:String) : void
      {
         this._status = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function get affiliation() : String
      {
         return this._affiliation;
      }
      
      private function set _2019918576affiliation(param1:String) : void
      {
         this._affiliation = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function get role() : String
      {
         return this._role;
      }
      
      private function set _3506294role(param1:String) : void
      {
         this._role = param1;
      }
      
      private function set _3506395room(param1:Room) : void
      {
         this._room = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function get room() : Room
      {
         return this._room;
      }
      
      override public function toString() : String
      {
         return this.displayName;
      }
      
      public function set status(param1:String) : void
      {
         var _loc2_:Object = this.status;
         if(_loc2_ !== param1)
         {
            this._892481550status = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"status",_loc2_,param1));
            }
         }
      }
      
      public function set role(param1:String) : void
      {
         var _loc2_:Object = this.role;
         if(_loc2_ !== param1)
         {
            this._3506294role = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"role",_loc2_,param1));
            }
         }
      }
      
      public function set affiliation(param1:String) : void
      {
         var _loc2_:Object = this.affiliation;
         if(_loc2_ !== param1)
         {
            this._2019918576affiliation = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"affiliation",_loc2_,param1));
            }
         }
      }
      
      public function set show(param1:String) : void
      {
         var _loc2_:Object = this.show;
         if(_loc2_ !== param1)
         {
            this._3529469show = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"show",_loc2_,param1));
            }
         }
      }
      
      public function set jid(param1:UnescapedJID) : void
      {
         var _loc2_:Object = this.jid;
         if(_loc2_ !== param1)
         {
            this._105221jid = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"jid",_loc2_,param1));
            }
         }
      }
      
      public function set displayName(param1:String) : void
      {
         var _loc2_:Object = this.displayName;
         if(_loc2_ !== param1)
         {
            this._1714148973displayName = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"displayName",_loc2_,param1));
            }
         }
      }
      
      public function set room(param1:Room) : void
      {
         var _loc2_:Object = this.room;
         if(_loc2_ !== param1)
         {
            this._3506395room = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"room",_loc2_,param1));
            }
         }
      }
      
      public function set online(param1:Boolean) : void
      {
         var _loc2_:Object = this.online;
         if(_loc2_ !== param1)
         {
            this._1012222381online = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"online",_loc2_,param1));
            }
         }
      }
   }
}


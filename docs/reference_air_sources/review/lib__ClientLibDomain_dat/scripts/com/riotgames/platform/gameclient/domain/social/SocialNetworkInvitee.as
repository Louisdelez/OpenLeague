package com.riotgames.platform.gameclient.domain.social
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class SocialNetworkInvitee implements IEventDispatcher
   {
      
      private var _857185821alreadyFriends:Boolean = false;
      
      private var _1751869106summoner:SocialNetworkSummonerDTO;
      
      private var _951526432contact:SocialNetworkContact;
      
      private var _1939522227summonerInvited:Number = -1;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _398301669isSelected:Boolean;
      
      public function SocialNetworkInvitee()
      {
         super();
      }
      
      public function set contact(param1:SocialNetworkContact) : void
      {
         var _loc2_:Object = this._951526432contact;
         if(_loc2_ !== param1)
         {
            this._951526432contact = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"contact",_loc2_,param1));
         }
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function set isSelected(param1:Boolean) : void
      {
         var _loc2_:Object = this._398301669isSelected;
         if(_loc2_ !== param1)
         {
            this._398301669isSelected = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isSelected",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get summonerInvited() : Number
      {
         return this._1939522227summonerInvited;
      }
      
      [Bindable(event="propertyChange")]
      public function get summoner() : SocialNetworkSummonerDTO
      {
         return this._1751869106summoner;
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function get invited() : Number
      {
         if(this.summonerInvited > 0)
         {
            return this.summonerInvited;
         }
         if(Boolean(this.contact))
         {
            return this.contact.invited;
         }
         return -1;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function set summonerInvited(param1:Number) : void
      {
         var _loc2_:Object = this._1939522227summonerInvited;
         if(_loc2_ !== param1)
         {
            this._1939522227summonerInvited = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerInvited",_loc2_,param1));
         }
      }
      
      public function set summoner(param1:SocialNetworkSummonerDTO) : void
      {
         var _loc2_:Object = this._1751869106summoner;
         if(_loc2_ !== param1)
         {
            this._1751869106summoner = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summoner",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get alreadyFriends() : Boolean
      {
         return this._857185821alreadyFriends;
      }
      
      [Bindable(event="propertyChange")]
      public function get isSelected() : Boolean
      {
         return this._398301669isSelected;
      }
      
      [Bindable(event="propertyChange")]
      public function get contact() : SocialNetworkContact
      {
         return this._951526432contact;
      }
      
      public function get isInvitable() : Boolean
      {
         return !this.alreadyFriends && this.invited <= 0;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function set alreadyFriends(param1:Boolean) : void
      {
         var _loc2_:Object = this._857185821alreadyFriends;
         if(_loc2_ !== param1)
         {
            this._857185821alreadyFriends = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"alreadyFriends",_loc2_,param1));
         }
      }
   }
}


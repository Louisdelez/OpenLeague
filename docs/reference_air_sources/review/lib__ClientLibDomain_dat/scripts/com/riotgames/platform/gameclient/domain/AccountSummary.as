package com.riotgames.platform.gameclient.domain
{
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.account.AccountSummary")]
   public class AccountSummary extends AbstractEventDispatchingDomainObject
   {
      
      private var _504377593summonerName:String;
      
      private var _100526016items:ArrayCollection;
      
      private var _974513803partnerMode:Boolean = false;
      
      private var _92668751admin:Boolean = false;
      
      private var _1106839122hasBetaAccess:Boolean = false;
      
      private var _1827029976accountId:Number;
      
      private var _265713450username:String;
      
      private var _534996951needsPasswordReset:Boolean = false;
      
      private var _647530666summonerInternalName:String;
      
      private var _1256497616groupCount:Number = 0;
      
      public function AccountSummary()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get items() : ArrayCollection
      {
         return this._100526016items;
      }
      
      public function set groupCount(param1:Number) : void
      {
         var _loc2_:Object = this._1256497616groupCount;
         if(_loc2_ !== param1)
         {
            this._1256497616groupCount = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"groupCount",_loc2_,param1));
         }
      }
      
      public function set partnerMode(param1:Boolean) : void
      {
         var _loc2_:Object = this._974513803partnerMode;
         if(_loc2_ !== param1)
         {
            this._974513803partnerMode = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"partnerMode",_loc2_,param1));
         }
      }
      
      public function set username(param1:String) : void
      {
         var _loc2_:Object = this._265713450username;
         if(_loc2_ !== param1)
         {
            this._265713450username = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"username",_loc2_,param1));
         }
      }
      
      public function set needsPasswordReset(param1:Boolean) : void
      {
         var _loc2_:Object = this._534996951needsPasswordReset;
         if(_loc2_ !== param1)
         {
            this._534996951needsPasswordReset = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"needsPasswordReset",_loc2_,param1));
         }
      }
      
      public function set items(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._100526016items;
         if(_loc2_ !== param1)
         {
            this._100526016items = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"items",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get partnerMode() : Boolean
      {
         return this._974513803partnerMode;
      }
      
      public function set summonerInternalName(param1:String) : void
      {
         var _loc2_:Object = this._647530666summonerInternalName;
         if(_loc2_ !== param1)
         {
            this._647530666summonerInternalName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerInternalName",_loc2_,param1));
         }
      }
      
      public function set accountId(param1:Number) : void
      {
         var _loc2_:Object = this._1827029976accountId;
         if(_loc2_ !== param1)
         {
            this._1827029976accountId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"accountId",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get username() : String
      {
         return this._265713450username;
      }
      
      [Bindable(event="propertyChange")]
      public function get groupCount() : Number
      {
         return this._1256497616groupCount;
      }
      
      [Bindable(event="propertyChange")]
      public function get needsPasswordReset() : Boolean
      {
         return this._534996951needsPasswordReset;
      }
      
      [Bindable(event="propertyChange")]
      public function get admin() : Boolean
      {
         return this._92668751admin;
      }
      
      public function set hasBetaAccess(param1:Boolean) : void
      {
         var _loc2_:Object = this._1106839122hasBetaAccess;
         if(_loc2_ !== param1)
         {
            this._1106839122hasBetaAccess = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"hasBetaAccess",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get summonerInternalName() : String
      {
         return this._647530666summonerInternalName;
      }
      
      [Bindable(event="propertyChange")]
      public function get accountId() : Number
      {
         return this._1827029976accountId;
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
      
      public function updateBetaAccess(param1:Boolean) : void
      {
         this.hasBetaAccess = param1;
         this.groupCount += 1;
      }
      
      public function set admin(param1:Boolean) : void
      {
         var _loc2_:Object = this._92668751admin;
         if(_loc2_ !== param1)
         {
            this._92668751admin = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"admin",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get summonerName() : String
      {
         return this._504377593summonerName;
      }
      
      [Bindable(event="propertyChange")]
      public function get hasBetaAccess() : Boolean
      {
         return this._1106839122hasBetaAccess;
      }
   }
}


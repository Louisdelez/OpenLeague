package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.game.PlayerCredentialsDto")]
   public class PlayerCredentialsDTO implements IEventDispatcher
   {
      
      private var _1826037148serverPort:int;
      
      private var _1141952446handshakeToken:String;
      
      private var _772467878observerEncryptionKey:String;
      
      private var _1980047598platformId:String;
      
      private var _348607190observer:Boolean;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _103663511mapId:int;
      
      private var _1769142708gameType:String;
      
      private var _1379103690serverIp:String;
      
      private var _1253236563gameId:Number;
      
      private var _1879273436playerId:Number;
      
      private var _898564646observerServerPort:int;
      
      private var _36224036encryptionKey:String;
      
      private var _1869089600observerServerIp:String;
      
      public function PlayerCredentialsDTO()
      {
         super();
      }
      
      public function set handshakeToken(param1:String) : void
      {
         var _loc2_:Object = this._1141952446handshakeToken;
         if(_loc2_ !== param1)
         {
            this._1141952446handshakeToken = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"handshakeToken",_loc2_,param1));
         }
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function set observerServerIp(param1:String) : void
      {
         var _loc2_:Object = this._1869089600observerServerIp;
         if(_loc2_ !== param1)
         {
            this._1869089600observerServerIp = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"observerServerIp",_loc2_,param1));
         }
      }
      
      public function set serverIp(param1:String) : void
      {
         var _loc2_:Object = this._1379103690serverIp;
         if(_loc2_ !== param1)
         {
            this._1379103690serverIp = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"serverIp",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get mapId() : int
      {
         return this._103663511mapId;
      }
      
      public function set gameType(param1:String) : void
      {
         var _loc2_:Object = this._1769142708gameType;
         if(_loc2_ !== param1)
         {
            this._1769142708gameType = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameType",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get observerEncryptionKey() : String
      {
         return this._772467878observerEncryptionKey;
      }
      
      public function set observer(param1:Boolean) : void
      {
         var _loc2_:Object = this._348607190observer;
         if(_loc2_ !== param1)
         {
            this._348607190observer = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"observer",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get gameId() : Number
      {
         return this._1253236563gameId;
      }
      
      public function set observerServerPort(param1:int) : void
      {
         var _loc2_:Object = this._898564646observerServerPort;
         if(_loc2_ !== param1)
         {
            this._898564646observerServerPort = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"observerServerPort",_loc2_,param1));
         }
      }
      
      public function set playerId(param1:Number) : void
      {
         var _loc2_:Object = this._1879273436playerId;
         if(_loc2_ !== param1)
         {
            this._1879273436playerId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"playerId",_loc2_,param1));
         }
      }
      
      public function set mapId(param1:int) : void
      {
         var _loc2_:Object = this._103663511mapId;
         if(_loc2_ !== param1)
         {
            this._103663511mapId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mapId",_loc2_,param1));
         }
      }
      
      public function set encryptionKey(param1:String) : void
      {
         var _loc2_:Object = this._36224036encryptionKey;
         if(_loc2_ !== param1)
         {
            this._36224036encryptionKey = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"encryptionKey",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get handshakeToken() : String
      {
         return this._1141952446handshakeToken;
      }
      
      [Bindable(event="propertyChange")]
      public function get observerServerIp() : String
      {
         return this._1869089600observerServerIp;
      }
      
      [Bindable(event="propertyChange")]
      public function get serverIp() : String
      {
         return this._1379103690serverIp;
      }
      
      public function set observerEncryptionKey(param1:String) : void
      {
         var _loc2_:Object = this._772467878observerEncryptionKey;
         if(_loc2_ !== param1)
         {
            this._772467878observerEncryptionKey = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"observerEncryptionKey",_loc2_,param1));
         }
      }
      
      public function set serverPort(param1:int) : void
      {
         var _loc2_:Object = this._1826037148serverPort;
         if(_loc2_ !== param1)
         {
            this._1826037148serverPort = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"serverPort",_loc2_,param1));
         }
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      [Bindable(event="propertyChange")]
      public function get gameType() : String
      {
         return this._1769142708gameType;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      [Bindable(event="propertyChange")]
      public function get observer() : Boolean
      {
         return this._348607190observer;
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function set gameId(param1:Number) : void
      {
         var _loc2_:Object = this._1253236563gameId;
         if(_loc2_ !== param1)
         {
            this._1253236563gameId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameId",_loc2_,param1));
         }
      }
      
      public function set platformId(param1:String) : void
      {
         var _loc2_:Object = this._1980047598platformId;
         if(_loc2_ !== param1)
         {
            this._1980047598platformId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"platformId",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get observerServerPort() : int
      {
         return this._898564646observerServerPort;
      }
      
      [Bindable(event="propertyChange")]
      public function get serverPort() : int
      {
         return this._1826037148serverPort;
      }
      
      public function toString() : String
      {
         return "PlayerCredentialsDTO\n\r" + "\tgameId: " + this.gameId.toString() + "\n\r\tplayerId: " + this.playerId.toString() + "\n\r\tserverIP: " + this.serverIp + "\n\r\tserverPort: " + this.serverPort.toString() + "\n\r\tobserverServerIP: " + this.observerServerIp + "\n\r\tobserverServerPort: " + this.observerServerPort.toString() + "\n\r\tobserver: " + this.observer.toString();
      }
      
      [Bindable(event="propertyChange")]
      public function get platformId() : String
      {
         return this._1980047598platformId;
      }
      
      [Bindable(event="propertyChange")]
      public function get playerId() : Number
      {
         return this._1879273436playerId;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get encryptionKey() : String
      {
         return this._36224036encryptionKey;
      }
   }
}


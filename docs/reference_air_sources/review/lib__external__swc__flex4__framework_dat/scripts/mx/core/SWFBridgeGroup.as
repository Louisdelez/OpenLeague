package mx.core
{
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.Dictionary;
   import mx.events.DynamicEvent;
   import mx.managers.ISystemManager;
   
   use namespace mx_internal;
   
   public class SWFBridgeGroup extends EventDispatcher implements ISWFBridgeGroup
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private var _groupOwner:ISystemManager;
      
      private var _childBridges:Dictionary;
      
      private var _parentBridge:IEventDispatcher;
      
      public function SWFBridgeGroup(owner:ISystemManager)
      {
         super();
         this._groupOwner = owner;
      }
      
      public function get parentBridge() : IEventDispatcher
      {
         return this._parentBridge;
      }
      
      public function set parentBridge(bridge:IEventDispatcher) : void
      {
         this._parentBridge = bridge;
      }
      
      public function addChildBridge(bridge:IEventDispatcher, bridgeProvider:ISWFBridgeProvider) : void
      {
         if(!this._childBridges)
         {
            this._childBridges = new Dictionary();
         }
         this._childBridges[bridge] = bridgeProvider;
         var event:DynamicEvent = new DynamicEvent("addChildBridge");
         event.bridge = bridge;
         event.bridgeProvider = bridgeProvider;
         dispatchEvent(event);
      }
      
      public function removeChildBridge(bridge:IEventDispatcher) : void
      {
         var iter:Object = null;
         var event:DynamicEvent = null;
         if(!this._childBridges || !bridge)
         {
            return;
         }
         for(iter in this._childBridges)
         {
            if(iter == bridge)
            {
               delete this._childBridges[iter];
            }
         }
         event = new DynamicEvent("removeChildBridge");
         event.bridge = bridge;
         dispatchEvent(event);
      }
      
      public function getChildBridgeProvider(bridge:IEventDispatcher) : ISWFBridgeProvider
      {
         if(!this._childBridges)
         {
            return null;
         }
         return ISWFBridgeProvider(this._childBridges[bridge]);
      }
      
      public function getChildBridges() : Array
      {
         var iter:Object = null;
         var bridges:Array = [];
         for(iter in this._childBridges)
         {
            bridges.push(iter);
         }
         return bridges;
      }
      
      public function containsBridge(bridge:IEventDispatcher) : Boolean
      {
         var iter:Object = null;
         if(Boolean(this.parentBridge) && this.parentBridge == bridge)
         {
            return true;
         }
         for(iter in this._childBridges)
         {
            if(bridge == iter)
            {
               return true;
            }
         }
         return false;
      }
   }
}


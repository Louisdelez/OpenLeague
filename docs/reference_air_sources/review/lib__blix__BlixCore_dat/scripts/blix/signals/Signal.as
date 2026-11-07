package blix.signals
{
   import blix.ds.LinkedList;
   import flash.utils.Dictionary;
   
   public class Signal implements ISignal, IDispatcher
   {
      
      protected var listeners:LinkedList = new LinkedList();
      
      protected var listenerDict:Dictionary = new Dictionary();
      
      public function Signal()
      {
         super();
      }
      
      public function add(param1:Function, param2:Boolean = false) : ListenerListItem
      {
         if(param1 in this.listenerDict)
         {
            return this.listenerDict[param1];
         }
         return this.registerListener(param1,false,param2);
      }
      
      public function addItem(param1:ListenerListItem) : void
      {
         this.listeners.push(param1);
         this.listenerDict[param1.func] = param1;
      }
      
      public function addOnce(param1:Function, param2:Boolean = false) : ListenerListItem
      {
         if(param1 in this.listenerDict)
         {
            return this.listenerDict[param1];
         }
         return this.registerListener(param1,true,param2);
      }
      
      protected function registerListener(param1:Function, param2:Boolean, param3:Boolean) : ListenerListItem
      {
         var _loc4_:ListenerListItem = new ListenerListItem(param1,param2,param3);
         this.listenerDict[param1] = _loc4_;
         this.listeners.push(_loc4_);
         return _loc4_;
      }
      
      public function remove(param1:Function) : void
      {
         var _loc2_:ListenerListItem = this.listenerDict[param1];
         if(_loc2_ != null)
         {
            this.removeItem(_loc2_);
         }
      }
      
      public function removeItem(param1:ListenerListItem) : void
      {
         if(param1 == null)
         {
            return;
         }
         delete this.listenerDict[param1.func];
         this.listeners.removeItem(param1);
      }
      
      public function removeAll() : void
      {
         this.listenerDict = new Dictionary();
         this.listeners.removeAll();
      }
      
      public function dispatch(... rest) : void
      {
         var _loc3_:ListenerListItem = null;
         var _loc2_:ListenerListItem = this.listeners.getHead();
         var _loc4_:ListenerListItem = this.listeners.getTail();
         var _loc5_:uint = uint(rest.length);
         while(_loc2_ != null)
         {
            _loc3_ = _loc2_.next;
            if(_loc2_.isOnce)
            {
               delete this.listenerDict[_loc2_.func];
               this.listeners.removeItem(_loc2_);
            }
            if(_loc5_ == 0 || !_loc2_.forceParams && _loc2_.func.length == 0)
            {
               _loc2_.func();
            }
            else if(_loc5_ == 1)
            {
               _loc2_.func(rest[0]);
            }
            else if(_loc5_ == 2)
            {
               _loc2_.func(rest[0],rest[1]);
            }
            else
            {
               _loc2_.func.apply(null,rest);
            }
            if(_loc2_ == _loc4_)
            {
               break;
            }
            _loc2_ = _loc3_;
         }
      }
      
      public function getHasListeners() : Boolean
      {
         return this.listeners.getHead() != null;
      }
   }
}


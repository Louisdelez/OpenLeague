package com.degrafa.core.collections
{
   import com.degrafa.core.DegrafaObject;
   import com.degrafa.core.IDegrafaObject;
   import flash.utils.getQualifiedClassName;
   import mx.events.PropertyChangeEvent;
   
   public class DegrafaCollection extends DegrafaObject
   {
      
      private var _items:Array = [];
      
      protected var _cursor:DegrafaCursor;
      
      private var _enableTypeChecking:Boolean = true;
      
      private var type:Class;
      
      public function DegrafaCollection(param1:Class, param2:Array = null, param3:Boolean = false, param4:Boolean = true)
      {
         super();
         this.type = param1;
         _enableTypeChecking = param4;
         suppressEventProcessing = param3;
         if(param2)
         {
            items = param2;
         }
      }
      
      public function get items() : Array
      {
         return _items;
      }
      
      public function get cursor() : DegrafaCursor
      {
         if(!_cursor)
         {
            _cursor = new DegrafaCursor(items);
         }
         return _cursor;
      }
      
      public function reverse() : Array
      {
         var _loc1_:Array = _items;
         items = items.reverse();
         initChange("items",_loc1_,_items,this);
         return items;
      }
      
      private function checkValidTypes(param1:Array) : void
      {
         var _loc2_:Object = null;
         if(_enableTypeChecking)
         {
            for each(_loc2_ in param1)
            {
               if(!_loc2_ is type)
               {
                  throw new TypeError(getQualifiedClassName(_loc2_) + " is not a valid " + getQualifiedClassName(type));
               }
            }
         }
      }
      
      public function set items(param1:Array) : void
      {
         var _loc2_:Array = null;
         if(param1 == null)
         {
            param1 = [];
         }
         checkValidTypes(param1);
         if(param1 != _items)
         {
            if(Boolean(_items && _items.length) && Boolean(enableEvents) && hasEventManager)
            {
               removeListeners();
            }
            _loc2_ = _items;
            _items = param1;
            if(enableEvents && hasEventManager)
            {
               if(Boolean(param1.length) || Boolean(_loc2_.length))
               {
                  initChange("items",_loc2_,_items,this);
               }
            }
         }
         if(Boolean(param1) && Boolean(param1.length))
         {
            addListeners();
         }
      }
      
      public function indexOf(param1:*, param2:int = 0) : int
      {
         return items.indexOf(param1,param2);
      }
      
      public function unshift(... rest) : uint
      {
         checkValidTypes(rest);
         var _loc2_:Array = _items;
         var _loc3_:int = 0;
         var _loc4_:int = int(rest.length);
         while(_loc3_ < _loc4_)
         {
            addListener(rest[_loc3_]);
            items.unshift(rest[_loc3_]);
            _loc3_++;
         }
         initChange("items",_loc2_,_items,this);
         return items.length;
      }
      
      public function pop() : *
      {
         removeListener(items[items.length - 1]);
         var _loc1_:Array = _items;
         var _loc2_:* = items.pop();
         initChange("items",_loc1_,_items,this);
         return _loc2_;
      }
      
      public function slice(param1:int = 0, param2:int = 16777215) : Array
      {
         return items.slice(param1,param2);
      }
      
      public function lastIndexOf(param1:*, param2:int = 2147483647) : int
      {
         return items.lastIndexOf(param1,param2);
      }
      
      public function concat(... rest) : Array
      {
         var _loc2_:Array = _items;
         checkValidTypes(rest);
         var _loc3_:int = 0;
         var _loc4_:int = int(rest.length);
         while(_loc3_ < _loc4_)
         {
            addListener(rest[_loc3_]);
            _loc3_++;
         }
         _items = items.concat(rest);
         initChange("items",_loc2_,_items,this);
         return _items;
      }
      
      protected function _addItem(param1:*) : *
      {
         addListener(param1);
         concat(param1);
         return param1;
      }
      
      protected function _removeItem(param1:*) : *
      {
         var _loc2_:int = indexOf(param1,0);
         _removeItemAt(_loc2_);
         return null;
      }
      
      public function get enableTypeChecking() : Boolean
      {
         return _enableTypeChecking;
      }
      
      public function removeListener(param1:*) : void
      {
         if(param1 is IDegrafaObject)
         {
            IDegrafaObject(param1).parent = null;
            IDegrafaObject(param1).removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,propertyChangeHandler);
         }
      }
      
      public function push(... rest) : uint
      {
         var _loc2_:Array = _items;
         checkValidTypes(rest);
         var _loc3_:int = 0;
         var _loc4_:int = int(rest.length);
         while(_loc3_ < _loc4_)
         {
            addListener(rest[_loc3_]);
            items.push(rest[_loc3_]);
            _loc3_++;
         }
         initChange("items",_loc2_,_items,this);
         return items.length;
      }
      
      public function removeListeners() : void
      {
         var _loc1_:Object = null;
         for each(_loc1_ in items)
         {
            if(_loc1_ is IDegrafaObject)
            {
               IDegrafaObject(_loc1_).parent = null;
               IDegrafaObject(_loc1_).removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,propertyChangeHandler);
            }
         }
      }
      
      protected function _setItemIndex(param1:*, param2:Number) : Boolean
      {
         var _loc3_:Array = items.splice(items.indexOf(param1),1);
         items.splice(param2,0,_loc3_[0]);
         return true;
      }
      
      protected function _getItemAt(param1:Number) : *
      {
         return items[param1];
      }
      
      public function addListeners() : void
      {
         var _loc1_:Object = null;
         if(enableEvents)
         {
            for each(_loc1_ in items)
            {
               if(_loc1_ is IDegrafaObject)
               {
                  IDegrafaObject(_loc1_).parent = this.parent;
                  if(IDegrafaObject(_loc1_).enableEvents)
                  {
                     IDegrafaObject(_loc1_).addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,propertyChangeHandler);
                  }
               }
            }
         }
      }
      
      public function every(param1:Function, param2:* = null) : Boolean
      {
         return items.every(param1,param2);
      }
      
      public function map(param1:Function, param2:* = null) : Array
      {
         return items.map(param1,param2);
      }
      
      public function shift() : *
      {
         removeListener(items[0]);
         var _loc1_:Array = _items;
         var _loc2_:* = items.shift();
         initChange("items",_loc1_,_items,this);
         return _loc2_;
      }
      
      public function propertyChangeHandler(param1:PropertyChangeEvent) : void
      {
         if(!suppressEventProcessing)
         {
            dispatchEvent(param1);
         }
      }
      
      protected function _getItemIndex(param1:*) : int
      {
         return indexOf(param1,0);
      }
      
      protected function _removeItemAt(param1:Number) : *
      {
         removeListener(items[param1]);
         return splice(param1,1)[0];
      }
      
      public function forEach(param1:Function, param2:* = null) : void
      {
         items.forEach(param1,param2);
      }
      
      public function sort(... rest) : Array
      {
         return items.sort(rest);
      }
      
      public function set enableTypeChecking(param1:Boolean) : void
      {
         _enableTypeChecking = param1;
      }
      
      protected function _addItemAt(param1:Object, param2:Number) : *
      {
         addListener(param1);
         splice(param2,0,param1);
         return param1;
      }
      
      public function join(param1:*) : String
      {
         return items.join(param1);
      }
      
      public function addListener(param1:*) : void
      {
         if(param1 is IDegrafaObject)
         {
            IDegrafaObject(param1).parent = this.parent;
            if(enableEvents)
            {
               if(IDegrafaObject(param1).enableEvents)
               {
                  IDegrafaObject(param1).addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,propertyChangeHandler);
               }
            }
         }
      }
      
      public function filter(param1:Function, param2:* = null) : Array
      {
         return items.filter(param1,param2);
      }
      
      public function some(param1:Function, param2:* = null) : Boolean
      {
         return items.some(param1,param2);
      }
      
      public function splice(param1:int, param2:uint, ... rest) : Array
      {
         var _loc7_:Array = null;
         checkValidTypes(rest);
         var _loc4_:int = 0;
         var _loc5_:int = int(rest.length);
         while(_loc4_ < _loc5_)
         {
            addListener(rest[_loc4_]);
            _loc4_++;
         }
         var _loc6_:Array = _items;
         if(rest.length == 1)
         {
            _loc7_ = _items.splice(param1,param2,rest[0]);
         }
         else if(rest.length > 1)
         {
            _loc7_ = _items.splice(param1,param2,rest);
         }
         else
         {
            _loc7_ = _items.splice(param1,param2);
         }
         if(_loc7_)
         {
            _loc5_ = int(_loc7_.length);
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               removeListener(_loc7_[_loc4_]);
               _loc4_++;
            }
         }
         initChange("items",_loc6_,_items,this);
         return _loc7_;
      }
      
      public function sortOn(param1:Object, param2:Object = null) : Array
      {
         return items.sortOn(param1,param2);
      }
   }
}


package system.data.maps
{
   import flash.utils.Dictionary;
   import system.Reflection;
   import system.data.Iterator;
   import system.data.Map;
   import system.data.iterators.ArrayIterator;
   import system.data.iterators.MapIterator;
   import system.eden;
   
   public dynamic class HashMap implements Map
   {
      
      private var _values:*;
      
      private var _keys:*;
      
      private var _size:uint;
      
      public function HashMap(... rest)
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         super();
         clear();
         var _loc2_:Array = rest[0] as Array;
         var _loc3_:Array = rest[1] as Array;
         if(_loc2_ != null && _loc3_ != null)
         {
            if(_loc2_.length > 0 && _loc2_.length == _loc3_.length)
            {
               _loc4_ = int(_loc2_.length);
               _loc5_ = 0;
               while(_loc5_ < _loc4_)
               {
                  put(_loc2_[_loc5_],_loc3_[_loc5_]);
                  _loc5_++;
               }
            }
         }
      }
      
      public function containsKey(param1:*) : Boolean
      {
         return _keys[param1] !== undefined;
      }
      
      public function size() : uint
      {
         return _size;
      }
      
      public function isEmpty() : Boolean
      {
         return _size == 0;
      }
      
      public function remove(param1:*) : *
      {
         var _loc3_:* = undefined;
         var _loc4_:uint = 0;
         var _loc2_:* = param1;
         if(containsKey(_loc2_))
         {
            --_size;
            _loc3_ = _keys[_loc2_];
            _loc4_ = uint(_values[_loc3_]);
            if(_loc4_ > 1)
            {
               _values[_loc3_] = _loc4_ - 1;
            }
            else
            {
               delete _values[_loc3_];
            }
            delete _keys[_loc2_];
            return _loc3_;
         }
         return null;
      }
      
      public function putAll(param1:Map) : void
      {
         var _loc5_:int = 0;
         var _loc2_:Array = param1.getValues();
         var _loc3_:Array = param1.getKeys();
         var _loc4_:int = int(_loc3_.length);
         while(_loc5_ < _loc4_)
         {
            put(_loc3_[_loc5_],_loc2_[_loc5_]);
            _loc5_ -= -1;
         }
      }
      
      public function clear() : void
      {
         _keys = new Dictionary(true);
         _values = new Dictionary(true);
         _size = 0;
      }
      
      public function getValues() : Array
      {
         var _loc2_:* = undefined;
         var _loc1_:Array = [];
         for each(_loc2_ in _keys)
         {
            _loc1_.push(_loc2_);
         }
         return _loc1_;
      }
      
      public function put(param1:*, param2:*) : *
      {
         var _loc3_:* = null;
         if(containsKey(param1))
         {
            _loc3_ = _keys[param1];
            remove(param1);
         }
         var _loc4_:uint = uint(_values[param2]);
         _values[param2] = _loc4_ > 0 ? _loc4_ + 1 : 1;
         ++_size;
         _keys[param1] = param2;
         return _loc3_;
      }
      
      public function containsValue(param1:*) : Boolean
      {
         return _values[param1] !== undefined;
      }
      
      public function clone() : *
      {
         var _loc1_:HashMap = new HashMap();
         _loc1_.putAll(this);
         return _loc1_;
      }
      
      public function get(param1:*) : *
      {
         return _keys[param1];
      }
      
      public function getKeys() : Array
      {
         var _loc2_:* = undefined;
         var _loc1_:Array = [];
         for(_loc2_ in _keys)
         {
            _loc1_.push(_loc2_);
         }
         return _loc1_;
      }
      
      public function toString() : String
      {
         return formatter.format(this);
      }
      
      public function iterator() : Iterator
      {
         return new MapIterator(this);
      }
      
      public function toSource(param1:int = 0) : String
      {
         return "new " + Reflection.getClassPath(this) + "(" + eden.serialize(getKeys()) + "," + eden.serialize(getValues()) + ")";
      }
      
      public function keyIterator() : Iterator
      {
         return new ArrayIterator(getKeys());
      }
   }
}


package system.data.sets
{
   import system.Reflection;
   import system.data.Iterable;
   import system.data.Iterator;
   import system.data.Map;
   import system.data.Set;
   import system.data.collections.ArrayCollection;
   import system.data.iterators.ArrayIterator;
   
   public class CoreSet extends ArrayCollection implements Set
   {
      
      private static const PRESENT:Object = new Object();
      
      private var _map:Map;
      
      public function CoreSet(param1:Map, param2:* = null)
      {
         super();
         if(param1 == null)
         {
            throw new ArgumentError(Reflection.getClassName(this) + " constructor failed, the internal Map not must be null.");
         }
         _map = param1;
         if(param2 == null)
         {
            return;
         }
         var _loc3_:Iterator = null;
         if(param2 is Array)
         {
            _loc3_ = new ArrayIterator(param2 as Array);
         }
         else if(param2 is Iterable)
         {
            _loc3_ = (param2 as Iterable).iterator();
         }
         if(_loc3_ != null)
         {
            while(_loc3_.hasNext())
            {
               add(_loc3_.next());
            }
         }
      }
      
      override public function isEmpty() : Boolean
      {
         return _map.isEmpty();
      }
      
      override public function clone() : *
      {
         return new CoreSet(_map.clone(),toArray());
      }
      
      override public function get(param1:*) : *
      {
         return _map.getKeys()[param1];
      }
      
      override public function contains(param1:*) : Boolean
      {
         return _map.containsKey(param1);
      }
      
      override public function add(param1:*) : Boolean
      {
         if(param1 === undefined)
         {
            return false;
         }
         return _map.put(param1,PRESENT) == null;
      }
      
      override public function indexOf(param1:*, param2:uint = 0) : int
      {
         return _map.getKeys().indexOf(param1,param2);
      }
      
      override public function remove(param1:*) : *
      {
         return _map.remove(param1) == PRESENT;
      }
      
      override public function clear() : void
      {
         _map.clear();
      }
      
      override public function iterator() : Iterator
      {
         return _map.keyIterator();
      }
      
      override public function size() : uint
      {
         return _map.size();
      }
      
      override public function toArray() : Array
      {
         return _map.getKeys();
      }
   }
}


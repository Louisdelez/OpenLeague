package system.data.collections
{
   import system.Equatable;
   import system.Reflection;
   import system.data.Collection;
   import system.data.Iterable;
   import system.data.Iterator;
   import system.data.iterators.ArrayIterator;
   import system.serializers.eden.BuiltinSerializer;
   
   public class ArrayCollection implements Collection, Equatable
   {
      
      protected var _a:Array;
      
      public function ArrayCollection(param1:* = null)
      {
         var _loc2_:Array = null;
         var _loc3_:Iterator = null;
         super();
         if(param1 is Collection)
         {
            param1 = param1.toArray();
         }
         else if(param1 is Iterable)
         {
            _loc2_ = [];
            _loc3_ = (param1 as Iterable).iterator();
            while(_loc3_.hasNext())
            {
               _loc2_.push(_loc3_.next());
            }
            param1 = _loc2_;
         }
         if(param1 as Array != null && param1.length > 0)
         {
            _a = param1.slice();
         }
         else
         {
            _a = [];
         }
      }
      
      public function addAll(param1:Collection) : Boolean
      {
         var _loc2_:Iterator = null;
         if(param1 == null)
         {
            return false;
         }
         if(param1.size() > 0)
         {
            _loc2_ = param1.iterator();
            while(_loc2_.hasNext())
            {
               add(_loc2_.next());
            }
            return true;
         }
         return false;
      }
      
      public function size() : uint
      {
         return _a.length;
      }
      
      public function containsAll(param1:Collection) : Boolean
      {
         var _loc2_:Iterator = param1.iterator();
         while(_loc2_.hasNext())
         {
            if(!contains(_loc2_.next()))
            {
               return false;
            }
         }
         return true;
      }
      
      public function isEmpty() : Boolean
      {
         return _a.length == 0;
      }
      
      public function remove(param1:*) : *
      {
         var _loc3_:* = undefined;
         var _loc2_:Iterator = iterator();
         if(param1 != null)
         {
            do
            {
               if(_loc2_.hasNext())
               {
                  continue;
               }
            }
            while(_loc3_ = _loc2_.next(), param1 != _loc3_);
            _loc2_.remove();
            return true;
         }
         while(_loc2_.hasNext())
         {
            if(_loc2_.next() == null)
            {
               _loc2_.remove();
               return true;
            }
         }
         return false;
      }
      
      public function indexOf(param1:*, param2:uint = 0) : int
      {
         return _a.indexOf(param1,param2);
      }
      
      public function clear() : void
      {
         _a.splice(0);
      }
      
      public function retainAll(param1:Collection) : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc3_:Iterator = iterator();
         while(_loc3_.hasNext())
         {
            if(!param1.contains(_loc3_.next()))
            {
               _loc3_.remove();
               _loc2_ = true;
            }
         }
         return _loc2_;
      }
      
      public function clone() : *
      {
         return new ArrayCollection(toArray());
      }
      
      public function toArray() : Array
      {
         return _a;
      }
      
      public function contains(param1:*) : Boolean
      {
         return _a.indexOf(param1) > -1;
      }
      
      public function get(param1:*) : *
      {
         return _a[param1];
      }
      
      public function add(param1:*) : Boolean
      {
         if(param1 === undefined)
         {
            return false;
         }
         _a.push(param1);
         return true;
      }
      
      public function toString() : String
      {
         return formatter.format(this);
      }
      
      public function iterator() : Iterator
      {
         return new ArrayIterator(toArray());
      }
      
      public function toSource(param1:int = 0) : String
      {
         var _loc2_:String = "new " + Reflection.getClassPath(this) + "(";
         var _loc3_:Array = toArray();
         if(_loc3_.length > 0)
         {
            _loc2_ += BuiltinSerializer.emitArray(_loc3_);
         }
         return _loc2_ + ")";
      }
      
      public function removeAll(param1:Collection) : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc3_:Iterator = iterator();
         while(_loc3_.hasNext())
         {
            if(param1.contains(_loc3_.next()))
            {
               _loc3_.remove();
               _loc2_ = true;
            }
         }
         return _loc2_;
      }
      
      public function equals(param1:*) : Boolean
      {
         if(param1 == this)
         {
            return true;
         }
         if(Reflection.getClassPath(this) != Reflection.getClassPath(param1))
         {
            return false;
         }
         var _loc2_:Collection = param1 as Collection;
         if(_loc2_ == null || _loc2_.size() != size())
         {
            return false;
         }
         return this.containsAll(_loc2_);
      }
   }
}


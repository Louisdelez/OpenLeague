package system.data.lists
{
   import system.Reflection;
   import system.data.Collection;
   import system.data.List;
   import system.data.ListIterator;
   import system.data.collections.ArrayCollection;
   import system.data.iterators.ArrayListIterator;
   
   public class ArrayList extends ArrayCollection implements List
   {
      
      protected var _modCount:int;
      
      public function ArrayList(param1:* = null)
      {
         super(param1);
         if(param1 is uint)
         {
            ensureCapacity(param1 as uint);
         }
         _modCount = 0;
      }
      
      override public function remove(param1:*) : *
      {
         ++_modCount;
         return super.remove(param1);
      }
      
      override public function addAll(param1:Collection) : Boolean
      {
         ++_modCount;
         return super.addAll(param1);
      }
      
      override public function clear() : void
      {
         ++_modCount;
         super.clear();
      }
      
      public function lastIndexOf(param1:*, param2:int = 2147483647) : int
      {
         return _a.lastIndexOf(param1,param2);
      }
      
      public function removeAt(param1:uint, param2:int = 1) : *
      {
         ++_modCount;
         param2 = param2 > 1 ? param2 : 1;
         return _a.splice(param1,param2);
      }
      
      public function ensureCapacity(param1:uint) : void
      {
         ++_modCount;
         _a.length = param1;
      }
      
      public function removeRange(param1:uint, param2:uint) : *
      {
         if(param1 == param2)
         {
            return null;
         }
         var _loc3_:int = param2 - param1;
         return removeAt(param1,_loc3_);
      }
      
      override public function add(param1:*) : Boolean
      {
         ++_modCount;
         return super.add(param1);
      }
      
      public function set(param1:uint, param2:*) : *
      {
         if(param1 > size() - 1)
         {
            throw new RangeError("The " + Reflection.getClassName(this) + ".set() method failed, the index \'" + param1 + "\' argument is out of the size limit.");
         }
         var _loc3_:* = _a[param1];
         if(_loc3_ === undefined)
         {
            return undefined;
         }
         if(param2 === undefined)
         {
            removeAt(param1);
         }
         else
         {
            ++_modCount;
            _a[param1] = param2;
         }
         return _loc3_;
      }
      
      override public function clone() : *
      {
         return new ArrayList(toArray());
      }
      
      public function set modCount(param1:int) : void
      {
         _modCount = param1;
      }
      
      public function listIterator(param1:uint = 0) : ListIterator
      {
         return new ArrayListIterator(this,param1);
      }
      
      public function get modCount() : int
      {
         return _modCount;
      }
      
      public function addAt(param1:uint, param2:*) : void
      {
         if(param1 > size())
         {
            throw new RangeError(Reflection.getClassName(this) + ".addAt method failed, the specified index \'" + param1 + "\' is out of bounds.");
         }
         ++_modCount;
         _a.splice(param1,0,param2);
      }
      
      public function subList(param1:uint, param2:uint) : List
      {
         if(param1 > size())
         {
            throw new RangeError("The " + Reflection.getClassName(this) + ".subList() method failed, the fromIndex \'" + param1 + "\' argument is out of the size limit.");
         }
         if(param2 > size())
         {
            throw new RangeError("The " + Reflection.getClassName(this) + ".subList() method failed, the toIndex \'" + param2 + "\' argument is out of the size limit.");
         }
         var _loc3_:Array = [];
         var _loc4_:int = int(param1);
         while(_loc4_ < param2)
         {
            _loc3_.push(get(_loc4_));
            _loc4_++;
         }
         return new ArrayList(_loc3_);
      }
   }
}


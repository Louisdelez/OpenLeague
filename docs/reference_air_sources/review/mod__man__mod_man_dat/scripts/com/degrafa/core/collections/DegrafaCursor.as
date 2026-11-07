package com.degrafa.core.collections
{
   import mx.collections.CursorBookmark;
   
   public class DegrafaCursor
   {
      
      protected static const BEFORE_FIRST_INDEX:int = -1;
      
      protected static const AFTER_LAST_INDEX:int = -2;
      
      public var currentIndex:int;
      
      public var source:Array;
      
      public function DegrafaCursor(param1:Array)
      {
         super();
         this.source = param1;
         currentIndex = BEFORE_FIRST_INDEX;
      }
      
      public function insert(param1:*) : void
      {
         var _loc2_:int = 0;
         if(afterLast || beforeFirst)
         {
            source.push(param1);
         }
         else
         {
            source.splice(currentIndex,0,param1);
         }
      }
      
      public function get afterLast() : Boolean
      {
         return currentIndex == AFTER_LAST_INDEX || source.length == 0;
      }
      
      public function moveNext() : Boolean
      {
         if(afterLast)
         {
            return false;
         }
         var _loc1_:int = beforeFirst ? 0 : int(currentIndex + 1);
         if(_loc1_ >= source.length)
         {
            _loc1_ = AFTER_LAST_INDEX;
         }
         currentIndex = _loc1_;
         return !afterLast;
      }
      
      public function moveLast() : void
      {
         currentIndex = source.length;
      }
      
      public function movePrevious() : Boolean
      {
         if(beforeFirst)
         {
            return false;
         }
         var _loc1_:int = afterLast ? int(source.length - 1) : int(currentIndex - 1);
         currentIndex = _loc1_;
         return !beforeFirst;
      }
      
      public function get beforeFirst() : Boolean
      {
         return currentIndex == BEFORE_FIRST_INDEX || source.length == 0;
      }
      
      public function get nextObject() : *
      {
         if(afterLast)
         {
            return null;
         }
         var _loc1_:int = beforeFirst ? 0 : int(currentIndex + 1);
         if(_loc1_ >= source.length)
         {
            return null;
         }
         return source[_loc1_];
      }
      
      public function remove() : *
      {
         var _loc1_:Object = source[currentIndex];
         source = source.splice(currentIndex,1);
         return _loc1_;
      }
      
      public function get current() : *
      {
         if(currentIndex > BEFORE_FIRST_INDEX)
         {
            return source[currentIndex];
         }
         return null;
      }
      
      public function seek(param1:CursorBookmark, param2:int = 0) : void
      {
         if(source.length == 0)
         {
            currentIndex = AFTER_LAST_INDEX;
            return;
         }
         var _loc3_:int = currentIndex;
         if(param1 == CursorBookmark.FIRST)
         {
            _loc3_ = 0;
         }
         else if(param1 == CursorBookmark.LAST)
         {
            _loc3_ = source.length - 1;
         }
         _loc3_ += param2;
         if(_loc3_ >= source.length)
         {
            currentIndex = AFTER_LAST_INDEX;
         }
         else if(_loc3_ < 0)
         {
            currentIndex = BEFORE_FIRST_INDEX;
         }
         else
         {
            currentIndex = _loc3_;
         }
      }
      
      public function get previousObject() : *
      {
         if(beforeFirst)
         {
            return null;
         }
         var _loc1_:int = afterLast ? int(source.length - 1) : int(currentIndex - 1);
         if(_loc1_ == BEFORE_FIRST_INDEX)
         {
            return null;
         }
         return source[_loc1_];
      }
      
      public function moveFirst() : void
      {
         currentIndex = BEFORE_FIRST_INDEX;
      }
   }
}


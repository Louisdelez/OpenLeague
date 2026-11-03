package com.riotgames.pvpnet.system.cursor
{
   import flash.ui.Mouse;
   import flash.ui.MouseCursor;
   
   public class CursorManagerImpl implements ICursorManager
   {
      
      private var cursors:Vector.<Cursor> = new Vector.<Cursor>();
      
      private var mouseObject:Object;
      
      public function CursorManagerImpl(param1:Object = null)
      {
         super();
         if(param1 == null)
         {
            param1 = Mouse;
         }
         this.mouseObject = param1;
         this.addCursor(MouseCursor.AUTO,NativeCursors.AUTO_PRIORITY);
      }
      
      public function addCursor(param1:String, param2:Number = 0) : void
      {
         var _loc3_:int = this.findInsertionIndex(param2);
         this.cursors.splice(_loc3_,0,new Cursor(param1,param2));
         this.setCurrentCursorId(this.cursors[this.cursors.length - 1].cursorId);
      }
      
      public function removeCursor(param1:String, param2:Number = 0) : Boolean
      {
         var _loc5_:Cursor = null;
         var _loc3_:Boolean = false;
         var _loc4_:int = this.findInsertionIndex(param2);
         while(--_loc4_ >= 0)
         {
            _loc5_ = this.cursors[_loc4_];
            if(_loc5_.priority != param2)
            {
               return false;
            }
            if(_loc5_.cursorId == param1)
            {
               this.cursors.splice(_loc4_,1);
               _loc3_ = true;
               break;
            }
         }
         if(_loc3_ && this.cursors.length > 0)
         {
            this.setCurrentCursorId(this.cursors[this.cursors.length - 1].cursorId);
         }
         return _loc3_;
      }
      
      public function getCurrentCursorId() : String
      {
         return this.mouseObject.cursor;
      }
      
      private function findInsertionIndex(param1:Number) : int
      {
         var _loc4_:uint = 0;
         var _loc5_:Number = NaN;
         var _loc2_:uint = 0;
         var _loc3_:uint = this.cursors.length;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = uint(_loc2_ + _loc3_ >> 1);
            _loc5_ = this.cursors[_loc4_].priority;
            if(param1 < _loc5_)
            {
               _loc3_ = _loc4_;
            }
            else
            {
               _loc2_ = _loc4_ + 1;
            }
         }
         return _loc2_;
      }
      
      private function setCurrentCursorId(param1:String) : void
      {
         if(this.mouseObject.cursor == param1)
         {
            return;
         }
         this.mouseObject.cursor = param1;
      }
   }
}

class Cursor
{
   
   public var cursorId:String;
   
   public var priority:Number;
   
   public function Cursor(param1:String, param2:Number)
   {
      super();
      this.cursorId = param1;
      this.priority = param2;
   }
}

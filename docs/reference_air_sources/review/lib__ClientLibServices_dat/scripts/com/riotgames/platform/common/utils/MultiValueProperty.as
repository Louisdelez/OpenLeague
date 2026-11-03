package com.riotgames.platform.common.utils
{
   public class MultiValueProperty
   {
      
      private static const TRIM:RegExp = /\s*(\S+)\s*/;
      
      private var valueArray:Array = new Array();
      
      private var _randomize:Boolean = false;
      
      private var remainingValues:int = -1;
      
      private var valuePtr:int = -1;
      
      private var origArray:Array = new Array();
      
      public function MultiValueProperty()
      {
         super();
      }
      
      public function get value() : String
      {
         return this.valuePtr > -1 ? this.valueArray[this.valuePtr] : null;
      }
      
      public function set randomize(param1:Boolean) : void
      {
         this._randomize = param1;
         if(this._randomize)
         {
            this.valueArray = this.randomizeArray(this.origArray);
         }
         else
         {
            this.valueArray = this.origArray;
         }
         if(this.origArray.length > 0)
         {
            this.valuePtr = 0;
            this.remainingValues = this.valueArray.length - 1;
         }
      }
      
      private function incrementPtr() : void
      {
         if(this.valueArray.length == 0)
         {
            return;
         }
         if(this.valuePtr >= this.valueArray.length - 1)
         {
            this.valuePtr = 0;
         }
         else
         {
            ++this.valuePtr;
         }
      }
      
      public function get values() : Array
      {
         return this.valueArray.slice();
      }
      
      private function randomizeArray(param1:Array) : Array
      {
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc2_:Array = new Array();
         var _loc3_:Array = param1.slice();
         while(_loc3_.length > 0)
         {
            _loc4_ = Math.round(Math.random() * (_loc3_.length - 1));
            _loc5_ = _loc3_.splice(_loc4_,1)[0];
            _loc2_.push(_loc5_);
         }
         return _loc2_;
      }
      
      public function set values(param1:Array) : void
      {
         if(param1.length == 0)
         {
            this.valuePtr = -1;
            this.remainingValues = -1;
            this.origArray = new Array();
            this.valueArray = new Array();
         }
         else
         {
            this.origArray = param1.slice();
            if(this._randomize)
            {
               this.valueArray = this.randomizeArray(this.origArray);
            }
            else
            {
               this.valueArray = this.origArray;
            }
            this.valuePtr = 0;
            this.remainingValues = this.valueArray.length - 1;
         }
      }
      
      public function hasMultipleValues() : Boolean
      {
         return this.valueArray.length > 1;
      }
      
      public function resetCounter() : void
      {
         if(this.valueArray.length > 0)
         {
            this.remainingValues = this.valueArray.length - 1;
         }
      }
      
      public function get randomize() : Boolean
      {
         return this._randomize;
      }
      
      private function parseCsv(param1:String) : Array
      {
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc2_:Array = new Array();
         if(param1 == null)
         {
            return _loc2_;
         }
         var _loc3_:Array = param1.split(/,/);
         for(_loc4_ in _loc3_)
         {
            _loc5_ = TRIM.exec(_loc3_[_loc4_]);
            if(_loc5_ != null && _loc5_.length > 1)
            {
               _loc2_.push(_loc5_[1]);
            }
         }
         return _loc2_;
      }
      
      public function parsePropertyString(param1:String) : void
      {
         this.values = this.parseCsv(param1);
      }
      
      public function numberOfValues() : int
      {
         return this.valueArray.length;
      }
      
      public function get alternateValues() : Array
      {
         if(this.valueArray.length > 1)
         {
            return this.valueArray.slice(1);
         }
         return new Array();
      }
      
      public function nextValue() : Boolean
      {
         if(this.remainingValues > 0)
         {
            --this.remainingValues;
            this.incrementPtr();
            return true;
         }
         this.remainingValues = this.valueArray.length - 1;
         this.incrementPtr();
         return false;
      }
   }
}


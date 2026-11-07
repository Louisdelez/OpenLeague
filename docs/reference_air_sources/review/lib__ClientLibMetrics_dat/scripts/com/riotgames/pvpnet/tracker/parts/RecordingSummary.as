package com.riotgames.pvpnet.tracker.parts
{
   public class RecordingSummary
   {
      
      public var name:String;
      
      public var min:Number;
      
      public var max:Number;
      
      public var mean:Number;
      
      public var sum:Number;
      
      public var q1:Number;
      
      public var median:Number;
      
      public var q3:Number;
      
      public var std_dev:Number;
      
      public var entries_length:Number;
      
      public var includeTotalAndEntryCount:Boolean;
      
      public var appendParentName:Boolean;
      
      private var needsCalc:Boolean;
      
      private var hasEntries:Boolean;
      
      public function RecordingSummary(param1:String = "")
      {
         super();
         this.initToDefaults(param1);
      }
      
      public function initToDefaults(param1:String = "") : void
      {
         this.name = param1;
         this.min = NaN;
         this.max = NaN;
         this.mean = NaN;
         this.sum = 0;
         this.q1 = NaN;
         this.median = NaN;
         this.q3 = NaN;
         this.std_dev = NaN;
         this.entries_length = 0;
         this.needsCalc = false;
         this.hasEntries = false;
         this.includeTotalAndEntryCount = true;
         this.appendParentName = true;
      }
      
      public function setValue(param1:Number) : void
      {
         if(isNaN(this.min) || param1 < this.min)
         {
            this.min = param1;
         }
         if(isNaN(this.max) || this.max < param1)
         {
            this.max = param1;
         }
         ++this.entries_length;
         this.sum += param1;
         this.needsCalc = true;
         this.hasEntries = true;
      }
      
      public function calc() : void
      {
         this.mean = this.sum / this.entries_length;
         this.needsCalc = false;
      }
      
      public function toString() : String
      {
         var _loc1_:Array = new Array();
         var _loc2_:String = this.name == "" ? "" : this.name + ".";
         _loc1_.push(_loc2_ + "min=" + this.min);
         _loc1_.push(_loc2_ + "max=" + this.max);
         _loc1_.push(_loc2_ + "mean=" + this.mean);
         _loc1_.push(_loc2_ + "q1=" + this.q1);
         _loc1_.push(_loc2_ + "median=" + this.median);
         _loc1_.push(_loc2_ + "q3=" + this.q3);
         _loc1_.push(_loc2_ + "std_dev=" + this.std_dev);
         if(this.includeTotalAndEntryCount)
         {
            _loc1_.push(_loc2_ + "sum=" + this.sum);
            _loc1_.push(_loc2_ + "entries_length=" + this.entries_length);
         }
         return _loc1_.join("\r");
      }
      
      public function flattenToVars(param1:String = "", param2:Object = null) : Object
      {
         if(param2 == null)
         {
            param2 = new Object();
         }
         if(!this.hasEntries)
         {
            return param2;
         }
         if(this.needsCalc)
         {
            this.calc();
         }
         if(param1 != "")
         {
            param1 += ".";
         }
         else
         {
            param1 = this.name == "" ? "" : this.name + ".";
         }
         param2[param1 + "min"] = this.min;
         param2[param1 + "max"] = this.max;
         if(!isNaN(this.mean))
         {
            param2[param1 + "mean"] = this.mean;
         }
         if(!isNaN(this.q1))
         {
            param2[param1 + "q1"] = this.q1;
         }
         if(!isNaN(this.median))
         {
            param2[param1 + "median"] = this.median;
         }
         if(!isNaN(this.q3))
         {
            param2[param1 + "q3"] = this.q3;
         }
         if(!isNaN(this.std_dev))
         {
            param2[param1 + "std_dev"] = this.std_dev;
         }
         if(this.includeTotalAndEntryCount)
         {
            param2[param1 + "sum"] = this.sum;
         }
         param2[param1 + "entries_length"] = this.entries_length;
         return param2;
      }
   }
}


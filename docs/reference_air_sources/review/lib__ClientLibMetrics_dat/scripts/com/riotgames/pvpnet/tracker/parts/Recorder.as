package com.riotgames.pvpnet.tracker.parts
{
   import com.riotgames.pvpnet.tracker.ITracker;
   
   public class Recorder
   {
      
      public var id:Number;
      
      public var name:String;
      
      public var entries:Array;
      
      public var summary:RecordingSummary;
      
      public var reportEntries:Boolean;
      
      public var reportSummary:Boolean;
      
      public var parent:ITracker;
      
      public var includeTotalAndEntryCount:Boolean;
      
      public var appendParentName:Boolean;
      
      public function Recorder(param1:String)
      {
         super();
         this.init(param1);
      }
      
      public function init(param1:String = "Recorder") : void
      {
         this.id = 0;
         this.reportEntries = false;
         this.reportSummary = true;
         this.name = param1;
         this.includeTotalAndEntryCount = true;
         this.appendParentName = true;
         this.reset();
      }
      
      public function reset() : void
      {
         this.entries = [];
         this.summary = new RecordingSummary(this.name);
      }
      
      public function record(param1:Number) : void
      {
         this.entries.push(param1);
         this.summary.setValue(param1);
      }
      
      public function getName() : String
      {
         return this.name;
      }
      
      public function calculateSummary() : RecordingSummary
      {
         var _loc4_:Number = NaN;
         var _loc1_:int = 0;
         var _loc2_:int = int(this.entries.length);
         var _loc3_:RecordingSummary = new RecordingSummary();
         _loc3_.includeTotalAndEntryCount = this.includeTotalAndEntryCount;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = Number(this.entries[_loc1_]);
            _loc3_.setValue(_loc4_);
            _loc1_++;
         }
         _loc3_.calc();
         BasicStatisticsCalculator.calculateQuartiles(this.entries,_loc3_);
         BasicStatisticsCalculator.getStandardDeviation(this.entries,4,_loc3_);
         var _loc5_:String = _loc3_.toString();
         return _loc3_;
      }
      
      public function flattenToVars(param1:Object = null) : Object
      {
         var _loc2_:Boolean = false;
         if(param1 == null)
         {
            param1 = {};
            _loc2_ = true;
         }
         var _loc3_:String = this.parent != null && this.appendParentName ? this.parent.getFullName(_loc2_) + this.getName() : this.getName();
         if(this.reportEntries)
         {
         }
         if(this.reportSummary)
         {
            if(this.entries.length > 0)
            {
               this.summary.calc();
               BasicStatisticsCalculator.calculateQuartiles(this.entries,this.summary);
               BasicStatisticsCalculator.getStandardDeviation(this.entries,4,this.summary);
            }
            if(this.appendParentName)
            {
               this.summary.flattenToVars(_loc3_,param1);
            }
            else
            {
               this.summary.flattenToVars("",param1);
            }
         }
         return param1;
      }
   }
}


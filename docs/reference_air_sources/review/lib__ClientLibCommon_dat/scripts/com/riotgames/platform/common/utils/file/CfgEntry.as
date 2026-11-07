package com.riotgames.platform.common.utils.file
{
   public class CfgEntry
   {
      
      public var value:String;
      
      public var lineComment:String;
      
      public var key:String;
      
      public function CfgEntry()
      {
         super();
      }
      
      public function render() : String
      {
         var _loc1_:String = "";
         if(Boolean(this.key))
         {
            _loc1_ = this.key + "=";
            if(Boolean(this.value))
            {
               _loc1_ += this.value;
            }
         }
         if(Boolean(this.lineComment))
         {
            if(_loc1_.length > 0)
            {
               _loc1_ += " ";
            }
            _loc1_ += this.lineComment;
         }
         return _loc1_;
      }
   }
}


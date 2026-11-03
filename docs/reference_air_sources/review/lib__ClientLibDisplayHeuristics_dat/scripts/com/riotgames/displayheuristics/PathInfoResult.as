package com.riotgames.displayheuristics
{
   public class PathInfoResult
   {
      
      public var path:String;
      
      public var confidence:Number;
      
      public function PathInfoResult(param1:String, param2:Number)
      {
         super();
         this.path = param1;
         this.confidence = param2;
      }
      
      public function toString() : String
      {
         return "[PathInfoResult confidence=" + this.confidence + " path=" + this.path + "]";
      }
   }
}


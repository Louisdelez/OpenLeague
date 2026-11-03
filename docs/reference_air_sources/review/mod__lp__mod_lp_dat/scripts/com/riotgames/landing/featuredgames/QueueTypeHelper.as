package com.riotgames.landing.featuredgames
{
   import flash.utils.Dictionary;
   
   public class QueueTypeHelper
   {
      
      private var _queueTypeMap:Dictionary = new Dictionary();
      
      public function QueueTypeHelper()
      {
         super();
         this._queueTypeMap[0] = this._queueTypeMap[30] = this._queueTypeMap[1] = this._queueTypeMap[8] = this._queueTypeMap[2] = this._queueTypeMap[14] = this._queueTypeMap[15] = this._queueTypeMap[16] = this._queueTypeMap[17] = "normal";
         this._queueTypeMap[10] = this._queueTypeMap[11] = this._queueTypeMap[4] = this._queueTypeMap[6] = this._queueTypeMap[9] = this._queueTypeMap[20] = this._queueTypeMap[21] = this._queueTypeMap[22] = "ranked";
         this._queueTypeMap[41] = this._queueTypeMap[42] = "ranked_team";
      }
      
      public function getQueueTypeById(param1:int) : String
      {
         return this._queueTypeMap[param1] || "custom";
      }
   }
}


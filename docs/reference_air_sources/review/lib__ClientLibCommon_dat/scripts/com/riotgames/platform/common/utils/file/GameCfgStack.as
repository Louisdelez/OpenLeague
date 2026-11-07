package com.riotgames.platform.common.utils.file
{
   public class GameCfgStack
   {
      
      private var defaultData:GameCfgData;
      
      private var overrideData:GameCfgData;
      
      public function GameCfgStack(param1:GameCfgData, param2:GameCfgData)
      {
         super();
         this.defaultData = param1;
         this.overrideData = param2;
      }
      
      public function readValue(param1:String, param2:String, param3:String) : String
      {
         var _loc4_:String = this.defaultData.readValue(param1,param2,param3);
         return this.overrideData.readValue(param1,param2,_loc4_);
      }
      
      public function getDefaultData() : GameCfgData
      {
         return this.defaultData;
      }
      
      public function setValue(param1:String, param2:String, param3:String) : void
      {
         this.overrideData.setValue(param1,param2,param3);
      }
   }
}


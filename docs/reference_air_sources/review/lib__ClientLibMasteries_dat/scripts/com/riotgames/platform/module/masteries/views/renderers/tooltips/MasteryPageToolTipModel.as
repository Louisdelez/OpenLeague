package com.riotgames.platform.module.masteries.views.renderers.tooltips
{
   import flash.events.EventDispatcher;
   
   public class MasteryPageToolTipModel extends EventDispatcher
   {
      
      public var title:String;
      
      public var offenseValue:String;
      
      public var defenseValue:String;
      
      public var utilityValue:String;
      
      public function MasteryPageToolTipModel(param1:String, param2:String, param3:String, param4:String)
      {
         super();
         this.title = param1;
         this.offenseValue = param2;
         this.defenseValue = param3;
         this.utilityValue = param4;
      }
      
      public function updateModelInfo(param1:String, param2:String, param3:String, param4:String) : void
      {
         this.title = param1;
         this.offenseValue = param2;
         this.defenseValue = param3;
         this.utilityValue = param4;
      }
   }
}


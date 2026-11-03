package com.riotgames.championdetails.tooltip
{
   public class DescriptiveToolTipModel
   {
      
      public var title:String;
      
      public var hotKey:String;
      
      public var cost:String;
      
      public var description:String;
      
      public function DescriptiveToolTipModel(param1:String, param2:String, param3:String, param4:String)
      {
         super();
         this.title = param1;
         this.hotKey = param2;
         this.cost = param3;
         this.description = param4;
      }
   }
}


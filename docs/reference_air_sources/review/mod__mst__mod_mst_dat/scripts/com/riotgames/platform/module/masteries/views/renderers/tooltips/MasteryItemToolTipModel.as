package com.riotgames.platform.module.masteries.views.renderers.tooltips
{
   import flash.events.EventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class MasteryItemToolTipModel extends EventDispatcher
   {
      
      public var rank:String;
      
      public var state:String;
      
      public var requirements:String;
      
      public var groupId:int;
      
      public var description:String;
      
      public var title:String;
      
      public function MasteryItemToolTipModel(param1:String, param2:int, param3:String, param4:String, param5:String, param6:String)
      {
         super();
         this.title = param1;
         this.groupId = param2;
         this.rank = param3;
         this.requirements = param4;
         this.description = param5;
         this.state = param6;
      }
      
      public function updateModelInfo(param1:String, param2:int, param3:String, param4:String, param5:String, param6:String) : void
      {
         this.title = param1;
         this.groupId = param2;
         this.rank = param3;
         this.requirements = param4;
         this.description = param5;
         this.state = param6;
         this.dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE));
      }
   }
}


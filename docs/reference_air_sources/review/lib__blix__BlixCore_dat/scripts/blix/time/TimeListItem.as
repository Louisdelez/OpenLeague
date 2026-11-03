package blix.time
{
   public class TimeListItem
   {
      
      public var previous:TimeListItem;
      
      public var next:TimeListItem;
      
      public var target:ITimeUpdateable;
      
      public var registrationTime:int;
      
      public var remove:Boolean;
      
      public function TimeListItem(param1:ITimeUpdateable)
      {
         super();
         this.target = param1;
      }
   }
}


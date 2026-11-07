package flexlib.scheduling.timelineClasses
{
   public class SimpleTimeDescriptor implements ITimeDescriptor
   {
      
      private var _date:Date;
      
      private var _description:Object;
      
      public function SimpleTimeDescriptor()
      {
         super();
      }
      
      public function get description() : Object
      {
         return _description;
      }
      
      public function set date(value:Date) : void
      {
         _date = value;
      }
      
      public function get date() : Date
      {
         return _date;
      }
      
      public function set description(value:Object) : void
      {
         _description = value;
      }
   }
}


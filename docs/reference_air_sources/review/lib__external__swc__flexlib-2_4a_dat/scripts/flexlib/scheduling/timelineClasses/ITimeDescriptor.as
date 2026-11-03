package flexlib.scheduling.timelineClasses
{
   public interface ITimeDescriptor
   {
      
      function set date(param1:Date) : void;
      
      function set description(param1:Object) : void;
      
      function get description() : Object;
      
      function get date() : Date;
   }
}


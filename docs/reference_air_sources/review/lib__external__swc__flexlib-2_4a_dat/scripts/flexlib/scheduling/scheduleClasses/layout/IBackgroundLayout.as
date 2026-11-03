package flexlib.scheduling.scheduleClasses.layout
{
   import mx.collections.IList;
   
   public interface IBackgroundLayout extends ILayoutClient
   {
      
      function get timeRanges() : IList;
      
      function set timeRanges(param1:IList) : void;
      
      function set minimumTimeRangeWidth(param1:Number) : void;
      
      function set backgroundItems(param1:IList) : void;
      
      function get minimumTimeRangeWidth() : Number;
      
      function get backgroundItems() : IList;
   }
}


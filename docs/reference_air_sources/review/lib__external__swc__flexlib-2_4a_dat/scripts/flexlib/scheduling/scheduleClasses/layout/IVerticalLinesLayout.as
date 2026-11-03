package flexlib.scheduling.scheduleClasses.layout
{
   import mx.collections.IList;
   
   public interface IVerticalLinesLayout extends ILayoutClient
   {
      
      function get timeRanges() : IList;
      
      function set timeRanges(param1:IList) : void;
      
      function set minimumTimeRangeWidth(param1:Number) : void;
      
      function get minimumTimeRangeWidth() : Number;
   }
}


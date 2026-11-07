package flexlib.scheduling.timelineClasses
{
   import flexlib.scheduling.util.DateUtil;
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   
   public class TimeRangeDescriptorUtil
   {
      
      public static var defaultTimeRangeDescriptor:Array = [[DateUtil.MINUTE_IN_MILLISECONDS,"L:NNAA"],[5 * DateUtil.MINUTE_IN_MILLISECONDS,"L:NNAA"],[10 * DateUtil.MINUTE_IN_MILLISECONDS,"L:NNAA"],[15 * DateUtil.MINUTE_IN_MILLISECONDS,"L:NNAA"],[30 * DateUtil.MINUTE_IN_MILLISECONDS,"L:NNAA"],[60 * DateUtil.MINUTE_IN_MILLISECONDS,"L:NNAA"],[2 * DateUtil.HOUR_IN_MILLISECONDS,"L:NNAA"],[6 * DateUtil.HOUR_IN_MILLISECONDS,"L:NNAA"],[12 * DateUtil.HOUR_IN_MILLISECONDS,"L:NNAA"],[24 * DateUtil.HOUR_IN_MILLISECONDS,"DD/MM/YY"],[2 * DateUtil.DAY_IN_MILLISECONDS,"DD/MM/YY"],[4 * DateUtil.DAY_IN_MILLISECONDS,"DD/MM/YY"],[7 * DateUtil.DAY_IN_MILLISECONDS,"DD/MM/YY"],[14 * DateUtil.DAY_IN_MILLISECONDS,"DD/MM/YY"],[30 * DateUtil.DAY_IN_MILLISECONDS,"MMM YY"],[4 * DateUtil.MONTH_IN_MILLISECONDS,"MMM YY"],[6 * DateUtil.MONTH_IN_MILLISECONDS,"MMM YY"],[9 * DateUtil.MONTH_IN_MILLISECONDS,"MMM YY"],[12 * DateUtil.MONTH_IN_MILLISECONDS,"MMM YY"],[2 * DateUtil.YEAR_IN_MILLISECONDS,"YYYY"],[5 * DateUtil.YEAR_IN_MILLISECONDS
      ,"YYYY"],[10 * DateUtil.YEAR_IN_MILLISECONDS,"YYYY"],[25 * DateUtil.YEAR_IN_MILLISECONDS,"YYYY"],[500 * DateUtil.YEAR_IN_MILLISECONDS,"YYYY"]];
      
      public function TimeRangeDescriptorUtil()
      {
         super();
      }
      
      public static function getDefaultTimeRangeDescriptor() : IList
      {
         return TimeRangeDescriptorUtil.convertArrayToTimeRangeDescriptor(defaultTimeRangeDescriptor);
      }
      
      public static function convertArrayToTimeRangeDescriptor(timeDescriptor:Array) : IList
      {
         var dataProvider:IList = null;
         var len:Number = NaN;
         var i:Number = NaN;
         var item:Array = null;
         var entry:ITimeDescriptor = null;
         dataProvider = new ArrayCollection();
         len = timeDescriptor.length;
         for(i = 0; i < len; i++)
         {
            item = timeDescriptor[i];
            entry = new SimpleTimeDescriptor();
            entry.date = new Date(item[0]);
            entry.description = item[1];
            dataProvider.addItem(entry);
         }
         return dataProvider;
      }
   }
}


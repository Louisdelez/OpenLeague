package flexlib.scheduling.samples
{
   import flexlib.scheduling.scheduleClasses.ColoredScheduleEntry;
   import flexlib.scheduling.scheduleClasses.SimpleScheduleEntry;
   import flexlib.scheduling.util.DateUtil;
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   
   public class ScheduleData
   {
      
      public function ScheduleData()
      {
         super();
      }
      
      private function randomInt(max:Number) : Number
      {
         return Math.floor(Math.random() * max);
      }
      
      private function createSimpleEntry(i:Number, startTime:Number, duration:Number) : SimpleScheduleEntry
      {
         var entry:SimpleScheduleEntry = null;
         entry = new SimpleScheduleEntry();
         entry.startDate = DateUtil.setTime(new Date(),startTime);
         entry.endDate = DateUtil.addTime(DateUtil.copyDate(entry.startDate),duration);
         entry.label = "Entry " + i;
         return entry;
      }
      
      public function createRandomColoredScheduleEntries(size:Number) : ArrayCollection
      {
         var result:Array = null;
         var i:Number = NaN;
         var color:uint = 0;
         result = new Array();
         for(i = 0; i < size; i++)
         {
            color = 10066329 + randomInt(7829367);
            result.push(createColoredEntry(i,randomInt((24 - 1) * 60) * 60 * 1000,(10 + randomInt(120)) * 60 * 1000,color));
         }
         return new ArrayCollection(result);
      }
      
      public function createRandomSimpleScheduleEntries(size:Number) : ArrayCollection
      {
         var result:Array = null;
         var i:Number = NaN;
         result = new Array();
         for(i = 0; i < size; i++)
         {
            result.push(createSimpleEntry(i,randomInt((24 - 1) * 60) * 60 * 1000,(10 + randomInt(120)) * 60 * 1000));
         }
         return new ArrayCollection(result);
      }
      
      public function createRowsOfSequentialColoredEntries(rows:Number, size:Number) : ArrayCollection
      {
         var result:Array = null;
         var counter:Number = NaN;
         var i:Number = NaN;
         var row:IList = null;
         var currentTime:Number = NaN;
         var color:uint = 0;
         var j:Number = NaN;
         var startTime:Number = NaN;
         var duration:Number = NaN;
         var entry:SimpleScheduleEntry = null;
         result = new Array();
         counter = 0;
         for(i = 0; i < rows; i++)
         {
            row = new ArrayCollection();
            currentTime = (24 - 1) * 60 / size;
            color = 10066329 + randomInt(7829367);
            for(j = 0; j < size; j++)
            {
               counter++;
               startTime = currentTime * j * 60 * 1000;
               duration = (randomInt(60) + 30) * 60 * 1000;
               entry = createColoredEntry(j,startTime,duration,color);
               entry.label = "Entry " + counter;
               row.addItem(entry);
            }
            result.push(row);
         }
         return new ArrayCollection(result);
      }
      
      private function createColoredEntry(i:Number, startTime:Number, duration:Number, color:uint) : SimpleScheduleEntry
      {
         var entry:ColoredScheduleEntry = null;
         entry = new ColoredScheduleEntry();
         entry.startDate = DateUtil.setTime(new Date(),startTime);
         entry.endDate = DateUtil.addTime(DateUtil.copyDate(entry.startDate),duration);
         entry.label = "Entry " + i;
         entry.backgroundColor = color;
         return entry;
      }
      
      public function createRowsOfRandomColoredEntries(rows:Number, size:Number) : ArrayCollection
      {
         var result:Array = null;
         var i:Number = NaN;
         var row:IList = null;
         var j:Number = NaN;
         var color:uint = 0;
         result = new Array();
         for(i = 0; i < rows; i++)
         {
            row = new ArrayCollection();
            for(j = 0; j < size; j++)
            {
               color = 10066329 + randomInt(7829367);
               row.addItem(createColoredEntry(j,randomInt((24 - 1) * 60) * 60 * 1000,(10 + randomInt(60)) * 60 * 1000,color));
            }
            result.push(row);
         }
         return new ArrayCollection(result);
      }
   }
}


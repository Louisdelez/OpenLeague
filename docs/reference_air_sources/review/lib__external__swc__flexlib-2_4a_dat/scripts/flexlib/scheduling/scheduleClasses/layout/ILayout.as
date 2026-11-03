package flexlib.scheduling.scheduleClasses.layout
{
   import flash.events.IEventDispatcher;
   import mx.collections.IList;
   
   public interface ILayout extends IEventDispatcher
   {
      
      function set xPosition(param1:Number) : void;
      
      function set yPosition(param1:Number) : void;
      
      function get contentHeight() : Number;
      
      function get xPosition() : Number;
      
      function get yPosition() : Number;
      
      function get viewportWidth() : Number;
      
      function set endDate(param1:Date) : void;
      
      function get contentWidth() : Number;
      
      function get items() : IList;
      
      function set viewportHeight(param1:Number) : void;
      
      function set startDate(param1:Date) : void;
      
      function set contentWidth(param1:Number) : void;
      
      function set viewportWidth(param1:Number) : void;
      
      function get endDate() : Date;
      
      function get viewportHeight() : Number;
      
      function get startDate() : Date;
      
      function get totalMilliseconds() : Number;
      
      function set entryLayout(param1:IEntryLayout) : void;
      
      function set contentHeight(param1:Number) : void;
      
      function get entryLayout() : IEntryLayout;
   }
}


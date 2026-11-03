package flexlib.scheduling.scheduleClasses.layout
{
   import flexlib.scheduling.scheduleClasses.IScheduleEntry;
   import mx.collections.IList;
   import mx.events.CollectionEvent;
   
   public interface IEntryLayout extends ILayoutProvider
   {
      
      function updateItem(param1:CollectionEvent) : void;
      
      function findLayoutItem(param1:IScheduleEntry) : EntryLayoutItem;
      
      function moveItem(param1:CollectionEvent) : void;
      
      function set rowHeight(param1:Number) : void;
      
      function createLayout() : void;
      
      function addItem(param1:CollectionEvent) : void;
      
      function refreshItem(param1:CollectionEvent) : void;
      
      function resetItem(param1:CollectionEvent) : void;
      
      function replaceItem(param1:CollectionEvent) : void;
      
      function get rowHeight() : Number;
      
      function removeItem(param1:CollectionEvent) : void;
      
      function get dataProvider() : IList;
      
      function set dataProvider(param1:IList) : void;
   }
}


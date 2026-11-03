package flexlib.scheduling.scheduleClasses.renderers
{
   import flexlib.scheduling.scheduleClasses.IScheduleEntry;
   import mx.core.IDataRenderer;
   import mx.core.IFlexDisplayObject;
   import mx.styles.IStyleClient;
   
   public interface IScheduleEntryRenderer extends IFlexDisplayObject, IDataRenderer, IStyleClient
   {
      
      function get entry() : IScheduleEntry;
      
      function get selected() : Boolean;
      
      function set selected(param1:Boolean) : void;
      
      function set entry(param1:IScheduleEntry) : void;
   }
}


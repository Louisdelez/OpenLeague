package spark.components
{
   import mx.core.IDataRenderer;
   import mx.events.FlexEvent;
   
   [Event(name="dataChange",type="mx.events.FlexEvent")]
   public class DataRenderer extends Group implements IDataRenderer
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var _data:Object;
      
      public function DataRenderer()
      {
         super();
      }
      
      [Bindable("dataChange")]
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set data(value:Object) : void
      {
         this._data = value;
         if(hasEventListener(FlexEvent.DATA_CHANGE))
         {
            dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
         }
      }
   }
}


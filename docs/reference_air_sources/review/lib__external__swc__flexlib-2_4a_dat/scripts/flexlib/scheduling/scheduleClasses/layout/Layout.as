package flexlib.scheduling.scheduleClasses.layout
{
   import flash.events.EventDispatcher;
   import mx.collections.IList;
   import mx.events.PropertyChangeEvent;
   
   public class Layout extends EventDispatcher implements ILayout
   {
      
      private var _contentHeight:Number;
      
      private var _viewportHeight:Number;
      
      private var _contentWidth:Number;
      
      protected var _startDate:Number;
      
      protected var _items:IList;
      
      private var _xPosition:Number = 0;
      
      private var _yPosition:Number = 0;
      
      private var _viewportWidth:Number;
      
      protected var _endDate:Number;
      
      private var _entryLayout:IEntryLayout;
      
      public function Layout()
      {
         super();
      }
      
      public function set contentHeight(value:Number) : void
      {
         _contentHeight = value;
      }
      
      public function set yPosition(value:Number) : void
      {
         _yPosition = value;
      }
      
      public function set contentWidth(value:Number) : void
      {
         _contentWidth = value;
      }
      
      public function set viewportWidth(value:Number) : void
      {
         _viewportWidth = value;
      }
      
      [Bindable(event="propertyChange")]
      public function set xPosition(value:Number) : void
      {
         var oldValue:Object = null;
         oldValue = this.xPosition;
         if(oldValue !== value)
         {
            this._1333721663xPosition = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"xPosition",oldValue,value));
         }
      }
      
      public function get endDate() : Date
      {
         return new Date(_endDate);
      }
      
      public function get contentHeight() : Number
      {
         return _contentHeight;
      }
      
      public function get startDate() : Date
      {
         return new Date(_startDate);
      }
      
      public function get yPosition() : Number
      {
         return _yPosition;
      }
      
      public function get entryLayout() : IEntryLayout
      {
         return _entryLayout;
      }
      
      public function get viewportWidth() : Number
      {
         return _viewportWidth;
      }
      
      [Bindable]
      public function get xPosition() : Number
      {
         return _xPosition;
      }
      
      public function set endDate(value:Date) : void
      {
         _endDate = value.getTime();
      }
      
      private function set _1333721663xPosition(value:Number) : void
      {
         if(isNaN(value))
         {
            return;
         }
         _xPosition = value;
      }
      
      public function set viewportHeight(value:Number) : void
      {
         _viewportHeight = value;
      }
      
      public function set startDate(value:Date) : void
      {
         _startDate = value.getTime();
      }
      
      public function get contentWidth() : Number
      {
         return _contentWidth;
      }
      
      public function get items() : IList
      {
         return _items;
      }
      
      public function get totalMilliseconds() : Number
      {
         return _endDate - _startDate;
      }
      
      public function set entryLayout(value:IEntryLayout) : void
      {
         _entryLayout = value;
      }
      
      public function get viewportHeight() : Number
      {
         return _viewportHeight;
      }
   }
}


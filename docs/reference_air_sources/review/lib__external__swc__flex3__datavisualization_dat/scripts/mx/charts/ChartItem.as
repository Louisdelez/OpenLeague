package mx.charts
{
   import flash.events.EventDispatcher;
   import mx.charts.chartClasses.IChartElement;
   import mx.core.IFlexDisplayObject;
   import mx.core.IProgrammaticSkin;
   import mx.core.IUIComponent;
   
   public class ChartItem extends EventDispatcher
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      public static const FOCUSED:String = "focused";
      
      public static const SELECTED:String = "selected";
      
      public static const FOCUSEDSELECTED:String = "focusedSelected";
      
      public static const ROLLOVER:String = "rollOver";
      
      public static const DISABLED:String = "disabled";
      
      public static const NONE:String = "none";
      
      [Inspectable(environment="none")]
      public var index:int;
      
      [Inspectable(environment="none")]
      public var itemRenderer:IFlexDisplayObject;
      
      private var _currentState:String = "";
      
      [Inspectable(environment="none")]
      public var item:Object;
      
      [Inspectable(environment="none")]
      public var element:IChartElement;
      
      public function ChartItem(element:IChartElement = null, item:Object = null, index:uint = 0)
      {
         super();
         this.element = element;
         this.item = item;
         this.index = index;
         this._currentState = ChartItem.NONE;
      }
      
      public function set currentState(value:String) : void
      {
         if(_currentState != value)
         {
            _currentState = value;
            if(Boolean(itemRenderer) && (itemRenderer is IProgrammaticSkin || itemRenderer is IUIComponent))
            {
               (itemRenderer as Object).invalidateDisplayList();
            }
         }
      }
      
      public function clone() : ChartItem
      {
         var result:ChartItem = new ChartItem(element,item,index);
         result.itemRenderer = itemRenderer;
         return result;
      }
      
      [Inspectable(environment="none")]
      public function get currentState() : String
      {
         return _currentState;
      }
   }
}


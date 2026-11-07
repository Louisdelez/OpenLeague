package mx.charts.chartClasses
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import mx.charts.LinearAxis;
   
   [Event(name="transformChange",type="mx.events.FlexEvent")]
   public class DataTransform extends EventDispatcher
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private var _axes:Object = {};
      
      private var _elements:Array = [];
      
      public function DataTransform()
      {
         super();
      }
      
      public function setAxis(dimension:String, v:IAxis) : void
      {
         if(setAxisNoEvent(dimension,v))
         {
            mappingChangeHandler();
         }
      }
      
      [Inspectable(environment="none")]
      public function get axes() : Object
      {
         return _axes;
      }
      
      public function dataChanged() : void
      {
         var name:String = null;
         for(name in _axes)
         {
            if(Boolean(_axes[name]))
            {
               _axes[name].dataChanged();
            }
         }
      }
      
      public function set elements(value:Array) : void
      {
         _elements = value;
      }
      
      private function setAxisNoEvent(dimension:String, v:IAxis) : Boolean
      {
         var oldV:IAxis = _axes[dimension];
         if(oldV != v)
         {
            if(Boolean(oldV))
            {
               oldV.unregisterDataTransform(this);
               oldV.removeEventListener("mappingChange",mappingChangeHandler);
            }
            _axes[dimension] = v;
            v.registerDataTransform(this,dimension);
            v.addEventListener("mappingChange",mappingChangeHandler,false,0,true);
            return true;
         }
         return false;
      }
      
      public function describeData(dimension:String, requiredFields:uint) : Array
      {
         var dataGlyph:IChartElement = null;
         var results:Array = [];
         var n:int = int(elements.length);
         for(var i:int = 0; i < n; i++)
         {
            dataGlyph = elements[i] as IChartElement;
            if(dataGlyph)
            {
               results = results.concat(dataGlyph.describeData(dimension,requiredFields));
            }
         }
         return results;
      }
      
      [Inspectable(environment="none")]
      public function get elements() : Array
      {
         return _elements;
      }
      
      public function invertTransform(... values) : Array
      {
         return null;
      }
      
      private function mappingChangeHandler(e:Event = null) : void
      {
         var g:IChartElement = null;
         var n:int = int(elements.length);
         for(var i:int = 0; i < n; i++)
         {
            g = elements[i] as IChartElement;
            if(Boolean(g))
            {
               g.mappingChanged();
            }
         }
      }
      
      public function transformCache(cache:Array, xField:String, xConvertedField:String, yField:String, yConvertedField:String) : void
      {
      }
      
      public function getAxis(dimension:String) : IAxis
      {
         var newAxis:LinearAxis = null;
         if(!_axes[dimension])
         {
            newAxis = new LinearAxis();
            newAxis.autoAdjust = false;
            setAxisNoEvent(dimension,newAxis);
         }
         return _axes[dimension];
      }
   }
}


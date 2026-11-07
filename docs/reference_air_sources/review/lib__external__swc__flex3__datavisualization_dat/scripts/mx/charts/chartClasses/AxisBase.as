package mx.charts.chartClasses
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import mx.charts.ChartItem;
   
   public class AxisBase extends EventDispatcher
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private var _title:String = "";
      
      protected var _transforms:Array = [];
      
      private var _displayName:String = "";
      
      public function AxisBase()
      {
         super();
      }
      
      [Inspectable(environment="none")]
      public function get unitSize() : Number
      {
         return 1;
      }
      
      public function dataChanged() : void
      {
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function highlightElements(highlight:Boolean) : void
      {
         var elements:Array = [];
         for(var i:int = 0; i < _transforms.length; i++)
         {
            elements = elements.concat(_transforms[i].transform.elements);
         }
         if(highlight)
         {
            for(i = 0; i < elements.length; i++)
            {
               if(elements[i] is Series)
               {
                  Series(elements[i]).setItemsState(ChartItem.ROLLOVER);
               }
            }
         }
         else
         {
            for(i = 0; i < elements.length; i++)
            {
               if(elements[i] is Series)
               {
                  if(elements[i].getChartSelectedStatus() == false)
                  {
                     elements[i].setItemsState(ChartItem.NONE);
                  }
                  else if(elements[i].selectedItems.length == 0)
                  {
                     elements[i].setItemsState(ChartItem.DISABLED);
                  }
                  else
                  {
                     Series(elements[i]).selectedItems = elements[i].selectedItems;
                  }
               }
            }
         }
      }
      
      [Inspectable(category="Display")]
      public function get displayName() : String
      {
         return _displayName;
      }
      
      public function set title(value:String) : void
      {
         dispatchEvent(new Event("titleChange"));
         _title = value;
      }
      
      protected function describeData(requiredFields:uint) : Array
      {
         var result:Array = [];
         for(var i:int = 0; i < _transforms.length; i++)
         {
            result = result.concat(_transforms[i].transform.describeData(_transforms[i].dimension,requiredFields));
         }
         return result;
      }
      
      [Inspectable(category="General")]
      public function get title() : String
      {
         return _title;
      }
      
      [Inspectable(environment="none")]
      public function set chartDataProvider(value:Object) : void
      {
      }
      
      public function set displayName(value:String) : void
      {
         _displayName = value;
      }
      
      public function unregisterDataTransform(transform:DataTransform) : void
      {
         for(var i:int = 0; i < _transforms.length; i++)
         {
            if(_transforms[i].transform == transform)
            {
               _transforms.splice(i,1);
               break;
            }
         }
         dataChanged();
      }
      
      public function registerDataTransform(transform:DataTransform, dimensionName:String) : void
      {
         _transforms.push({
            "transform":transform,
            "dimension":dimensionName
         });
         dataChanged();
      }
   }
}


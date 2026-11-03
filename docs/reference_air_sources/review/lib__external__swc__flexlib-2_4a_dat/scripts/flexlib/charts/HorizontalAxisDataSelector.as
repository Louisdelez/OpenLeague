package flexlib.charts
{
   import flash.display.Graphics;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import mx.charts.chartClasses.ChartElement;
   import mx.core.EventPriority;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   
   [Style(name="selectorColor",type="uint",format="Color",inherit="no")]
   [Event(name="change",type="flash.events.Event")]
   public class HorizontalAxisDataSelector extends ChartElement
   {
      
      private static var classConstructed:Boolean = classConstruct();
      
      private var lastX:Number;
      
      private var mouseIsDown:Boolean = false;
      
      private var selectedDataIndex:int = -1;
      
      public function HorizontalAxisDataSelector()
      {
         super();
         addEventListener(MouseEvent.MOUSE_DOWN,handleMouseDown,false,EventPriority.DEFAULT,false);
         addEventListener(MouseEvent.MOUSE_MOVE,handleMouseMove,false,EventPriority.DEFAULT,true);
         addEventListener(Event.ADDED_TO_STAGE,onAddedToStage,false,EventPriority.DEFAULT,true);
      }
      
      private static function classConstruct() : Boolean
      {
         var newStyleDeclaration:CSSStyleDeclaration = null;
         if(!StyleManager.getStyleDeclaration("HorizontalAxisDataSelector"))
         {
            newStyleDeclaration = new CSSStyleDeclaration();
            newStyleDeclaration.setStyle("selectorColor",16711680);
            StyleManager.setStyleDeclaration("HorizontalAxisDataSelector",newStyleDeclaration,true);
         }
         return true;
      }
      
      private function handleMouseMove(event:MouseEvent) : void
      {
         if(mouseIsDown)
         {
            setSelectedDataIndex(event);
         }
      }
      
      public function get dataValues() : Array
      {
         var values:Array = null;
         var xField:String = null;
         var i:int = 0;
         var currentSeries:* = undefined;
         values = new Array();
         xField = chart.series[0].xField;
         values.push(chart.dataProvider.getItemAt(selectedDataIndex)[xField]);
         for(i = 0; i < chart.series.length; i++)
         {
            currentSeries = chart.series[i];
            values.push(chart.dataProvider.getItemAt(selectedDataIndex)[currentSeries.yField]);
         }
         return values;
      }
      
      private function handleMouseDown(event:MouseEvent) : void
      {
         mouseIsDown = true;
         setSelectedDataIndex(event);
      }
      
      private function setSelectedDataIndex(event:MouseEvent) : void
      {
         var oldSelectedDataIndex:int = 0;
         var point:Point = null;
         var dataValues:Array = null;
         var targetXFieldValue:Number = NaN;
         var series:* = undefined;
         var xField:String = null;
         var i:int = 0;
         var item:* = undefined;
         var nextItem:* = undefined;
         var diff1:Number = NaN;
         var diff2:Number = NaN;
         var changeEvent:Event = null;
         oldSelectedDataIndex = selectedDataIndex;
         point = new Point(chart.mouseX,chart.mouseY);
         dataValues = chart.localToData(point);
         targetXFieldValue = Number(dataValues[0]);
         series = chart.series[0];
         xField = series.xField;
         for(i = 0; i < chart.dataProvider.length; i++)
         {
            item = chart.dataProvider.getItemAt(i);
            try
            {
               nextItem = chart.dataProvider.getItemAt(i + 1);
               if(item[xField] <= targetXFieldValue && nextItem[xField] > targetXFieldValue)
               {
                  diff1 = Math.abs(targetXFieldValue - item[xField]);
                  diff2 = Math.abs(targetXFieldValue - nextItem[xField]);
                  if(diff1 < diff2)
                  {
                     selectedDataIndex = i;
                  }
                  else
                  {
                     selectedDataIndex = i + 1;
                  }
                  break;
               }
            }
            catch(re:RangeError)
            {
               selectedDataIndex = chart.dataProvider.length - 1;
            }
         }
         if(chart.dataProvider.getItemAt(0)[xField] > targetXFieldValue)
         {
            selectedDataIndex = 0;
         }
         if(selectedDataIndex != oldSelectedDataIndex)
         {
            invalidateDisplayList();
            changeEvent = new Event(Event.CHANGE,true,false);
            dispatchEvent(changeEvent);
         }
      }
      
      private function handleMouseUp(event:MouseEvent) : void
      {
         mouseIsDown = false;
      }
      
      private function onAddedToStage(event:Event) : void
      {
         stage.addEventListener(MouseEvent.MOUSE_UP,handleMouseUp,false,EventPriority.DEFAULT,true);
         removeEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var g:Graphics = null;
         var values:Array = null;
         var location:Point = null;
         var diff:Number = NaN;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         g = graphics;
         g.clear();
         g.moveTo(0,0);
         g.lineStyle(0,0,0);
         g.beginFill(0,0);
         g.drawRect(0,0,unscaledWidth,unscaledHeight);
         g.endFill();
         if(selectedDataIndex >= 0)
         {
            values = dataValues;
            location = chart.dataToLocal(values[0],values[1]);
            diff = chart.mouseX - this.mouseX;
            location.x -= diff;
            g.lineStyle(1.5,getStyle("selectorColor"),0.8);
            g.moveTo(location.x,0);
            g.lineTo(location.x,unscaledHeight);
         }
      }
   }
}


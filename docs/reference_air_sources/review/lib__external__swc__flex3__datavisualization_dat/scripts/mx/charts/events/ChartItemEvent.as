package mx.charts.events
{
   import flash.display.InteractiveObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import mx.charts.HitData;
   import mx.charts.chartClasses.ChartBase;
   
   public class ChartItemEvent extends MouseEvent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      public static const ITEM_CLICK:String = "itemClick";
      
      public static const ITEM_DOUBLE_CLICK:String = "itemDoubleClick";
      
      public static const ITEM_MOUSE_DOWN:String = "itemMouseDown";
      
      public static const ITEM_MOUSE_MOVE:String = "itemMouseMove";
      
      public static const ITEM_ROLL_OUT:String = "itemRollOut";
      
      public static const ITEM_ROLL_OVER:String = "itemRollOver";
      
      public static const ITEM_MOUSE_UP:String = "itemMouseUp";
      
      public static const CHANGE:String = "change";
      
      [Inspectable(environment="none")]
      public var hitSet:Array;
      
      public function ChartItemEvent(type:String, hitSet:Array = null, triggerEvent:MouseEvent = null, target:ChartBase = null)
      {
         var relPt:Point = null;
         if(Boolean(triggerEvent) && Boolean(triggerEvent.target))
         {
            relPt = target.globalToLocal(triggerEvent.target.localToGlobal(new Point(triggerEvent.localX,triggerEvent.localY)));
         }
         else if(Boolean(target))
         {
            relPt = new Point(target.mouseX,target.mouseY);
         }
         else
         {
            relPt = new Point(0,0);
         }
         var bubbles:Boolean = true;
         var cancelable:Boolean = false;
         var relatedObject:InteractiveObject = null;
         var ctrlKey:Boolean = false;
         var shiftKey:Boolean = false;
         var altKey:Boolean = false;
         var buttonDown:Boolean = false;
         var delta:int = 0;
         if(Boolean(triggerEvent))
         {
            bubbles = triggerEvent.bubbles;
            cancelable = triggerEvent.cancelable;
            relatedObject = triggerEvent.relatedObject;
            ctrlKey = triggerEvent.ctrlKey;
            altKey = triggerEvent.altKey;
            shiftKey = triggerEvent.shiftKey;
            buttonDown = triggerEvent.buttonDown;
            delta = triggerEvent.delta;
         }
         super(type,bubbles,cancelable,relPt.x,relPt.y,relatedObject,ctrlKey,altKey,shiftKey,buttonDown,delta);
         this.hitSet = hitSet;
      }
      
      override public function clone() : Event
      {
         return new ChartItemEvent(type,hitSet,this,ChartBase(this.target));
      }
      
      [Inspectable(environment="none")]
      public function get hitData() : HitData
      {
         return Boolean(hitSet) && hitSet.length > 0 ? hitSet[0] : null;
      }
   }
}


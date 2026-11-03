package mx.effects
{
   import mx.core.mx_internal;
   import mx.effects.effectClasses.ZoomInstance;
   
   use namespace mx_internal;
   
   public class Zoom extends TweenEffect
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private static var AFFECTED_PROPERTIES:Array = ["scaleX","scaleY","x","y","width","height"];
      
      [Inspectable(category="General",defaultValue="0.01")]
      public var zoomHeightFrom:Number;
      
      [Inspectable(category="General",defaultValue="1")]
      public var zoomWidthTo:Number;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var originX:Number;
      
      [Inspectable(category="General",defaultValue="1")]
      public var zoomHeightTo:Number;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var originY:Number;
      
      [Inspectable(category="Other",defaultValue="false")]
      public var captureRollEvents:Boolean;
      
      [Inspectable(category="General",defaultValue="0.01")]
      public var zoomWidthFrom:Number;
      
      public function Zoom(target:Object = null)
      {
         super(target);
         instanceClass = ZoomInstance;
         mx_internal::applyActualDimensions = false;
         relevantProperties = ["scaleX","scaleY","width","height","visible"];
      }
      
      override protected function initInstance(instance:IEffectInstance) : void
      {
         var zoomInstance:ZoomInstance = null;
         super.initInstance(instance);
         zoomInstance = ZoomInstance(instance);
         zoomInstance.zoomWidthFrom = zoomWidthFrom;
         zoomInstance.zoomWidthTo = zoomWidthTo;
         zoomInstance.zoomHeightFrom = zoomHeightFrom;
         zoomInstance.zoomHeightTo = zoomHeightTo;
         zoomInstance.originX = originX;
         zoomInstance.originY = originY;
         zoomInstance.captureRollEvents = captureRollEvents;
      }
      
      override public function getAffectedProperties() : Array
      {
         return AFFECTED_PROPERTIES;
      }
   }
}


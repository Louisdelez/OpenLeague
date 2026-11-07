package mx.effects
{
   import mx.core.mx_internal;
   import mx.effects.effectClasses.ResizeInstance;
   
   use namespace mx_internal;
   
   public class Resize extends TweenEffect
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private static var AFFECTED_PROPERTIES:Array = ["width","height","explicitWidth","explicitHeight","percentWidth","percentHeight"];
      
      public var hideChildrenTargets:Array;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var widthTo:Number;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var heightTo:Number;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var widthFrom:Number;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var heightFrom:Number;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var widthBy:Number;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var heightBy:Number;
      
      public function Resize(target:Object = null)
      {
         super(target);
         instanceClass = ResizeInstance;
      }
      
      override protected function initInstance(instance:IEffectInstance) : void
      {
         super.initInstance(instance);
         var resizeInstance:ResizeInstance = ResizeInstance(instance);
         if(!isNaN(widthFrom))
         {
            resizeInstance.widthFrom = widthFrom;
         }
         if(!isNaN(widthTo))
         {
            resizeInstance.widthTo = widthTo;
         }
         if(!isNaN(widthBy))
         {
            resizeInstance.widthBy = widthBy;
         }
         if(!isNaN(heightFrom))
         {
            resizeInstance.heightFrom = heightFrom;
         }
         if(!isNaN(heightTo))
         {
            resizeInstance.heightTo = heightTo;
         }
         if(!isNaN(heightBy))
         {
            resizeInstance.heightBy = heightBy;
         }
         resizeInstance.hideChildrenTargets = hideChildrenTargets;
      }
      
      override public function getAffectedProperties() : Array
      {
         return AFFECTED_PROPERTIES;
      }
   }
}


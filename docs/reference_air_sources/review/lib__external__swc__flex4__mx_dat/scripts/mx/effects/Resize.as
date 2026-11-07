package mx.effects
{
   import mx.effects.effectClasses.ResizeInstance;
   
   [Alternative(replacement="spark.effects.Resize",since="4.0")]
   public class Resize extends TweenEffect
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var AFFECTED_PROPERTIES:Array = ["width","height","explicitWidth","explicitHeight","percentWidth","percentHeight"];
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var heightBy:Number;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var heightFrom:Number;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var heightTo:Number;
      
      public var hideChildrenTargets:Array;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var widthBy:Number;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var widthFrom:Number;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var widthTo:Number;
      
      public function Resize(target:Object = null)
      {
         super(target);
         instanceClass = ResizeInstance;
      }
      
      override public function getAffectedProperties() : Array
      {
         return AFFECTED_PROPERTIES;
      }
      
      override protected function initInstance(instance:IEffectInstance) : void
      {
         super.initInstance(instance);
         var resizeInstance:ResizeInstance = ResizeInstance(instance);
         if(!isNaN(this.widthFrom))
         {
            resizeInstance.widthFrom = this.widthFrom;
         }
         if(!isNaN(this.widthTo))
         {
            resizeInstance.widthTo = this.widthTo;
         }
         if(!isNaN(this.widthBy))
         {
            resizeInstance.widthBy = this.widthBy;
         }
         if(!isNaN(this.heightFrom))
         {
            resizeInstance.heightFrom = this.heightFrom;
         }
         if(!isNaN(this.heightTo))
         {
            resizeInstance.heightTo = this.heightTo;
         }
         if(!isNaN(this.heightBy))
         {
            resizeInstance.heightBy = this.heightBy;
         }
         resizeInstance.hideChildrenTargets = this.hideChildrenTargets;
      }
   }
}


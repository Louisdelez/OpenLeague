package spark.effects
{
   import mx.effects.IEffectInstance;
   import spark.effects.supportClasses.ResizeInstance;
   
   public class Resize extends Animate
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var AFFECTED_PROPERTIES:Array = ["width","height","explicitWidth","explicitHeight","percentWidth","percentHeight","left","right","top","bottom"];
      
      private static var RELEVANT_STYLES:Array = ["left","right","top","bottom","percentWidth","percentHeight"];
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var heightBy:Number;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var heightFrom:Number;
      
      [Inspectable(category="General",defaultValue="NaN")]
      public var heightTo:Number;
      
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
      
      override public function get relevantStyles() : Array
      {
         return RELEVANT_STYLES;
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
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function captureValues(propChanges:Array, setStartValues:Boolean, targetsToCapture:Array = null) : Array
      {
         var n:int = 0;
         var i:int = 0;
         var propertyChanges:Array = super.captureValues(propChanges,setStartValues,targetsToCapture);
         if(setStartValues)
         {
            n = int(propertyChanges.length);
            for(i = 0; i < n; i++)
            {
               if(targetsToCapture == null || targetsToCapture.length == 0 || targetsToCapture.indexOf(propertyChanges[i].target) >= 0)
               {
                  propertyChanges[i].stripUnchangedValues = false;
               }
            }
         }
         return propertyChanges;
      }
   }
}


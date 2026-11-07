package spark.effects.supportClasses
{
   import spark.effects.animation.Keyframe;
   import spark.effects.animation.MotionPath;
   
   public class FadeInstance extends AnimateInstance
   {
      
      private var origAlpha:Number = NaN;
      
      private var makeInvisible:Boolean;
      
      private var restoreAlpha:Boolean;
      
      public var alphaFrom:Number;
      
      public var alphaTo:Number;
      
      public function FadeInstance(target:Object)
      {
         super(target);
         autoRemoveTarget = true;
      }
      
      override public function play() : void
      {
         var visibleChange:Boolean = false;
         var parentChange:Boolean = false;
         var fadeIn:Boolean = false;
         var fromValue:Number = this.alphaFrom;
         var toValue:Number = this.alphaTo;
         if(Boolean(propertyChanges))
         {
            if(isNaN(fromValue))
            {
               fromValue = propertyChanges.start["alpha"] !== undefined ? Number(propertyChanges.start["alpha"]) : Number(target.alpha);
            }
            if(isNaN(toValue))
            {
               toValue = propertyChanges.end["alpha"] !== undefined ? Number(propertyChanges.end["alpha"]) : Number(target.alpha);
            }
            visibleChange = propertyChanges.end["visible"] !== undefined && propertyChanges.end["visible"] != propertyChanges.start["visible"];
            parentChange = propertyChanges.end["parent"] !== undefined && propertyChanges.end["parent"] != propertyChanges.start["parent"];
            if(visibleChange || parentChange)
            {
               fadeIn = visibleChange && Boolean(propertyChanges.end["visible"]) || parentChange && Boolean(propertyChanges.end["parent"]);
               if(playReversed)
               {
                  fadeIn = !fadeIn;
               }
               if(fadeIn)
               {
                  if(isNaN(this.alphaFrom))
                  {
                     this.alphaFrom = !playReversed ? 0 : toValue;
                  }
                  if(this.alphaFrom == 0)
                  {
                     target.alpha = 0;
                  }
                  this.alphaTo = !playReversed ? toValue : 0;
                  if("visible" in target)
                  {
                     target.visible = true;
                  }
               }
               else if(isNaN(this.alphaTo))
               {
                  this.restoreAlpha = true;
                  this.origAlpha = propertyChanges.end["alpha"] !== undefined ? Number(propertyChanges.end["alpha"]) : Number(target.alpha);
                  if(visibleChange)
                  {
                     this.makeInvisible = true;
                  }
                  if(!playReversed)
                  {
                     this.alphaTo = 0;
                  }
                  else
                  {
                     if(isNaN(this.alphaFrom))
                     {
                        target.alpha = 0;
                        this.alphaFrom = 0;
                     }
                     this.alphaTo = 1;
                  }
               }
            }
         }
         if("visible" in target && !target.visible)
         {
            if(isNaN(fromValue))
            {
               fromValue = Number(target.alpha);
            }
            if(isNaN(toValue))
            {
               toValue = Number(target.alpha);
            }
            if(fromValue == 0 && toValue != 0)
            {
               target.alpha = 0;
               target.visible = true;
            }
         }
         motionPaths = new <MotionPath>[new MotionPath("alpha")];
         motionPaths[0].keyframes = new <Keyframe>[new Keyframe(0,this.alphaFrom),new Keyframe(duration,this.alphaTo)];
         super.play();
      }
      
      override public function finishEffect() : void
      {
         super.finishEffect();
         if(this.restoreAlpha)
         {
            target.alpha = this.origAlpha;
         }
         if(this.makeInvisible)
         {
            target.visible = false;
         }
      }
   }
}


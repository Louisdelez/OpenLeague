package spark.components.supportClasses
{
   import spark.effects.animation.Animation;
   import spark.effects.animation.IAnimationTarget;
   
   internal class AnimationTarget implements IAnimationTarget
   {
      
      public var updateFunction:Function;
      
      public var startFunction:Function;
      
      public var stopFunction:Function;
      
      public var endFunction:Function;
      
      public var repeatFunction:Function;
      
      public function AnimationTarget(updateFunction:Function = null)
      {
         super();
         this.updateFunction = updateFunction;
      }
      
      public function animationStart(animation:Animation) : void
      {
         if(this.startFunction != null)
         {
            this.startFunction(animation);
         }
      }
      
      public function animationEnd(animation:Animation) : void
      {
         if(this.endFunction != null)
         {
            this.endFunction(animation);
         }
      }
      
      public function animationStop(animation:Animation) : void
      {
         if(this.stopFunction != null)
         {
            this.stopFunction(animation);
         }
      }
      
      public function animationRepeat(animation:Animation) : void
      {
         if(this.repeatFunction != null)
         {
            this.repeatFunction(animation);
         }
      }
      
      public function animationUpdate(animation:Animation) : void
      {
         if(this.updateFunction != null)
         {
            this.updateFunction(animation);
         }
      }
   }
}


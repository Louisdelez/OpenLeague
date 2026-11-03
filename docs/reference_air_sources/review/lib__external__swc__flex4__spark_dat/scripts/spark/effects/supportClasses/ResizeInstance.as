package spark.effects.supportClasses
{
   import spark.effects.animation.Keyframe;
   import spark.effects.animation.MotionPath;
   
   public class ResizeInstance extends AnimateInstance
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var heightSet:Boolean;
      
      private var widthSet:Boolean;
      
      private var explicitWidthSet:Boolean;
      
      private var explicitHeightSet:Boolean;
      
      private var _heightBy:Number;
      
      public var heightFrom:Number;
      
      private var _heightTo:Number;
      
      private var _widthBy:Number;
      
      public var widthFrom:Number;
      
      private var _widthTo:Number;
      
      public function ResizeInstance(target:Object)
      {
         super(target);
      }
      
      public function get heightBy() : Number
      {
         return this._heightBy;
      }
      
      public function set heightBy(value:Number) : void
      {
         this._heightBy = value;
         this.heightSet = !isNaN(value);
      }
      
      public function get heightTo() : Number
      {
         return this._heightTo;
      }
      
      public function set heightTo(value:Number) : void
      {
         this._heightTo = value;
         this.heightSet = !isNaN(value);
      }
      
      public function get widthBy() : Number
      {
         return this._widthBy;
      }
      
      public function set widthBy(value:Number) : void
      {
         this._widthBy = value;
         this.widthSet = !isNaN(value);
      }
      
      public function get widthTo() : Number
      {
         return this._widthTo;
      }
      
      public function set widthTo(value:Number) : void
      {
         this._widthTo = value;
         this.widthSet = !isNaN(value);
      }
      
      override public function play() : void
      {
         var wStart:* = undefined;
         var wEnd:* = undefined;
         var hStart:* = undefined;
         var hEnd:* = undefined;
         this.calculateDimensionChanges();
         motionPaths = new <MotionPath>[new MotionPath("width"),new MotionPath("height")];
         motionPaths[0].keyframes = new <Keyframe>[new Keyframe(0,this.widthFrom),new Keyframe(duration,this.widthTo,this.widthBy)];
         motionPaths[1].keyframes = new <Keyframe>[new Keyframe(0,this.heightFrom),new Keyframe(duration,this.heightTo,this.heightBy)];
         if(Boolean(propertyChanges) && !disableLayout)
         {
            wStart = propertyChanges.start["width"];
            wEnd = propertyChanges.end["width"];
            hStart = propertyChanges.start["height"];
            hEnd = propertyChanges.end["height"];
            if(wStart !== undefined && wEnd != undefined && wStart != wEnd)
            {
               setupConstraintAnimation("left");
               setupConstraintAnimation("right");
            }
            if(hStart !== undefined && hEnd != undefined && hStart != hEnd)
            {
               setupConstraintAnimation("top");
               setupConstraintAnimation("bottom");
            }
         }
         super.play();
      }
      
      private function calculateDimensionChanges() : void
      {
         var explicitWidth:* = Boolean(propertyChanges) ? propertyChanges.end["explicitWidth"] : undefined;
         var explicitHeight:* = Boolean(propertyChanges) ? propertyChanges.end["explicitHeight"] : undefined;
         var percentWidth:* = Boolean(propertyChanges) ? propertyChanges.end["percentWidth"] : undefined;
         var percentHeight:* = Boolean(propertyChanges) ? propertyChanges.end["percentHeight"] : undefined;
         if(isNaN(this.widthFrom))
         {
            if(!isNaN(this.widthTo) && !isNaN(this.widthBy))
            {
               this.widthFrom = this.widthTo - this.widthBy;
            }
         }
         if(isNaN(this.widthTo))
         {
            if(Boolean(isNaN(this.widthBy)) && Boolean(propertyChanges) && (propertyChanges.end["width"] !== undefined && propertyChanges.end["width"] != propertyChanges.start["width"] || explicitWidth !== undefined && !isNaN(explicitWidth)))
            {
               if(explicitWidth !== undefined && !isNaN(explicitWidth))
               {
                  this.explicitWidthSet = true;
                  this._widthTo = explicitWidth;
               }
               else
               {
                  this._widthTo = propertyChanges.end["width"];
               }
            }
            else if(!isNaN(this.widthBy) && !isNaN(this.widthFrom))
            {
               this._widthTo = this.widthFrom + this.widthBy;
            }
         }
         if(isNaN(this.heightFrom))
         {
            if(!isNaN(this.heightTo) && !isNaN(this.heightBy))
            {
               this.heightFrom = this.heightTo - this.heightBy;
            }
         }
         if(isNaN(this.heightTo))
         {
            if(Boolean(isNaN(this.heightBy)) && Boolean(propertyChanges) && (propertyChanges.end["height"] !== undefined && propertyChanges.end["height"] != propertyChanges.start["height"] || explicitHeight !== undefined && !isNaN(explicitHeight)))
            {
               if(explicitHeight !== undefined && !isNaN(explicitHeight))
               {
                  this.explicitHeightSet = true;
                  this._heightTo = explicitHeight;
               }
               else
               {
                  this._heightTo = propertyChanges.end["height"];
               }
            }
            else if(!isNaN(this.heightBy) && !isNaN(this.heightFrom))
            {
               this._heightTo = this.heightFrom + this.heightBy;
            }
         }
      }
   }
}


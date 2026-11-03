package mx.controls.sliderClasses
{
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import mx.controls.Button;
   import mx.controls.ButtonPhase;
   import mx.core.FlexVersion;
   
   public class SliderThumb extends Button
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var thumbIndex:int;
      
      private var xOffset:Number;
      
      public function SliderThumb()
      {
         super();
         stickyHighlighting = true;
      }
      
      override public function set x(value:Number) : void
      {
         var result:Number = this.moveXPos(value);
         this.updateValue();
         super.x = result;
      }
      
      public function get xPosition() : Number
      {
         return $x + width / 2;
      }
      
      public function set xPosition(value:Number) : void
      {
         $x = value - width / 2;
         Slider(owner).drawTrackHighlight();
      }
      
      override protected function measure() : void
      {
         super.measure();
         if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_4_0)
         {
            measuredWidth = 12;
            measuredHeight = 12;
         }
      }
      
      override public function drawFocus(isFocused:Boolean) : void
      {
         phase = isFocused ? ButtonPhase.DOWN : ButtonPhase.UP;
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function buttonReleased() : void
      {
         super.buttonReleased();
         if(enabled)
         {
            systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler,true);
            systemManager.deployMouseShields(false);
            Slider(owner).onThumbRelease(this);
         }
      }
      
      private function moveXPos(value:Number, overrideSnap:Boolean = false, noUpdate:Boolean = false) : Number
      {
         var result:Number = this.calculateXPos(value,overrideSnap);
         this.xPosition = result;
         if(!noUpdate)
         {
            this.updateValue();
         }
         return result;
      }
      
      private function calculateXPos(value:Number, overrideSnap:Boolean = false) : Number
      {
         var bounds:Object = Slider(owner).getXBounds(this.thumbIndex);
         var result:Number = Math.min(Math.max(value,bounds.min),bounds.max);
         if(!overrideSnap)
         {
            result = Slider(owner).getSnapValue(result,this);
         }
         return result;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function onTweenUpdate(value:Number) : void
      {
         this.moveXPos(value,true,true);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function onTweenEnd(value:Number) : void
      {
         this.moveXPos(value);
      }
      
      private function updateValue() : void
      {
         Slider(owner).updateThumbValue(this.thumbIndex);
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         var newVal:Number = NaN;
         var multiThumbs:Boolean = Slider(owner).thumbCount > 1;
         var currentVal:Number = this.xPosition;
         var moveInterval:Number = Slider(owner).snapInterval > 0 ? Slider(owner).getSnapIntervalWidth() : 1;
         var isHorizontal:Boolean = Slider(owner).direction == SliderDirection.HORIZONTAL;
         var keyCode:uint = uint(mapKeycodeForLayoutDirection(event));
         if(keyCode == Keyboard.DOWN && !isHorizontal || keyCode == Keyboard.LEFT && isHorizontal)
         {
            newVal = currentVal - moveInterval;
         }
         else if(keyCode == Keyboard.UP && !isHorizontal || keyCode == Keyboard.RIGHT && isHorizontal)
         {
            newVal = currentVal + moveInterval;
         }
         else if(keyCode == Keyboard.PAGE_DOWN && !isHorizontal || keyCode == Keyboard.HOME && isHorizontal)
         {
            newVal = Slider(owner).getXFromValue(Slider(owner).minimum);
         }
         else if(keyCode == Keyboard.PAGE_UP && !isHorizontal || keyCode == Keyboard.END && isHorizontal)
         {
            newVal = Slider(owner).getXFromValue(Slider(owner).maximum);
         }
         if(!isNaN(newVal))
         {
            event.stopPropagation();
            Slider(owner).keyInteraction = true;
            this.moveXPos(newVal);
         }
      }
      
      override protected function mouseDownHandler(event:MouseEvent) : void
      {
         super.mouseDownHandler(event);
         if(enabled)
         {
            this.xOffset = event.localX;
            systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler,true);
            systemManager.deployMouseShields(true);
            Slider(owner).onThumbPress(this);
         }
      }
      
      private function mouseMoveHandler(event:MouseEvent) : void
      {
         var pt:Point = null;
         if(enabled)
         {
            pt = new Point(event.stageX,event.stageY);
            pt = Slider(owner).innerSlider.globalToLocal(pt);
            this.moveXPos(pt.x - this.xOffset + width / 2,false,true);
            Slider(owner).onThumbMove(this);
         }
      }
   }
}


package mx.controls.tabBarClasses
{
   import flash.display.DisplayObject;
   import flash.text.TextLineMetrics;
   import mx.controls.Button;
   import mx.core.IFlexDisplayObject;
   import mx.core.IProgrammaticSkin;
   import mx.core.IStateClient;
   import mx.styles.ISimpleStyleClient;
   
   [ExcludeClass]
   public class Tab extends Button
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var focusSkin:IFlexDisplayObject;
      
      public function Tab()
      {
         super();
         focusEnabled = false;
      }
      
      override public function measureText(text:String) : TextLineMetrics
      {
         return textField.styleName == this ? super.measureText(text) : textField.getUITextFormat().measureText(text);
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(Boolean(currentIcon))
         {
            currentIcon.scaleX = 1;
            currentIcon.scaleY = 1;
         }
         this.viewIcon();
      }
      
      override public function drawFocus(isFocused:Boolean) : void
      {
         var checkDefaultUsesStates:Boolean = false;
         var focusClass:Class = null;
         if(isFocused && !selected && !isEffectStarted)
         {
            if(!this.focusSkin)
            {
               checkDefaultUsesStates = false;
               focusClass = getStyle(overSkinName);
               if(!focusClass)
               {
                  focusClass = getStyle(skinName);
                  checkDefaultUsesStates = true;
               }
               if(Boolean(focusClass))
               {
                  this.focusSkin = new focusClass();
                  DisplayObject(this.focusSkin).name = overSkinName;
                  if(this.focusSkin is ISimpleStyleClient)
                  {
                     ISimpleStyleClient(this.focusSkin).styleName = this;
                  }
                  addChild(DisplayObject(this.focusSkin));
                  if(checkDefaultUsesStates && !(this.focusSkin is IProgrammaticSkin) && this.focusSkin is IStateClient)
                  {
                     IStateClient(this.focusSkin).currentState = "over";
                  }
               }
            }
            invalidateDisplayList();
            validateNow();
         }
         else if(Boolean(this.focusSkin))
         {
            removeChild(DisplayObject(this.focusSkin));
            this.focusSkin = null;
         }
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function layoutContents(unscaledWidth:Number, unscaledHeight:Number, offset:Boolean) : void
      {
         super.layoutContents(unscaledWidth,unscaledHeight,offset);
         if(selected)
         {
            ++textField.y;
            if(Boolean(currentIcon))
            {
               ++currentIcon.y;
            }
         }
         if(Boolean(currentSkin))
         {
            setChildIndex(DisplayObject(currentSkin),numChildren - 1);
         }
         if(Boolean(this.focusSkin) && !selected)
         {
            this.focusSkin.setActualSize(unscaledWidth,unscaledHeight);
            setChildIndex(DisplayObject(this.focusSkin),numChildren - 1);
         }
         if(Boolean(currentIcon))
         {
            setChildIndex(DisplayObject(currentIcon),numChildren - 1);
         }
         if(Boolean(textField))
         {
            setChildIndex(DisplayObject(textField),numChildren - 1);
         }
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function viewIcon() : void
      {
         var scale:Number = NaN;
         super.viewIcon();
         if(Boolean(currentIcon))
         {
            if(height != 0 && currentIcon.height > height - 4)
            {
               scale = (height - 4) / currentIcon.height;
               currentIcon.scaleX = scale;
               currentIcon.scaleY = scale;
               invalidateSize();
               if(height > 0)
               {
                  this.layoutContents(width,height,false);
               }
            }
         }
      }
   }
}


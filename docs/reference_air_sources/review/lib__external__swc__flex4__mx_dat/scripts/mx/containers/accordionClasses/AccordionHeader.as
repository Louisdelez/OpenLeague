package mx.containers.accordionClasses
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import mx.containers.Accordion;
   import mx.controls.Button;
   import mx.core.IDataRenderer;
   import mx.core.IFlexDisplayObject;
   import mx.styles.ISimpleStyleClient;
   
   [AccessibilityClass(implementation="mx.accessibility.AccordionHeaderAccImpl")]
   public class AccordionHeader extends Button implements IDataRenderer
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var createAccessibilityImplementation:Function;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var focusObj:DisplayObject;
      
      private var focusSkin:IFlexDisplayObject;
      
      private var _data:Object;
      
      public function AccordionHeader()
      {
         super();
         toggleChanged = false;
         mouseFocusEnabled = false;
         tabEnabled = false;
         tabFocusEnabled = false;
      }
      
      override public function get data() : Object
      {
         return this._data;
      }
      
      override public function set data(value:Object) : void
      {
         this._data = value;
      }
      
      override public function set selected(value:Boolean) : void
      {
         _selected = value;
         invalidateDisplayList();
      }
      
      override protected function initializeAccessibility() : void
      {
         if(AccordionHeader.createAccessibilityImplementation != null)
         {
            AccordionHeader.createAccessibilityImplementation(this);
         }
      }
      
      override public function drawFocus(isFocused:Boolean) : void
      {
         var focusClass:Class = null;
         var focusStyleable:ISimpleStyleClient = null;
         if(isFocused && !isEffectStarted)
         {
            if(!this.focusObj)
            {
               focusClass = getStyle("focusSkin");
               this.focusObj = new focusClass();
               focusStyleable = this.focusObj as ISimpleStyleClient;
               if(Boolean(focusStyleable))
               {
                  focusStyleable.styleName = this;
               }
               addChild(this.focusObj);
               this.focusSkin = this.focusObj as IFlexDisplayObject;
            }
            if(Boolean(this.focusSkin))
            {
               this.focusSkin.move(0,0);
               this.focusSkin.setActualSize(unscaledWidth,unscaledHeight);
            }
            this.focusObj.visible = true;
            dispatchEvent(new Event("focusDraw"));
         }
         else if(Boolean(this.focusObj))
         {
            this.focusObj.visible = false;
         }
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function layoutContents(unscaledWidth:Number, unscaledHeight:Number, offset:Boolean) : void
      {
         super.layoutContents(unscaledWidth,unscaledHeight,offset);
         if(Boolean(this.focusObj))
         {
            setChildIndex(this.focusObj,numChildren - 1);
         }
      }
      
      override protected function rollOverHandler(event:MouseEvent) : void
      {
         super.rollOverHandler(event);
         var accordion:Accordion = Accordion(parent);
         if(accordion.enabled)
         {
            accordion.rawChildren.setChildIndex(this,accordion.rawChildren.numChildren - 1);
         }
      }
   }
}


package flexlib.containers.accordionClasses
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import mx.controls.Button;
   import mx.core.Container;
   import mx.core.IDataRenderer;
   import mx.core.IFlexDisplayObject;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.ISimpleStyleClient;
   import mx.styles.StyleManager;
   
   [Style(name="keepIconVertical",type="Boolean")]
   [AccessibilityClass(implementation="mx.accessibility.AccordionHeaderAccImpl")]
   [ExcludeClass]
   public class AccordionHeader extends Button implements IDataRenderer
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var createAccessibilityImplementation:Function;
      
      private var _data:Object;
      
      private var focusObj:DisplayObject;
      
      private var focusSkin:IFlexDisplayObject;
      
      public function AccordionHeader()
      {
         super();
         toggleChanged = false;
         mouseFocusEnabled = false;
         tabEnabled = false;
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function layoutContents(unscaledWidth:Number, unscaledHeight:Number, offset:Boolean) : void
      {
         super.layoutContents(unscaledWidth,unscaledHeight,offset);
         if(Boolean(focusObj))
         {
            setChildIndex(focusObj,numChildren - 1);
         }
         if(Boolean(currentIcon) && getStyle("keepIconVertical") == true)
         {
            DisplayObject(currentIcon).rotation = 90;
            currentIcon.x += currentIcon.width;
         }
      }
      
      override public function set selected(value:Boolean) : void
      {
         _selected = value;
         invalidateDisplayList();
      }
      
      override public function drawFocus(isFocused:Boolean) : void
      {
         var focusClass:Class = null;
         var focusStyleable:ISimpleStyleClient = null;
         if(isFocused && !isEffectStarted)
         {
            if(!focusObj)
            {
               focusClass = getStyle("focusSkin");
               focusObj = new focusClass();
               focusStyleable = focusObj as ISimpleStyleClient;
               if(Boolean(focusStyleable))
               {
                  focusStyleable.styleName = this;
               }
               addChild(focusObj);
               focusSkin = focusObj as IFlexDisplayObject;
            }
            if(Boolean(focusSkin))
            {
               focusSkin.move(0,0);
               focusSkin.setActualSize(unscaledWidth,unscaledHeight);
            }
            focusObj.visible = true;
            dispatchEvent(new Event("focusDraw"));
         }
         else if(Boolean(focusObj))
         {
            focusObj.visible = false;
         }
      }
      
      override protected function rollOverHandler(event:MouseEvent) : void
      {
         var accordion:Container = null;
         super.rollOverHandler(event);
         accordion = Container(parent);
         if(accordion.enabled)
         {
            accordion.rawChildren.setChildIndex(this,accordion.rawChildren.numChildren - 1);
         }
      }
      
      override protected function createChildren() : void
      {
         var styleDecl:CSSStyleDeclaration = null;
         var value:Number = NaN;
         super.createChildren();
         styleDecl = StyleManager.getStyleDeclaration(className);
         if(Boolean(styleDecl))
         {
            value = Number(styleDecl.getStyle("paddingLeft"));
            if(!isNaN(value))
            {
               setStyle("paddingLeft",value);
            }
            value = Number(styleDecl.getStyle("paddingRight"));
            if(!isNaN(value))
            {
               setStyle("paddingRight",value);
            }
         }
      }
      
      override public function set data(value:Object) : void
      {
         _data = value;
      }
      
      override protected function initializeAccessibility() : void
      {
         if(AccordionHeader.createAccessibilityImplementation != null)
         {
            AccordionHeader.createAccessibilityImplementation(this);
         }
      }
      
      override public function get data() : Object
      {
         return _data;
      }
   }
}


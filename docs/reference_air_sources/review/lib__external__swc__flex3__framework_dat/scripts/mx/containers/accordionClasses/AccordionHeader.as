package mx.containers.accordionClasses
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import mx.containers.Accordion;
   import mx.controls.Button;
   import mx.core.FlexVersion;
   import mx.core.IDataRenderer;
   import mx.core.IFlexDisplayObject;
   import mx.core.mx_internal;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.ISimpleStyleClient;
   import mx.styles.StyleManager;
   
   use namespace mx_internal;
   
   [AccessibilityClass(implementation="mx.accessibility.AccordionHeaderAccImpl")]
   public class AccordionHeader extends Button implements IDataRenderer
   {
      
      mx_internal static var createAccessibilityImplementation:Function;
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var _data:Object;
      
      private var focusSkin:IFlexDisplayObject;
      
      private var focusObj:DisplayObject;
      
      public function AccordionHeader()
      {
         super();
         mx_internal::toggleChanged = false;
         mouseFocusEnabled = false;
         tabEnabled = false;
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
      
      override protected function createChildren() : void
      {
         var styleDecl:CSSStyleDeclaration = null;
         var value:Number = NaN;
         super.createChildren();
         if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
         {
            styleDecl = StyleManager.getStyleDeclaration(className);
            if(Boolean(styleDecl))
            {
               value = styleDecl.getStyle("paddingLeft");
               if(!isNaN(value))
               {
                  setStyle("paddingLeft",value);
               }
               value = styleDecl.getStyle("paddingRight");
               if(!isNaN(value))
               {
                  setStyle("paddingRight",value);
               }
            }
         }
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
      
      override mx_internal function layoutContents(unscaledWidth:Number, unscaledHeight:Number, offset:Boolean) : void
      {
         super.mx_internal::layoutContents(unscaledWidth,unscaledHeight,offset);
         if(Boolean(focusObj))
         {
            setChildIndex(focusObj,numChildren - 1);
         }
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
      
      override public function set data(value:Object) : void
      {
         _data = value;
      }
      
      override public function set selected(value:Boolean) : void
      {
         _selected = value;
         invalidateDisplayList();
      }
   }
}


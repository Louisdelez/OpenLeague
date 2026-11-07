package flexlib.scheduling.scheduleClasses.renderers
{
   import flash.accessibility.*;
   import flash.debugger.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   import flash.printing.*;
   import flash.profiler.*;
   import flash.system.*;
   import flash.text.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;
   import flexlib.scheduling.scheduleClasses.IScheduleEntry;
   import flexlib.scheduling.scheduleClasses.SimpleScheduleEntry;
   import mx.binding.*;
   import mx.containers.Box;
   import mx.controls.Label;
   import mx.controls.Text;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.formatters.DateFormatter;
   import mx.styles.*;
   
   public class AbstractSolidScheduleEntryRenderer extends Box implements IScheduleEntryRenderer
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var _AbstractSolidScheduleEntryRenderer_StylesInit_done:Boolean = false;
      
      public var _bindingsByDestination:Object;
      
      private var formatter:DateFormatter;
      
      private var defaultLabel:String = "";
      
      public var contentText:Text;
      
      public var _bindingsBeginWithWord:Object;
      
      public var contentLabel:Label;
      
      private var formatString:String = "L:NNAA";
      
      private var _entry:IScheduleEntry;
      
      private var _selected:Boolean = false;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      public function AbstractSolidScheduleEntryRenderer()
      {
         _documentDescriptor_ = new UIComponentDescriptor({"type":Box});
         defaultLabel = "";
         formatString = "L:NNAA";
         _selected = false;
         super();
         mx_internal::_document = this;
         if(!this.styleDeclaration)
         {
            this.styleDeclaration = new CSSStyleDeclaration();
         }
         this.styleDeclaration.defaultFactory = function():void
         {
            this.borderStyle = "solid";
         };
         mx_internal::_AbstractSolidScheduleEntryRenderer_StylesInit();
         this.verticalScrollPolicy = "off";
         this.horizontalScrollPolicy = "off";
         this.styleName = "defaultEntryStyle";
         this.addEventListener("preinitialize",___Box1_preinitialize);
      }
      
      protected function setTextContent(content:SimpleScheduleEntry) : void
      {
         var time:String = null;
         if(content.label == null)
         {
            content.label = defaultLabel;
         }
         formatter.error = "";
         time = formatter.format(content.startDate) + " - " + formatter.format(content.endDate);
         toolTip = time + "\n" + content.label;
         contentLabel.text = time;
         contentLabel.styleName = getStyle("timeStyleName");
         contentText.text = content.label;
         updateSelected();
      }
      
      public function ___Box1_preinitialize(event:FlexEvent) : void
      {
         onPreinitialize();
      }
      
      public function set entry(value:IScheduleEntry) : void
      {
         _entry = value;
      }
      
      public function get entry() : IScheduleEntry
      {
         return _entry;
      }
      
      public function set selected(value:Boolean) : void
      {
         _selected = value;
         updateSelected();
      }
      
      private function updateSelected() : void
      {
         if(_selected)
         {
            setStyle("dropShadowEnabled",true);
            setStyle("borderColor",16777215);
            setStyle("borderThickness",2);
            alpha = 1;
         }
         else
         {
            setStyle("dropShadowEnabled",false);
            setStyle("borderColor",13421772);
            setStyle("borderThickness",1);
            alpha = 0.6;
         }
      }
      
      public function get selected() : Boolean
      {
         return _selected;
      }
      
      public function onPreinitialize() : void
      {
         formatter = new DateFormatter();
         formatter.formatString = formatString;
      }
      
      override public function initialize() : void
      {
         mx_internal::setDocumentDescriptor(_documentDescriptor_);
         super.initialize();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function _AbstractSolidScheduleEntryRenderer_StylesInit() : void
      {
         var style:CSSStyleDeclaration = null;
         var effects:Array = null;
         if(mx_internal::_AbstractSolidScheduleEntryRenderer_StylesInit_done)
         {
            return;
         }
         mx_internal::_AbstractSolidScheduleEntryRenderer_StylesInit_done = true;
         style = StyleManager.getStyleDeclaration(".defaultTimeStyle");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".defaultTimeStyle",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "bold";
               this.color = 0;
               this.fontSize = 9;
            };
         }
         style = StyleManager.getStyleDeclaration(".defaultEntryStyle");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".defaultEntryStyle",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "normal";
               this.timeStyleName = "defaultTimeStyle";
               this.paddingTop = 5;
               this.color = 0;
               this.backgroundColor = 13421772;
               this.fontSize = 11;
               this.verticalGap = -2;
               this.paddingBottom = 5;
               this.paddingLeft = 5;
               this.paddingRight = 5;
            };
         }
      }
   }
}


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
   import mx.utils.ColorUtil;
   
   public class AbstractGradientScheduleEntryRenderer extends Box implements IScheduleEntryRenderer
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var _AbstractGradientScheduleEntryRenderer_StylesInit_done:Boolean = false;
      
      private var changeSelection:Boolean;
      
      public var _bindingsByDestination:Object;
      
      private var formatter:DateFormatter;
      
      private var defaultLabel:String = "";
      
      public var contentText:Text;
      
      public var _bindingsBeginWithWord:Object;
      
      public var contentLabel:Label;
      
      private var origFillColors:Array;
      
      private var formatString:String = "L:NNAA";
      
      private var _entry:IScheduleEntry;
      
      private var _selected:Boolean = false;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      public function AbstractGradientScheduleEntryRenderer()
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
            this.borderStyle = "applicationControlBar";
         };
         mx_internal::_AbstractGradientScheduleEntryRenderer_StylesInit();
         this.styleName = "defaultEntryStyle";
         this.verticalScrollPolicy = "off";
         this.horizontalScrollPolicy = "off";
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
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function _AbstractGradientScheduleEntryRenderer_StylesInit() : void
      {
         var style:CSSStyleDeclaration = null;
         var effects:Array = null;
         if(mx_internal::_AbstractGradientScheduleEntryRenderer_StylesInit_done)
         {
            return;
         }
         mx_internal::_AbstractGradientScheduleEntryRenderer_StylesInit_done = true;
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
               this.borderStyle = "default";
               this.timeStyleName = "defaultTimeStyle";
               this.borderColor = 3381606;
               this.paddingTop = 5;
               this.backgroundColor = 10053171;
               this.shadowDistance = 2;
               this.cornerRadius = 6;
               this.fontSize = 11;
               this.verticalGap = -2;
               this.fillAlphas = [1,1];
               this.paddingLeft = 5;
               this.paddingRight = 5;
               this.fontWeight = "normal";
               this.dropShadowEnabled = true;
               this.color = 16777215;
               this.borderThickness = 1;
               this.highlightAlphas = [0.08,0];
               this.fillColors = [8037564,5473183];
               this.paddingBottom = 5;
            };
         }
      }
      
      private function updateSelected() : void
      {
         var newColor1:uint = 0;
         var newColor2:uint = 0;
         if(origFillColors == null)
         {
            origFillColors = getStyle("fillColors");
         }
         if(_selected)
         {
            setStyle("dropShadowEnabled",true);
            changeSelection = true;
            newColor1 = uint(ColorUtil.adjustBrightness2(origFillColors[0],25));
            newColor2 = uint(ColorUtil.adjustBrightness2(origFillColors[1],25));
            setStyle("fillColors",[newColor1,newColor2]);
         }
         else
         {
            setStyle("dropShadowEnabled",false);
            changeSelection = true;
            newColor1 = uint(ColorUtil.adjustBrightness2(origFillColors[0],0));
            newColor2 = uint(ColorUtil.adjustBrightness2(origFillColors[1],0));
            setStyle("fillColors",[newColor1,newColor2]);
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
      
      override public function styleChanged(styleProp:String) : void
      {
         super.styleChanged(styleProp);
         if(styleProp != null)
         {
            if(styleProp == "fillColors" && !changeSelection)
            {
               origFillColors = getStyle(styleProp);
            }
            else if(changeSelection)
            {
               changeSelection = false;
            }
         }
      }
   }
}


package flexlib.scheduling.timelineClasses
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
   import mx.binding.*;
   import mx.controls.Label;
   import mx.formatters.DateFormatter;
   import mx.styles.*;
   
   public class SimpleTimelineEntryRenderer extends Label implements ITimelineEntryRenderer
   {
      
      public var _bindingsByDestination:Object;
      
      public var _bindingsBeginWithWord:Object;
      
      public function SimpleTimelineEntryRenderer()
      {
         super();
         if(!this.styleDeclaration)
         {
            this.styleDeclaration = new CSSStyleDeclaration();
         }
         this.styleDeclaration.defaultFactory = function():void
         {
            this.textAlign = "center";
         };
      }
      
      override public function set data(value:Object) : void
      {
         var entry:ITimeDescriptor = null;
         var formatter:DateFormatter = null;
         entry = ITimeDescriptor(value);
         formatter = new DateFormatter();
         formatter.formatString = String(entry.description);
         text = formatter.format(entry.date);
      }
      
      override public function initialize() : void
      {
         super.initialize();
      }
   }
}


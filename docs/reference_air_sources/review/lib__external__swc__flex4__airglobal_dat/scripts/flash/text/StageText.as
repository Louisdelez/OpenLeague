package flash.text
{
   import flash.display.BitmapData;
   import flash.display.Stage;
   import flash.events.EventDispatcher;
   import flash.geom.Rectangle;
   
   [API("675")]
   [native(cls="StageTextClass",instance="StageTextObject",methods="auto")]
   [Event(name="complete",type="flash.events.Event")]
   [Event(name="keyUp",type="flash.events.KeyboardEvent")]
   [Event(name="keyDown",type="flash.events.KeyboardEvent")]
   [Event(name="softKeyboardDeactivate",type="flash.events.SoftKeyboardEvent")]
   [Event(name="softKeyboardActivate",type="flash.events.SoftKeyboardEvent")]
   [Event(name="softKeyboardActivating",type="flash.events.SoftKeyboardEvent")]
   [Event(name="focusOut",type="flash.events.FocusEvent")]
   [Event(name="focusIn",type="flash.events.FocusEvent")]
   [Event(name="change",type="flash.events.Event")]
   public final class StageText extends EventDispatcher
   {
      
      public function StageText(initOptions:StageTextInitOptions = null)
      {
         if(null == initOptions)
         {
            initOptions = new StageTextInitOptions();
         }
         super();
         this.init(initOptions);
      }
      
      private native function init(param1:StageTextInitOptions) : void;
      
      public native function set editable(param1:Boolean) : void;
      
      public native function get editable() : Boolean;
      
      public native function set text(param1:String) : void;
      
      public native function get text() : String;
      
      public native function set fontFamily(param1:String) : void;
      
      public native function get fontFamily() : String;
      
      public native function set fontSize(param1:int) : *;
      
      public native function get fontSize() : int;
      
      public native function set color(param1:uint) : *;
      
      public native function get color() : uint;
      
      public native function set fontWeight(param1:String) : void;
      
      public native function get fontWeight() : String;
      
      public native function set fontPosture(param1:String) : void;
      
      public native function get fontPosture() : String;
      
      public native function get displayAsPassword() : Boolean;
      
      public native function set displayAsPassword(param1:Boolean) : void;
      
      public native function set maxChars(param1:int) : void;
      
      public native function get maxChars() : int;
      
      public native function get multiline() : Boolean;
      
      public native function set restrict(param1:String) : void;
      
      public native function get restrict() : String;
      
      public native function set returnKeyLabel(param1:String) : void;
      
      public native function get returnKeyLabel() : String;
      
      public native function set textAlign(param1:String) : void;
      
      public native function get textAlign() : String;
      
      public native function get softKeyboardType() : String;
      
      public native function set softKeyboardType(param1:String) : void;
      
      public native function set autoCapitalize(param1:String) : void;
      
      public native function get autoCapitalize() : String;
      
      public native function set autoCorrect(param1:Boolean) : void;
      
      public native function get autoCorrect() : Boolean;
      
      public native function set locale(param1:String) : void;
      
      public native function get locale() : String;
      
      public native function assignFocus() : void;
      
      public native function selectRange(param1:int, param2:int) : void;
      
      public native function get selectionActiveIndex() : int;
      
      public native function get selectionAnchorIndex() : int;
      
      public native function set stage(param1:Stage) : void;
      
      public native function get stage() : Stage;
      
      public native function set viewPort(param1:Rectangle) : void;
      
      public native function get viewPort() : Rectangle;
      
      public native function drawViewPortToBitmapData(param1:BitmapData) : void;
      
      public native function dispose() : void;
      
      public native function get visible() : Boolean;
      
      public native function set visible(param1:Boolean) : void;
   }
}


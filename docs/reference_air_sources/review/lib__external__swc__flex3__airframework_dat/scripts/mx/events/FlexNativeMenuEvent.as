package mx.events
{
   import flash.display.NativeMenu;
   import flash.display.NativeMenuItem;
   import flash.events.Event;
   
   public class FlexNativeMenuEvent extends Event
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.6.0.12937";
      
      public static const ITEM_CLICK:String = "itemClick";
      
      public static const MENU_SHOW:String = "menuShow";
      
      public var index:int;
      
      public var label:String;
      
      public var nativeMenuItem:NativeMenuItem;
      
      public var item:Object;
      
      public var nativeMenu:NativeMenu;
      
      public function FlexNativeMenuEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = true, nativeMenu:NativeMenu = null, nativeMenuItem:NativeMenuItem = null, item:Object = null, label:String = null, index:int = -1)
      {
         super(type,bubbles,cancelable);
         this.nativeMenu = nativeMenu;
         this.nativeMenuItem = nativeMenuItem;
         this.item = item;
         this.label = label;
         this.index = index;
      }
      
      override public function clone() : Event
      {
         return new FlexNativeMenuEvent(type,bubbles,cancelable,nativeMenu,nativeMenuItem);
      }
   }
}


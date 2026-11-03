package mx.events
{
   import flash.events.Event;
   import mx.controls.Menu;
   import mx.controls.MenuBar;
   import mx.controls.listClasses.IListItemRenderer;
   
   public class MenuEvent extends ListEvent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public static const CHANGE:String = "change";
      
      public static const ITEM_CLICK:String = "itemClick";
      
      public static const MENU_HIDE:String = "menuHide";
      
      public static const ITEM_ROLL_OUT:String = "itemRollOut";
      
      public static const ITEM_ROLL_OVER:String = "itemRollOver";
      
      public static const MENU_SHOW:String = "menuShow";
      
      public var index:int;
      
      public var item:Object;
      
      public var label:String;
      
      public var menu:Menu;
      
      public var menuBar:MenuBar;
      
      public function MenuEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = true, menuBar:MenuBar = null, menu:Menu = null, item:Object = null, itemRenderer:IListItemRenderer = null, label:String = null, index:int = -1)
      {
         super(type,bubbles,cancelable);
         this.menuBar = menuBar;
         this.menu = menu;
         this.item = item;
         this.itemRenderer = itemRenderer;
         this.label = label;
         this.index = index;
      }
      
      override public function clone() : Event
      {
         return new MenuEvent(type,bubbles,cancelable,this.menuBar,this.menu,this.item,itemRenderer,this.label,this.index);
      }
   }
}


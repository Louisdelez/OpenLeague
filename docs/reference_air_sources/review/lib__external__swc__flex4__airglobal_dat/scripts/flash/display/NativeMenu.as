package flash.display
{
   import flash.events.*;
   
   [native(cls="MenuClass",gc="exact",instance="MenuObject",methods="auto")]
   [API("667")]
   [Event(name="preparing",type="flash.events.Event")]
   [Event(name="displaying",type="flash.events.Event")]
   [Event(name="select",type="flash.events.Event")]
   public class NativeMenu extends EventDispatcher
   {
      
      public function NativeMenu()
      {
         super();
      }
      
      public static native function get isSupported() : Boolean;
      
      public native function get parent() : NativeMenu;
      
      public function get numItems() : int
      {
         return this._numItems;
      }
      
      private native function get _numItems() : int;
      
      public function get items() : Array
      {
         var itemArray:Array = new Array();
         var i:int = 0;
         for(i = 0; i < this._numItems; i++)
         {
            itemArray.push(this.getItemAt(i));
         }
         return itemArray;
      }
      
      public function set items(itemArray:Array) : void
      {
         var i:int = 0;
         for(i = 0; i < itemArray.length; i++)
         {
            if(!itemArray[i] is NativeMenuItem)
            {
               Error.throwError(ArgumentError,2005);
            }
         }
         this.removeAllItems();
         for(i = 0; i < itemArray.length; i++)
         {
            this.addItem(itemArray[i]);
         }
      }
      
      public function addItem(item:NativeMenuItem) : NativeMenuItem
      {
         return this.addItemAt(item,this.numItems);
      }
      
      public function addItemAt(item:NativeMenuItem, index:int) : NativeMenuItem
      {
         if(index > this._numItems || index < 0)
         {
            Error.throwError(RangeError,2006);
         }
         if(item == null)
         {
            Error.throwError(ArgumentError,2007,"item");
         }
         if(item.menu != null)
         {
            Error.throwError(ArgumentError,2004,"item");
         }
         return this._addItemAt(item,index);
      }
      
      private native function _addItemAt(param1:NativeMenuItem, param2:int) : NativeMenuItem;
      
      public function containsItem(item:NativeMenuItem) : Boolean
      {
         if(item == null)
         {
            Error.throwError(ArgumentError,2007,"item");
         }
         return this._containsItem(item);
      }
      
      private native function _containsItem(param1:NativeMenuItem) : Boolean;
      
      public function getItemAt(index:int) : NativeMenuItem
      {
         if(index >= this._numItems || index < 0)
         {
            Error.throwError(RangeError,2006);
         }
         return this._getItemAt(index);
      }
      
      private native function _getItemAt(param1:int) : NativeMenuItem;
      
      public function getItemByName(name:String) : NativeMenuItem
      {
         if(name == null)
         {
            Error.throwError(ArgumentError,2007,"name");
         }
         return this._getItemByName(name);
      }
      
      private native function _getItemByName(param1:String) : NativeMenuItem;
      
      public function removeItem(item:NativeMenuItem) : NativeMenuItem
      {
         if(item == null)
         {
            Error.throwError(ArgumentError,2007,"item");
         }
         var index:int = this.getItemIndex(item);
         return this.removeItemAt(index);
      }
      
      public function removeItemAt(index:int) : NativeMenuItem
      {
         if(index >= this._numItems || index < 0)
         {
            Error.throwError(RangeError,2006);
         }
         return this._removeItemAt(index);
      }
      
      private native function _removeItemAt(param1:int) : NativeMenuItem;
      
      public function removeAllItems() : void
      {
         var i:int = 0;
         var nbItems:int = this.numItems;
         for(i = 0; i < nbItems; i++)
         {
            this.removeItemAt(0);
         }
      }
      
      public function getItemIndex(item:NativeMenuItem) : int
      {
         if(item == null)
         {
            Error.throwError(ArgumentError,2007,"item");
         }
         return this._getItemIndex(item);
      }
      
      private native function _getItemIndex(param1:NativeMenuItem) : int;
      
      public function setItemIndex(item:NativeMenuItem, index:int) : void
      {
         if(index >= this._numItems || index < 0)
         {
            Error.throwError(RangeError,2006);
         }
         if(item == null)
         {
            Error.throwError(ArgumentError,2007,"item");
         }
         var currentIndex:int = this.getItemIndex(item);
         if(currentIndex != -1)
         {
            this.removeItemAt(currentIndex);
         }
         this.addItemAt(item,index);
      }
      
      public function addSubmenuAt(submenu:NativeMenu, index:int, label:String) : NativeMenuItem
      {
         var item:NativeMenuItem = new NativeMenuItem(label);
         item.submenu = submenu;
         return this.addItemAt(item,index);
      }
      
      public function addSubmenu(submenu:NativeMenu, label:String) : NativeMenuItem
      {
         return this.addSubmenuAt(submenu,this.numItems,label);
      }
      
      public function display(stage:Stage, stageX:Number, stageY:Number) : void
      {
         this._display(stage,stageX,stageY);
      }
      
      public function clone() : NativeMenu
      {
         var newMenu:NativeMenu = new NativeMenu();
         var i:int = 0;
         for(i = 0; i < this.numItems; i++)
         {
            newMenu.addItem(this.getItemAt(i).clone());
         }
         return newMenu;
      }
      
      private native function _dispatchPreparingEvent() : void;
      
      private function willPerformKeyEquivalent(event:KeyboardEvent) : Boolean
      {
         var i:int = 0;
         var willPerform:Boolean = false;
         for(i = 0; i < this.numItems; i++)
         {
            if(this._menuItemWillPerformKeyEquivalent(this.getItemAt(i),event))
            {
               willPerform = true;
               break;
            }
         }
         return willPerform;
      }
      
      private native function _menuItemWillPerformKeyEquivalent(param1:NativeMenuItem, param2:KeyboardEvent) : Boolean;
      
      private function performKeyEquivalent(event:KeyboardEvent) : Boolean
      {
         var i:int = 0;
         if(!this.willPerformKeyEquivalent(event))
         {
            return false;
         }
         this._dispatchPreparingEvent();
         var performed:Boolean = false;
         for(i = 0; i < this.numItems; i++)
         {
            if(this._menuItemPerformKeyEquivalent(this.getItemAt(i),event))
            {
               performed = true;
               break;
            }
         }
         return performed;
      }
      
      private native function _menuItemPerformKeyEquivalent(param1:NativeMenuItem, param2:KeyboardEvent) : Boolean;
      
      private native function _display(param1:Stage, param2:Number, param3:Number) : void;
      
      public function dispatchContextMenuSelect(event:MouseEvent) : *
      {
         dispatchEvent(new ContextMenuEvent(ContextMenuEvent.MENU_SELECT,false,false,event.target as InteractiveObject,event.currentTarget as InteractiveObject));
      }
   }
}


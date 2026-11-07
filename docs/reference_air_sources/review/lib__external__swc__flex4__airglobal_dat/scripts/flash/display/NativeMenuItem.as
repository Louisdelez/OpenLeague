package flash.display
{
   import flash.errors.*;
   import flash.events.EventDispatcher;
   import flash.events.KeyboardEvent;
   import flash.ui.*;
   
   [native(cls="MenuItemClass",gc="exact",instance="MenuItemObject",methods="auto")]
   [API("667")]
   [Event(name="preparing",type="flash.events.Event")]
   [Event(name="displaying",type="flash.events.Event")]
   [Event(name="select",type="flash.events.Event")]
   public class NativeMenuItem extends EventDispatcher
   {
      
      private static const kInvalidCallError:uint = 2037;
      
      public function NativeMenuItem(label:String = "", isSeparator:Boolean = false)
      {
         super();
         this.ctor(label,isSeparator);
      }
      
      public native function get enabled() : Boolean;
      
      public native function set enabled(param1:Boolean) : void;
      
      private native function ctor(param1:String, param2:Boolean) : void;
      
      public native function get menu() : NativeMenu;
      
      public native function get name() : String;
      
      public native function set name(param1:String) : void;
      
      public native function get isSeparator() : Boolean;
      
      public native function get checked() : Boolean;
      
      public native function set checked(param1:Boolean) : void;
      
      public native function get label() : String;
      
      public native function set label(param1:String) : void;
      
      public native function get keyEquivalent() : String;
      
      public native function set keyEquivalent(param1:String) : void;
      
      public native function get keyEquivalentModifiers() : Array;
      
      public native function set keyEquivalentModifiers(param1:Array) : void;
      
      public native function get mnemonicIndex() : int;
      
      public function set mnemonicIndex(index:int) : void
      {
         if(index >= this.label.length || index < -1)
         {
            Error.throwError(RangeError,2006);
         }
         this._mnemonicIndex = index;
      }
      
      private native function set _mnemonicIndex(param1:int) : void;
      
      public native function get submenu() : NativeMenu;
      
      public function set submenu(submenu:NativeMenu) : void
      {
         var parentMenu:NativeMenu = null;
         var i:int = 0;
         var parentItem:NativeMenuItem = null;
         if(this.isSeparator)
         {
            Error.throwError(IllegalOperationError,kInvalidCallError);
         }
         if(Boolean(submenu))
         {
            parentMenu = submenu.parent;
            if(Boolean(parentMenu))
            {
               i = 0;
               for(i = 0; i < parentMenu.numItems; i++)
               {
                  parentItem = parentMenu.getItemAt(i);
                  if(parentItem.submenu == submenu)
                  {
                     parentItem.submenu = null;
                  }
               }
            }
         }
         this._submenu = submenu;
      }
      
      private native function set _submenu(param1:NativeMenu) : void;
      
      public native function get data() : Object;
      
      public native function set data(param1:Object) : void;
      
      public function clone() : NativeMenuItem
      {
         var newMenuItem:NativeMenuItem = new NativeMenuItem(this.label,this.isSeparator);
         newMenuItem.name = this.name;
         newMenuItem.enabled = this.enabled;
         newMenuItem.checked = this.checked;
         newMenuItem.keyEquivalent = this.keyEquivalent;
         newMenuItem.keyEquivalentModifiers = this.keyEquivalentModifiers;
         newMenuItem.mnemonicIndex = this.mnemonicIndex;
         newMenuItem.submenu = Boolean(this.submenu) ? this.submenu.clone() : null;
         return newMenuItem;
      }
      
      private function willPerformKeyEquivalent(event:KeyboardEvent) : Boolean
      {
         var mods:Array = null;
         var willPerform:Boolean = false;
         if(Boolean(this.submenu))
         {
            willPerform = Boolean(this._menuWillPerformKeyEquivalent(this.submenu,event));
         }
         else if(!this.isSeparator)
         {
            if(Boolean(this.keyEquivalent) && Boolean(this.keyEquivalent.length > 0) && (this.keyEquivalent.charCodeAt(0) == event.charCode || Boolean(this._compareCharToKeyCode(this.keyEquivalent.charCodeAt(0),event.keyCode))))
            {
               mods = Boolean(this.keyEquivalentModifiers) ? this.keyEquivalentModifiers : new Array();
               if(mods.indexOf(Keyboard.CONTROL) != -1 == event.controlKey && mods.indexOf(Keyboard.SHIFT) != -1 == event.shiftKey && mods.indexOf(Keyboard.ALTERNATE) != -1 == event.altKey && mods.indexOf(Keyboard.COMMAND) != -1 == event.commandKey && mods.indexOf(Keyboard.NUMPAD) != -1 == (event.keyLocation == KeyLocation.NUM_PAD))
               {
                  willPerform = true;
               }
            }
         }
         return willPerform;
      }
      
      private native function _menuWillPerformKeyEquivalent(param1:NativeMenu, param2:KeyboardEvent) : Boolean;
      
      private native function _compareCharToKeyCode(param1:uint, param2:uint) : Boolean;
      
      private function performKeyEquivalent(event:KeyboardEvent) : Boolean
      {
         var mods:Array = null;
         var performed:Boolean = false;
         if(Boolean(this.submenu))
         {
            performed = Boolean(this._menuPerformKeyEquivalent(this.submenu,event));
         }
         else if(!this.isSeparator && this.enabled)
         {
            if(Boolean(this.keyEquivalent) && Boolean(this.keyEquivalent.length > 0) && (this.keyEquivalent.charCodeAt(0) == event.charCode || Boolean(this._compareCharToKeyCode(this.keyEquivalent.charCodeAt(0),event.keyCode))))
            {
               mods = Boolean(this.keyEquivalentModifiers) ? this.keyEquivalentModifiers : new Array();
               if(mods.indexOf(Keyboard.CONTROL) != -1 == event.controlKey && mods.indexOf(Keyboard.SHIFT) != -1 == event.shiftKey && mods.indexOf(Keyboard.ALTERNATE) != -1 == event.altKey && mods.indexOf(Keyboard.COMMAND) != -1 == event.commandKey && mods.indexOf(Keyboard.NUMPAD) != -1 == (event.keyLocation == KeyLocation.NUM_PAD))
               {
                  this.select();
                  performed = true;
               }
            }
         }
         return performed;
      }
      
      private native function _menuPerformKeyEquivalent(param1:NativeMenu, param2:KeyboardEvent) : Boolean;
      
      private native function select() : void;
      
      private function formatToString(className:String, ... arguments) : String
      {
         var name:String = null;
         var value:* = undefined;
         var s:String = "";
         s += "[" + className;
         for(var i:uint = 0; i < arguments.length; i++)
         {
            name = arguments[i];
            value = this[name];
            if(value is String)
            {
               s += " " + name + "=\"" + value + "\"";
            }
            else if(value is Array && value != null)
            {
               s += " " + name + "={ ";
               s += value.toString();
               s += " }";
            }
            else
            {
               s += " " + name + "=" + value;
            }
         }
         return s + "]";
      }
      
      override public function toString() : String
      {
         return this.formatToString("NativeMenuItem","label","keyEquivalent","keyEquivalentChar","keyEquivalentModifiers");
      }
      
      private function get keyEquivalentChar() : int
      {
         if(this.keyEquivalent != null && this.keyEquivalent.length > 0)
         {
            return this.keyEquivalent.charCodeAt(0);
         }
         return 0;
      }
   }
}


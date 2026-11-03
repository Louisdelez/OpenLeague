package flash.ui
{
   import flash.display.InteractiveObject;
   import flash.display.NativeMenu;
   import flash.display.NativeMenuItem;
   import flash.events.*;
   
   [native(cls="ContextMenuItemClass",gc="exact",instance="ContextMenuItemObject",methods="auto")]
   [Event(name="menuItemSelect",type="flash.events.ContextMenuEvent")]
   public final class ContextMenuItem extends NativeMenuItem
   {
      
      public function ContextMenuItem(caption:String, separatorBefore:Boolean = false, enabled:Boolean = true, visible:Boolean = true)
      {
         super();
         this.caption = caption;
         this.separatorBefore = separatorBefore;
         this.enabled = enabled;
         this.visible = visible;
      }
      
      private static native function _getMenuString(param1:String) : String;
      
      internal static function systemCutMenuItem() : ContextMenuItem
      {
         var menuItem:ContextMenuItem = new ContextMenuItem(_getMenuString("EDIT__CUT"));
         menuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,menuItem.cut,false,int.MAX_VALUE,true);
         return menuItem;
      }
      
      internal static function systemCopyMenuItem() : ContextMenuItem
      {
         var menuItem:ContextMenuItem = new ContextMenuItem(_getMenuString("EDIT__COPY"));
         menuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,menuItem.copy,false,int.MAX_VALUE,true);
         return menuItem;
      }
      
      internal static function systemPasteMenuItem() : ContextMenuItem
      {
         var menuItem:ContextMenuItem = new ContextMenuItem(_getMenuString("EDIT__PASTE"));
         menuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,menuItem.paste,false,int.MAX_VALUE,true);
         return menuItem;
      }
      
      private static native function _setUserRequestingPaste(param1:Boolean) : void;
      
      internal static function systemClearMenuItem() : ContextMenuItem
      {
         var menuLabel:String = _getMenuString("EDIT__DELETE");
         var menuItem:ContextMenuItem = new ContextMenuItem(Boolean(menuLabel) ? menuLabel : "Delete");
         menuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,menuItem.clear,false,int.MAX_VALUE,true);
         return menuItem;
      }
      
      internal static function systemSelectAllMenuItem() : ContextMenuItem
      {
         var menuItem:ContextMenuItem = new ContextMenuItem(_getMenuString("EDIT__SELECT_ALL"));
         menuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,menuItem.selectAll,false,int.MAX_VALUE,true);
         return menuItem;
      }
      
      internal static function systemOpenLinkMenuItem() : ContextMenuItem
      {
         var menuItem:ContextMenuItem = new ContextMenuItem(_getMenuString("HTML_CONTEXTMENU__NAVIGATION__OPEN_LINK"));
         menuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,menuItem.openLink,false,int.MAX_VALUE,true);
         return menuItem;
      }
      
      internal static function systemCopyLinkMenuItem() : ContextMenuItem
      {
         var menuItem:ContextMenuItem = new ContextMenuItem(_getMenuString("HTML_CONTEXTMENU__EDIT__COPY_LINK"));
         menuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,menuItem.copyLink,false,int.MAX_VALUE,true);
         return menuItem;
      }
      
      private static native function _isTextEditor(param1:InteractiveObject) : Boolean;
      
      public native function get caption() : String;
      
      public native function set caption(param1:String) : void;
      
      public native function get separatorBefore() : Boolean;
      
      public native function set separatorBefore(param1:Boolean) : void;
      
      public native function get visible() : Boolean;
      
      public native function set visible(param1:Boolean) : void;
      
      private function cut(ev:ContextMenuEvent) : void
      {
         var menuItem:ContextMenuItem = ev.target as ContextMenuItem;
         var owner:InteractiveObject = ev.contextMenuOwner;
         if(_isTextEditor(owner))
         {
            this.nativeCut();
         }
         else
         {
            ev.contextMenuOwner.dispatchEvent(new Event(Event.CUT,false,true));
         }
      }
      
      private function copy(ev:ContextMenuEvent) : void
      {
         var menuItem:ContextMenuItem = ev.target as ContextMenuItem;
         var owner:InteractiveObject = ev.contextMenuOwner;
         if(_isTextEditor(owner))
         {
            this.nativeCopy();
         }
         else
         {
            ev.contextMenuOwner.dispatchEvent(new Event(Event.COPY,false,true));
         }
      }
      
      private function paste(ev:ContextMenuEvent) : void
      {
         var menuItem:ContextMenuItem = ev.target as ContextMenuItem;
         var owner:InteractiveObject = ev.contextMenuOwner;
         _setUserRequestingPaste(true);
         if(_isTextEditor(owner))
         {
            this.nativePaste();
         }
         else
         {
            ev.contextMenuOwner.dispatchEvent(new Event(Event.PASTE,false,true));
         }
         _setUserRequestingPaste(false);
      }
      
      private function clear(ev:ContextMenuEvent) : void
      {
         var menuItem:ContextMenuItem = ev.target as ContextMenuItem;
         var owner:InteractiveObject = ev.contextMenuOwner;
         if(_isTextEditor(owner))
         {
            this.nativeClear();
         }
         else
         {
            ev.contextMenuOwner.dispatchEvent(new Event(Event.CLEAR,false,true));
         }
      }
      
      private function selectAll(ev:ContextMenuEvent) : void
      {
         var menuItem:ContextMenuItem = ev.target as ContextMenuItem;
         var owner:InteractiveObject = ev.contextMenuOwner;
         if(_isTextEditor(owner))
         {
            this.nativeSelectAll();
         }
         else
         {
            ev.contextMenuOwner.dispatchEvent(new Event(Event.SELECT_ALL,false,true));
         }
      }
      
      private function openLink(ev:ContextMenuEvent) : void
      {
         var menuItem:ContextMenuItem = ev.target as ContextMenuItem;
         var menu:ContextMenu = menuItem.menu as ContextMenu;
         menu._openLink();
      }
      
      private function copyLink(ev:ContextMenuEvent) : void
      {
         var menuItem:ContextMenuItem = ev.target as ContextMenuItem;
         var menu:ContextMenu = menuItem.menu as ContextMenu;
         menu._copyLink();
      }
      
      private native function nativeClear() : void;
      
      private native function nativeCopy() : void;
      
      private native function nativeCut() : void;
      
      private native function nativePaste() : void;
      
      private native function nativeSelectAll() : void;
      
      override public function clone() : NativeMenuItem
      {
         var newMenuItem:ContextMenuItem = new ContextMenuItem(label,isSeparator);
         newMenuItem.name = name;
         newMenuItem.enabled = enabled;
         newMenuItem.checked = checked;
         newMenuItem.keyEquivalent = keyEquivalent;
         newMenuItem.keyEquivalentModifiers = keyEquivalentModifiers;
         newMenuItem.mnemonicIndex = mnemonicIndex;
         newMenuItem.submenu = Boolean(submenu) ? submenu.clone() : null;
         newMenuItem.separatorBefore = this.separatorBefore;
         newMenuItem.visible = this.visible;
         return newMenuItem;
      }
   }
}


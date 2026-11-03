package flash.ui
{
   import flash.desktop.*;
   import flash.display.*;
   import flash.net.*;
   
   [native(cls="ContextMenuClass",gc="exact",instance="ContextMenuObject",methods="auto")]
   [Event(name="menuSelect",type="flash.events.ContextMenuEvent")]
   public final class ContextMenu extends NativeMenu
   {
      
      private var m_customItems:Array;
      
      private var m_link:URLRequest;
      
      private var m_showClipboardMenu:Boolean;
      
      private var m_clipboardItems:ContextMenuClipboardItems;
      
      public function ContextMenu()
      {
         super();
         this.builtInItems = new ContextMenuBuiltInItems();
         this.customItems = new Array();
      }
      
      [API("667")]
      public static function get isSupported() : Boolean
      {
         return true;
      }
      
      public function hideBuiltInItems() : void
      {
         var items:ContextMenuBuiltInItems = this.doGetBuiltInItems();
         if(items != null)
         {
            items.save = false;
            items.zoom = false;
            items.quality = false;
            items.play = false;
            items.loop = false;
            items.rewind = false;
            items.forwardAndBack = false;
            items.print = false;
         }
      }
      
      public function get builtInItems() : ContextMenuBuiltInItems
      {
         if(this.doGetBuiltInItems() == null)
         {
            this.doSetBuiltInItems(new ContextMenuBuiltInItems());
         }
         this.hideBuiltInItems();
         return this.doGetBuiltInItems();
      }
      
      public function set builtInItems(value:ContextMenuBuiltInItems) : void
      {
         this.doSetBuiltInItems(value);
         this.hideBuiltInItems();
      }
      
      private native function doGetBuiltInItems() : ContextMenuBuiltInItems;
      
      private native function doSetBuiltInItems(param1:ContextMenuBuiltInItems) : void;
      
      public function get customItems() : Array
      {
         if(!this.m_customItems)
         {
            this.m_customItems = new Array();
         }
         return this.m_customItems;
      }
      
      public function set customItems(value:Array) : void
      {
         var i:int = 0;
         var obj:Object = null;
         var item:ContextMenuItem = null;
         var separator:NativeMenuItem = null;
         if(Boolean(value) && !(value is Array))
         {
            Error.throwError(ArgumentError,2005,"value");
         }
         var n:uint = uint(super.numItems);
         for(i = 0; i < n; i++)
         {
            super.removeItemAt(0);
         }
         if(value != null)
         {
            for(i = 0; i < value.length; i++)
            {
               obj = value[i];
               if(obj is ContextMenuItem)
               {
                  item = obj as ContextMenuItem;
                  if(item.visible)
                  {
                     if(item.separatorBefore)
                     {
                        separator = new NativeMenuItem("",true);
                        super.addItemAt(separator,super.numItems);
                     }
                     super.addItemAt(item,super.numItems);
                  }
               }
               else
               {
                  super.addItemAt(NativeMenuItem(obj),super.numItems);
               }
            }
         }
         if(this.m_link != null)
         {
            if(Boolean(value) && value.length > 0)
            {
               item.separatorBefore = true;
               separator = new NativeMenuItem("",true);
               super.addItemAt(separator,super.numItems);
            }
            item = ContextMenuItem.systemOpenLinkMenuItem();
            super.addItemAt(item,super.numItems);
            item = ContextMenuItem.systemCopyLinkMenuItem();
            super.addItemAt(item,super.numItems);
         }
         if(this.m_showClipboardMenu)
         {
            item = ContextMenuItem.systemCutMenuItem();
            item.enabled = Boolean(this.m_clipboardItems) && Boolean(this.m_clipboardItems.cut);
            if(Boolean(value) && Boolean(value.length > 0) || this.m_link != null)
            {
               item.separatorBefore = true;
               separator = new NativeMenuItem("",true);
               super.addItemAt(separator,super.numItems);
            }
            super.addItemAt(item,super.numItems);
            item = ContextMenuItem.systemCopyMenuItem();
            item.enabled = Boolean(this.m_clipboardItems) && Boolean(this.m_clipboardItems.copy);
            super.addItemAt(item,super.numItems);
            item = ContextMenuItem.systemPasteMenuItem();
            item.enabled = Boolean(this.m_clipboardItems) && Boolean(this.m_clipboardItems.paste);
            super.addItemAt(item,super.numItems);
            item = ContextMenuItem.systemClearMenuItem();
            item.enabled = Boolean(this.m_clipboardItems) && Boolean(this.m_clipboardItems.clear);
            super.addItemAt(item,super.numItems);
            item = ContextMenuItem.systemSelectAllMenuItem();
            item.enabled = Boolean(this.m_clipboardItems) && Boolean(this.m_clipboardItems.selectAll) || !this.m_clipboardItems;
            super.addItemAt(item,super.numItems);
         }
         this.m_customItems = value;
      }
      
      [Version("10")]
      public function get link() : URLRequest
      {
         return this.m_link;
      }
      
      [Version("10")]
      public function set link(value:URLRequest) : void
      {
         if(Boolean(value) && !(value is URLRequest))
         {
            Error.throwError(ArgumentError,2005,"value");
         }
         this.m_link = value;
      }
      
      [Version("10")]
      public function get clipboardMenu() : Boolean
      {
         return this.m_showClipboardMenu;
      }
      
      [Version("10")]
      public function set clipboardMenu(value:Boolean) : void
      {
         this.m_showClipboardMenu = value;
      }
      
      [Version("10")]
      public function get clipboardItems() : ContextMenuClipboardItems
      {
         if(!this.m_clipboardItems)
         {
            this.m_clipboardItems = new ContextMenuClipboardItems();
         }
         return this.m_clipboardItems;
      }
      
      [Version("10")]
      public function set clipboardItems(value:ContextMenuClipboardItems) : void
      {
         if(Boolean(value) && !(value is ContextMenuClipboardItems))
         {
            Error.throwError(ArgumentError,2005,"value");
         }
         this.m_clipboardItems = value;
      }
      
      override public function get numItems() : int
      {
         return this.items.length;
      }
      
      override public function get items() : Array
      {
         return this.customItems;
      }
      
      override public function set items(itemArray:Array) : void
      {
         this.customItems = itemArray;
      }
      
      override public function addItemAt(item:NativeMenuItem, index:int) : NativeMenuItem
      {
         if(index > this.numItems || index < 0)
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
         this.items.splice(index,0,item);
         return item;
      }
      
      override public function containsItem(item:NativeMenuItem) : Boolean
      {
         if(item == null)
         {
            Error.throwError(ArgumentError,2007,"item");
         }
         return this.items.indexOf(item) != -1;
      }
      
      override public function getItemAt(index:int) : NativeMenuItem
      {
         if(index >= this.numItems || index < 0)
         {
            Error.throwError(RangeError,2006);
         }
         return this.items[index];
      }
      
      override public function removeItemAt(index:int) : NativeMenuItem
      {
         if(index >= this.numItems || index < 0)
         {
            Error.throwError(RangeError,2006);
         }
         var item:* = this.items[index];
         this.items.splice(index,1);
         return item;
      }
      
      override public function getItemIndex(item:NativeMenuItem) : int
      {
         if(item == null)
         {
            Error.throwError(ArgumentError,2007,"item");
         }
         return this.items.indexOf(item);
      }
      
      override public function removeAllItems() : void
      {
         var i:int = 0;
         var nbItems:int = this.numItems;
         for(i = 0; i < nbItems; i++)
         {
            this.removeItemAt(0);
         }
      }
      
      internal function _openLink() : void
      {
         if(Boolean(this.m_link))
         {
            navigateToURL(this.m_link);
         }
      }
      
      internal function _copyLink() : void
      {
         if(Boolean(this.m_link))
         {
            Clipboard.generalClipboard.setData(ClipboardFormats.URL_FORMAT,this.m_link.url);
            Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT,this.m_link.url);
         }
      }
      
      override public function display(stage:Stage, stageX:Number, stageY:Number) : void
      {
         this.customItems = this.m_customItems;
         super.display(stage,stageX,stageY);
      }
      
      override public function clone() : NativeMenu
      {
         var i:uint = 0;
         var newMenu:ContextMenu = new ContextMenu();
         for(i = 0; i < this.items.length; i++)
         {
            newMenu.addItem(this.items[i].clone());
         }
         newMenu.m_showClipboardMenu = this.m_showClipboardMenu;
         newMenu.m_clipboardItems = Boolean(this.m_clipboardItems) ? this.m_clipboardItems.clone() : null;
         newMenu.m_link = this.m_link;
         return newMenu;
      }
   }
}


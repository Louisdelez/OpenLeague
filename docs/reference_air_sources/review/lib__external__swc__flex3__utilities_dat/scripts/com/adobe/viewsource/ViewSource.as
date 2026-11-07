package com.adobe.viewsource
{
   import flash.display.InteractiveObject;
   import flash.events.ContextMenuEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   
   public class ViewSource
   {
      
      public function ViewSource()
      {
         super();
      }
      
      public static function addMenuItem(obj:InteractiveObject, url:String, hideBuiltIns:Boolean = true) : void
      {
         var item:ContextMenuItem = null;
         if(obj.contextMenu == null)
         {
            obj.contextMenu = new ContextMenu();
            if(hideBuiltIns)
            {
               obj.contextMenu.hideBuiltInItems();
            }
         }
         item = new ContextMenuItem("View Source");
         item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,function(event:ContextMenuEvent):void
         {
            if(event.target == item)
            {
               navigateToURL(new URLRequest(url),"_blank");
            }
         });
         obj.contextMenu.customItems.push(item);
      }
   }
}


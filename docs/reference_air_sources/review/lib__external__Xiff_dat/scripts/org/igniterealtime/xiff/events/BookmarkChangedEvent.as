package org.igniterealtime.xiff.events
{
   import flash.events.Event;
   import org.igniterealtime.xiff.bookmark.GroupChatBookmark;
   import org.igniterealtime.xiff.bookmark.UrlBookmark;
   
   public class BookmarkChangedEvent extends Event
   {
      
      public static const GROUPCHAT_BOOKMARK_ADDED:String = "groupchat bookmark retrieved";
      
      public static const GROUPCHAT_BOOKMARK_REMOVED:String = "groupchat bookmark removed";
      
      public var groupchatBookmark:GroupChatBookmark = null;
      
      public var urlBookmark:UrlBookmark = null;
      
      public function BookmarkChangedEvent(param1:String, param2:*)
      {
         super(param1);
         if(param2 is GroupChatBookmark)
         {
            this.groupchatBookmark = param2 as GroupChatBookmark;
         }
         else
         {
            this.urlBookmark = param2 as UrlBookmark;
         }
      }
   }
}

